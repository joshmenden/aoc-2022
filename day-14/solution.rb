#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require "benchmark"

rock = []
sands = 0
origin = [500, 0]
added = []
path = [origin]

File.read("input.txt").split("\n").each do |line|
    points = line.split(" -> ").map {|p| p.split(",").map(&:to_i)}
    points.each_with_index do |point, i|
        rock << point
        next if i == points.count - 1

        to = points[i + 1]

        if point[0] > to[0]
            for c in 1..(point[0] - to[0] - 1) do
                rock << [to[0] + c, to[1]]
            end
        elsif point[0] < to[0]
            for c in 1..(to[0] - point[0] - 1) do
                rock << [point[0] + c, point[1]]
            end
        elsif point[1] > to[1]
            for c in 1..(point[1] - to[1] - 1) do
                rock << [to[0], to[1] + c]
            end
        elsif point[1] < to[1]
            for c in 1..(to[1] - point[1] - 1) do
                rock << [point[0], point[1] + c]
            end
        end

        rock.uniq!
    end
end

FLOOR = rock.map(&:last).max + 2

def floor_below?(sand_location)
    return sand_location[1] + 1 == FLOOR
end

def rock_below?(rocks, sand_location)
    return true if floor_below?(sand_location)
    return rocks.include?([sand_location[0], sand_location[1] + 1])
end

def rock_left?(rocks, sand_location)
    return true if floor_below?(sand_location)
    return rocks.include?([sand_location[0] - 1, sand_location[1] + 1])
end

def rock_right?(rocks, sand_location)
    return true if floor_below?(sand_location)
    return rocks.include?([sand_location[0] + 1, sand_location[1] + 1])
end

def place_sand(rocks, path = [])
    sand_location = path.last
    return nil if path.empty?
    return nil if sand_location[1] >= FLOOR

    return place_sand(rocks, path << [sand_location[0], sand_location[1] + 1]) if !rock_below?(rocks, sand_location)
    return place_sand(rocks, path << [sand_location[0] - 1, sand_location[1] + 1]) if !rock_left?(rocks, sand_location)
    return place_sand(rocks, path << [sand_location[0] + 1, sand_location[1] + 1]) if !rock_right?(rocks, sand_location)

    path.pop
    return [sand_location, path]
end

time = Benchmark.measure do
    loop do
        ends_up, path = place_sand(rock, path)
        break if ends_up.nil?
        rock << ends_up
        sands += 1
    end
end

puts "placed #{sands} in #{time.real.round(2)}s"