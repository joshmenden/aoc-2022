#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

def compare_packets(p1, p2)
    v1 = p1.shift
    v2 = p2.shift

    if v1.nil? && !v2.nil?
        return true
    elsif !v1.nil? && v2.nil?
        return false
    elsif v1.nil? && v2.nil?
        return nil
    end

    first_comp = nil
    if v1.is_a?(Array) && v2.is_a?(Array)
        first_comp = compare_packets(v1, v2)
    elsif v1.is_a?(Array) && !v2.is_a?(Array)
        first_comp = compare_packets(v1, [v2])
    elsif !v1.is_a?(Array) && v2.is_a?(Array)
        first_comp = compare_packets([v1], v2)
    elsif !v1.is_a?(Array) && !v2.is_a?(Array)
        if v1 == v2
            first_comp = nil
        else
            first_comp = v1 < v2
        end
    end

    return compare_packets(p1, p2) if first_comp.nil?
    return false if first_comp == false
    return true if first_comp == true
end

packets = []

File.read("input.txt").split("\n\n").each_with_index {|pair, index| packets += pair.split("\n").map {|c| JSON.parse(c) } }

div1 = [[2]]
div2 = [[6]]
packets << div1
packets << div2

sorted = packets.sort {|a, b| compare_packets(JSON.parse(a.to_json), JSON.parse(b.to_json)) ? -1 : 1 }

puts (sorted.index(div1) + 1) * (sorted.index(div2) + 1)
puts "Get coding!"
