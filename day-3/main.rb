#!/usr/bin/env ruby

require "byebug"
fname = "input.txt"
content = File.read(fname)

class Rucksack
    attr_accessor :compartments
    def initialize(rucksack_str)
      rucksack_arr = rucksack_str.split("")
      @compartments = rucksack_arr.each_slice((rucksack_arr.count/2.0).round).to_a
    end

    def commons
        @compartments[0] & @compartments[1]
    end

    def priority_value
        c = commons[0]
        if c == c.upcase
            return c.ord - 38
        else
            return c.ord - 96
        end
    end
    
end

rucksacks = []
content.split("\n").each do |rucksack_str|
    r = Rucksack.new(rucksack_str)
    rucksacks << r
end

puts rucksacks.map(&:priority_value).inject(0, :+)