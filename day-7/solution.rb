#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
content = File.read("input.txt")

# 1097622 is wrong

DIR_SIZES = {}

class Dir
    attr_accessor :id, :dirname, :parent, :children, :size

    def initialize(dirname: nil, parent: nil, children: Hash.new)
        @id = SecureRandom.uuid
        @dirname = dirname
        @parent = parent
        @children = children
        @size = 0
    end

    def size
        sz = calculate_size(self, 0)
        DIR_SIZES[@id] = sz
        return sz
    end

    def calculate_size(dir, curr_size)
        # byebug
        dir.children.values.each do |ch|
            curr_size += ch.size
        end

        return curr_size
    end
end

class MyFile
    attr_accessor :id, :filename, :size

    def initialize(filename: nil, size: nil)
        @id = SecureRandom.uuid
        @filename = filename
        @size = size
    end
end

root = Dir.new(dirname: "/")
cursor = root
content.split("\n").each_with_index do |cmd, index|
    next if index <= 1

    d = cmd.split(" ")

    # byebug
    if d[0] == "dir"
        cursor.children[d[1]] = Dir.new(dirname: d[1], parent: cursor)
    elsif d[0] != "$"
        cursor.children[d[1]] = MyFile.new(filename: d[1], size: d[0].to_i)
    elsif d[0] == "$"
        if d[1] == "cd" && d[2] == ".."
            cursor = cursor.parent
        elsif d[1] == "cd"
            cursor = cursor.children[d[2]]
        elsif d[1] == "ls" # do nothing
        end
    end
end

puts root.size
puts DIR_SIZES.values.reject {|num| num >= 100000 }.inject(0, :+)