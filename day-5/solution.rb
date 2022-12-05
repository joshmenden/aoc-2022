#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
content = File.read("input.txt")

stacks = [[], [], [], [], [], [], [], [], []]
content.split("\n").first(8).each do |l|
    chars = l.split("")
    stacks[0] << chars[1] unless chars[1].strip.empty?
    stacks[1] << chars[5] unless chars[5].strip.empty?
    stacks[2] << chars[9] unless chars[9].strip.empty?
    stacks[3] << chars[13] unless chars[13].strip.empty?
    stacks[4] << chars[17] unless chars[17].strip.empty?
    stacks[5] << chars[21] unless chars[21].strip.empty?
    stacks[6] << chars[25] unless chars[25].strip.empty?
    stacks[7] << chars[29] unless chars[29].strip.empty?
    stacks[8] << chars[33] unless chars[33].strip.empty?
end

stacks.map!(&:reverse)

content.split("\n")[10..-1].each do |l|
    words = l.split(" ")
    num = words[1].to_i
    from = words[3].to_i - 1
    to = words[5].to_i - 1

    vals = stacks[from].pop(num)
    stacks[to].concat(vals)
end

tops = stacks.map {|s| s.last}

puts tops.join("")