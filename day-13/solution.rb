#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

valid_pairs = []

def compare_packets(p1, p2)
    # byebug
    v1 = p1.shift
    v2 = p2.shift

    if v1.nil? && !v2.nil?
        return true
    elsif !v1.nil? && v2.nil?
        return false
    elsif v1.nil? && v2.nil?
        return true
    elsif v1.is_a?(Array) && v2.is_a?(Array)
        return compare_packets(v1, v2) && compare_packets(p1, p2)
    elsif v1.is_a?(Array) && !v2.is_a?(Array)
        return compare_packets(v1, [v2]) && compare_packets(p1, p2)
    elsif !v1.is_a?(Array) && v2.is_a?(Array)
        return compare_packets([v1], v2) && compare_packets(p1, p2)
    elsif !v1.is_a?(Array) && !v2.is_a?(Array)
        if v1 == v2
            return compare_packets(p1, p2)
        else
            return v1 < v2
            # return v1 < v2 && compare_packets(p1, p2) # problem? need to compare all values? need an in between val?
        end
    end
end

File.read("input.txt").split("\n\n").each_with_index do |pair, index|
    # byebug
    p1, p2 = pair.split("\n").map {|c| JSON.parse(c) }
    if compare_packets(p1, p2)
        valid_pairs << index + 1
    end
end

byebug
puts valid_pairs.reduce(:+)


puts "Get coding!"
