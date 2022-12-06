#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
content = File.read("input.txt")

curr = []
content.split("").each_with_index do |c, index|
    if curr.count < 14
        curr << c
        next
    end

    if curr.count == curr.uniq.count
        puts index
        break
    else
        curr.shift
        curr << c
    end
end
