#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

class Blueprint
  RESOURCES = [ :ore, :clay, :obsidian, :geode ]

  attr_accessor :id, :robot_costs, :quality

  def initialize(id, robot_costs)
    @id = id
    @robot_costs = robot_costs
    @quality = nil
    @current_max = 0
  end

  def can_afford?(robot_type, resources)
    @robot_costs[robot_type].all? {|k, v| resources[k].present? && resources[k] >= v}
  end

  def mine(robots, resources)
    new_r = JSON.parse(resources.to_json).symbolize_keys
    robots.each { |r| new_r[r.robot_type.to_sym].present? ? new_r[r.robot_type.to_sym] += 1 : new_r[r.robot_type.to_sym] = 1 }

    return new_r
  end

  def purchase_robot(robot, resources)
    new_r = JSON.parse(resources.to_json).symbolize_keys
    @robot_costs[robot.robot_type].each { |material, cost| new_r[material] -= cost }

    return new_r
  end

  def purchase_then_mine(robots, robot_to_purchase, resources)
    new_r = purchase_robot(robot_to_purchase, resources)
    new_r = mine(robots, new_r)

    new_r
  end

  def calculate_quality
    robots = [Robot.new(:ore)]
    next_minute(robots)
  end

  def triangular_number(n)
    (1..n).sum
  end

  def cant_possibly_beat_max(resources, robots, minutes)
    geodes = resources[:geode].present? ? resources[:geode] : 0
    geodes + (robots.select {|r| r.robot_type == :geode }.count * minutes) + triangular_number(minutes) <= @current_max
  end

  def next_minute(robots, minutes = 24, resources = {})
    if minutes == 0
      geodes = resources[:geode].present? ? resources[:geode] : 0
      @current_max = [geodes, @current_max].max
      return geodes
    end

    return 0 if cant_possibly_beat_max(resources, robots, minutes)

    new_robots = RESOURCES.map {|r| Robot.new(r) }.select {|rbs| can_afford?(rbs.robot_type, resources)}

    potentials = new_robots.map {|r| next_minute(robots.map {|r| Robot.new(r.robot_type)} << r, minutes.dup - 1, purchase_then_mine(robots, r, resources)) }

    return [
      *potentials,
      next_minute(robots, minutes -= 1, mine(robots, resources)) # no new robots, keep mining
    ].max
  end
end

class Robot
  attr_accessor :robot_type
  def initialize(robot_type)
    @robot_type = robot_type
  end
end

class Solution
  def initialize(filename, params)
    @data = File.read(filename)
    @params = params
    @blueprints = []

    parse_data
  end

  def parse_data
    @data.split("\n").each do |l|
      id, ore_ore, clay_ore, obs_ore, obs_clay, geode_ore, geode_obs = l.scan(/-?\d+/).map(&:to_i)
      @blueprints << Blueprint.new(id, {
        ore: {ore: ore_ore},
        clay: {ore: clay_ore},
        obsidian: {ore: obs_ore, clay: obs_clay},
        geode: {ore: geode_ore, obsidian: geode_obs}
      })
    end
  end

  def pt1
    res = @blueprints.map(&:calculate_quality)
    byebug
    res.inject(0, :+)
  end

  def pt2
  end
end

filename = "sample.txt"
# filename = "input.txt"
puts Solution.new(filename, {}).pt1
puts Solution.new(filename, {}).pt2