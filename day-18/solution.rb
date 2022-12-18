#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

cubes = File.read("input.txt").split("\n").map {|l| l.split(",").map(&:to_i)}
sides = ->(x, y, z) {[ [x+1,y,z], [x-1,y,z], [x,y+1,z], [x,y-1,z], [x,y,z+1], [x,y,z-1] ]}

puts cubes.map {|x, y, z| sides.call(x, y, z) }.flatten(1).select {|s| !cubes.include?(s) }.count

seen = Set[]
todo = [[-1,-1,-1]]

while !todo.empty?
    here = todo.pop
    filtered = sides[*here].to_a.select { |s| s.all? { |c| -1 <= c && c <= 25 } && !cubes.include?(s) && !seen.include?(s) }
    todo += filtered
    seen << here
end

puts cubes.map { |c| sides[*c] }.flatten(1).select { |s| seen.include?(s) }.count