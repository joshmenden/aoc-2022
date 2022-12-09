#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
# content = File.read("i.txt")
content = File.read("input.txt")

class Rope
    attr_accessor :head, :tail, :visited, :knots
    def initialize
        # @head = [0, 0]
        @knots = [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
        ]

        @visited = [[0, 0]]
    end

    # def printit
    #     puts "step!"
    # end

    

    def move_right!(dist = 1)
        @knots[0] = [@knots[0][0] + dist, @knots[0][1]]
        move_all_knots
    end

    def move_left!(dist = 1)
        @knots[0] = [@knots[0][0] - dist, @knots[0][1]]
        move_all_knots
    end

    def move_up!(dist = 1)
        @knots[0] = [@knots[0][0], @knots[0][1] + dist]
        move_all_knots
    end

    def move_down!(dist = 1)
        @knots[0] = [@knots[0][0], @knots[0][1] - 1]
        move_all_knots
    end

    def tail
        @knots.last
    end

    def move_all_knots
        move_knots(0, 1)
        move_knots(1, 2)
        move_knots(2, 3)
        move_knots(3, 4)
        move_knots(4, 5)
        move_knots(5, 6)
        move_knots(6, 7)
        move_knots(7, 8)
        move_knots(8, 9)
    end

    def move_knots(ind1, ind2)
        return unless distance(@knots[ind1], @knots[ind2]) > 1

        if @knots[ind1][0] == @knots[ind2][0]
            @knots[ind2] = [@knots[ind2][0], (@knots[ind1][1] + @knots[ind2][1]) / 2]
        elsif @knots[ind1][1] == @knots[ind2][1]
            @knots[ind2] = [(@knots[ind1][0] + @knots[ind2][0]) / 2, @knots[ind2][1]]
        elsif is_diagonal?(@knots[ind1], @knots[ind2])
            # byebug
            # this below doesn't work because we have a condition where knots cound be [0, 0] and [2, 2] and need to end up in [1, 1]
            if (@knots[ind1][0] - @knots[ind2][0]).abs > 1 && (@knots[ind1][1] - @knots[ind2][1]).abs > 1
                @knots[ind2] = [(@knots[ind1][0] + @knots[ind2][0]) / 2, (@knots[ind1][1] + @knots[ind2][1]) / 2]
            elsif (@knots[ind1][0] - @knots[ind2][0]).abs > 1
                @knots[ind2] = [(@knots[ind1][0] + @knots[ind2][0]) / 2, @knots[ind1][1]]
            else
                @knots[ind2] = [@knots[ind1][0], (@knots[ind1][1] + @knots[ind2][1]) / 2]
            end
        end

        @visited << @knots[ind2].dup if @knots[ind2] == tail && !@visited.include?(@knots[ind2])
    end

    def distance(k1, k2)
        return [(k1[0] - k2[0]).abs, (k1[1] - k2[1]).abs].max
    end

    def is_diagonal?(k1, k2)
        return true if k1[0] != k2[0] && k1[1] != k2[1]
        false
    end
end

rope = Rope.new
content.split("\n").each do |l|
    cmd = l.split(" ")
    dir = cmd[0]
    dist = cmd[1].to_i

    dist.times do
        if dir == "R"
            rope.move_right!
        elsif dir == "L"
            rope.move_left!
        elsif dir == "U"
            rope.move_up!
        elsif dir == "D"
            rope.move_down!
        end

        # byebug
        # if diagnoal in middle of rope it stays diagonasdf
    end

    # byebug
end

puts rope.visited.count



puts "Get coding!"