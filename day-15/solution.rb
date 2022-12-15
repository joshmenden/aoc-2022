#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
  
class Grid
    attr_accessor :sensors, :coverage, :target_row

    def initialize(filename, target_row)
        @sensors = File.read(filename).split("\n").map! {|l| l.scan(/-?\d+/).map(&:to_i) }.map {|s| {
            loc: s.first(2),
            beacon: s.last(2),
            dist: manhattan(s.first(2), s.last(2))
        }}

        @target_row = target_row
    end

    def manhattan(pt1, pt2)
        (pt1[0]-pt2[0]).abs + (pt1[1]-pt2[1]).abs
    end

    def solve_pt1
        ranges = row_coverage(@target_row)
        bs = @sensors.map { |s| s[:beacon] }.reject { |b| b[1] != @target_row }.map { |b| b[0] }
        ranges -= bs.uniq
        ranges.uniq.count
    end

    def merge_all_ranges(ranges)
        ranges = ranges.sort_by(&:begin)
        consolidated = []
        curr = ranges.shift

        ranges.each do |range|
            new_range = merge_ranges(curr, range)
            if new_range.nil?
                consolidated << curr
                curr = range
            else
                curr = new_range
            end
        end

        consolidated << curr
        return consolidated.sort_by(&:begin)
    end

    def merge_ranges(range1, range2)
        return nil if range1.end < range2.begin || range2.end < range1.begin
    
        [range1.begin, range2.begin].min..[range1.end, range2.end].max
    end

    def row_coverage(row, map)
        ranges = []

        @sensors.each do |s|
            k = "x#{s[:loc][0]}:y#{s[:loc][1]}:r#{row}"
            next unless map[k].present?
            r = map[k]
            ranges << r
        end

        merge_all_ranges(ranges)
    end

    def solve_pt2(max)
        map = {}
        ct = 0
        @sensors.each do |s|
            puts "mapping sensor #{ct}"
            it = s[:dist]
            origin_x = s[:loc][1]
            row_counter = 0
            loop do
                break if it < 0
                map["x#{s[:loc][0]}:y#{s[:loc][1]}:r#{origin_x + row_counter}"] = (s[:loc][0] - it)..(s[:loc][0] + it)
                map["x#{s[:loc][0]}:y#{s[:loc][1]}:r#{origin_x - row_counter}"] = (s[:loc][0] - it)..(s[:loc][0] + it) unless row_counter == 0

                it -= 1
                row_counter += 1
            end
            
            ct += 1
        end

        x = nil
        y = nil

        max.times.each do |row|
            puts "checking row #{row}"
            break if x.present?
            ranges = row_coverage(row, map)
            return (ranges[0].end + 1) * 4000000 + row if ranges.count > 1
        end
    end
end

# grid = Grid.new("i.txt", 2000000)
# puts grid.solve_pt2(20)

grid = Grid.new("input.txt", 2000000)
puts grid.solve_pt2(4000000)

puts "Get coding!"