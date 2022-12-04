#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
content = File.read("input.txt")

overlaps = 0
content.split("\n").each do |pairing|
    assignments = pairing.split(",")
    a1_ends = assignments[0].split("-")
    a1 = [*a1_ends[0]..a1_ends[1]]

    a2_ends = assignments[1].split("-")
    a2 = [*a2_ends[0]..a2_ends[1]]

    # overlaps += 1 if a2.all? { |e| a1.include?(e) } || a1.all? { |e| a2.include?(e) } # part 1
    overlaps += 1 if a2.any? { |e| a1.include?(e) } || a1.any? { |e| a2.include?(e) } # part 2
end

puts overlaps