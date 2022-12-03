#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
fname = "input.txt"
content = File.read(fname)

total = 0
content.split("\n").in_groups_of(3).each do |r_group|
    commons = r_group[0].split("") & r_group[1].split("") & r_group[2].split("")
    c = commons[0]
    if c == c.upcase
        total += (c.ord - 38)
    else
        total += (c.ord - 96)
    end
end

puts total