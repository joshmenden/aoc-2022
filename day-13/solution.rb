#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

valid_pairs = []

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

# File.read("i.txt").split("\n\n").each_with_index do |pair, index|
File.read("input.txt").split("\n\n").each_with_index do |pair, index|
    p1, p2 = pair.split("\n").map {|c| JSON.parse(c) }
    if compare_packets(p1, p2)
        valid_pairs << index + 1
    end
end

# byebug
puts valid_pairs.reduce(:+)


puts "Get coding!"
