#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
# content = File.read("i.txt")
content = File.read("input.txt")

rows = content.split("\n")
rows.map! {|r| r.split("").map(&:to_i) }

class Solver
    def initialize(grid)
      @grid = grid
      @tree_score = 0
    end

    def highest_tree_score
        @grid.each_with_index do |row, r_index|
            row.each_with_index do |column, c_index|
                ts = tree_score?(r_index, c_index)
                @tree_score = ts unless @tree_score > ts
            end
        end

        return @tree_score
    end

    def tree_score?(row, column)
        t_val = @grid[row][column]

        return left_distance(t_val, row, column) * right_distance(t_val, row, column) * top_distance(t_val, row, column) * bottom_distance(t_val, row, column)
    end

    def left_distance(val, row, column)
        return 0 if column == 0
        return 1 if val <= @grid[row][column - 1]

        return 1 + left_distance(val, row, column - 1)
    end

    def right_distance(val, row, column)
        return 0 if column == @grid[0].count - 1
        return 1 if val <= @grid[row][column + 1]

        return 1 + right_distance(val, row, column + 1)
    end

    def bottom_distance(val, row, column)
        return 0 if row == @grid.count - 1
        return 1 if val <= @grid[row + 1][column]

        return 1 + bottom_distance(val, row + 1, column)
    end

    def top_distance(val, row, column)
        return 0 if row == 0
        return 1 if val <= @grid[row - 1][column]

        return 1 + top_distance(val, row - 1, column)
    end
end

# byebug
sv = Solver.new(rows)

puts sv.highest_tree_score
puts "Get coding!"