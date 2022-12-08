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
      @visible = 0
    end

    def count_visible
        @grid.each_with_index do |row, r_index|
            row.each_with_index do |column, c_index|
                @visible += 1 if is_visible?(r_index, c_index)
            end
        end

        return @visible
    end

    def is_visible?(row, column)
        return true if row == 0
        return true if row == @grid.count - 1
        return true if column == 0
        return true if column == @grid[0].count - 1

        t_val = @grid[row][column]

        return true if taller_than_left_neighbors?(t_val, row, column - 1) || taller_than_right_neighbors?(t_val, row, column + 1) || taller_than_bottom_neighbors?(t_val, row + 1, column) || taller_than_top_neighbors?(t_val, row - 1, column)

    end

    def taller_than_left_neighbors?(val, row, column)
        return true if column == 0 && val > @grid[row][column]
        return false if val <= @grid[row][column]

        return true && taller_than_left_neighbors?(val, row, column - 1)
    end

    def taller_than_right_neighbors?(val, row, column)
        return true if column == (@grid[0].count - 1) && val > @grid[row][column]
        return false if val <= @grid[row][column]

        return true && taller_than_right_neighbors?(val, row, column + 1)
    end

    def taller_than_bottom_neighbors?(val, row, column)
        return true if row == (@grid.count - 1) && val > @grid[row][column]
        return false if val <= @grid[row][column]

        return true && taller_than_bottom_neighbors?(val, row + 1, column)
    end

    def taller_than_top_neighbors?(val, row, column)
        return true if row == 0 && val > @grid[row][column]
        return false if val <= @grid[row][column]

        return true && taller_than_top_neighbors?(val, row - 1, column)
    end
end

# byebug
sv = Solver.new(rows)

puts sv.count_visible
puts "Get coding!"