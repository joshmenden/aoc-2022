#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
# content = File.read("i.txt")
# content = File.read("i2.txt")
content = File.read("input.txt")



sprite = [0, 1, 2]

class CRT
    def initialize(input)
        @input = input
        @cycle = 1
        @reg = 1
        @sprite = [0, 1, 2]
        @x_counter = 0
        @row = []
    end

    def solve
        @input.split("\n").each do |l|
            ls = l.split(" ")
            cmd = ls[0]
            val = ls[1].to_i unless ls.count < 2
        
            noop if cmd == "noop"
            addx(val) if cmd == "addx"
        end
    end

    def addx(val)
        draw_pixel
        bump_cycle

        draw_pixel
        bump_cycle
        @reg += val
        @sprite = [@reg - 1, @reg, @reg + 1]
    end

    def noop
        draw_pixel
        bump_cycle
    end

    def bump_cycle
        @cycle += 1
        @x_counter += 1
        if @x_counter > 39
            @x_counter = 0
            puts @row.join("")
            @row = []
        end
    end

    def draw_pixel
        if @sprite.include?(@x_counter)
            @row << "x"
        else
            @row << "."
        end
    end
end


crt = CRT.new(content)
crt.solve

puts "Get coding!"