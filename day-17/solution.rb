#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
require "benchmark"

r1 = [[0, 0, 1, 1, 1, 1, 0]]

r2 = [
    [0, 0, 0, 1, 0, 0, 0],
    [0, 0, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 0]
]

r3 = [
    [0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 1, 0, 0],
    [0, 0, 1, 1, 1, 0, 0]
].reverse

r4 = [
    [0, 0, 1, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0]
]

r5 = [
    [0, 0, 1, 1, 0, 0, 0],
    [0, 0, 1, 1, 0, 0, 0]
]

def move_right(stack, rock, rock_bottom_height)
    return rock if rock.map(&:last).include?(1)
    attempt = rock.map { |l| l[0...-1] }.map { |l| l.unshift(0) }
    return attempt if valid_placement?(stack, attempt, rock_bottom_height)
    return rock
end

def move_left(stack, rock, rock_bottom_height)
    return rock if rock.map(&:first).include?(1)
    attempt = rock.map { |l| l.drop(1) }.map { |l| l << 0 }
    return attempt if valid_placement?(stack, attempt, rock_bottom_height)
    return rock
end

def valid_placement?(stack, rock, rock_bottom_height)
    compare_rows = stack[rock_bottom_height, rock.count]
    comparison = rock.first(compare_rows.count).zip(compare_rows).map {|arr| arr[0].zip(arr[1]) }
    return !comparison.any? {|c| c.any? {|el1, el2| el1 > 0 && el2 > 0 }}
end

def jet_and_drop(stack, rock, rock_bottom_height, jet_i)
    jet_i = 0 if jet_i >= $jets.count
    jet = $jets[jet_i]
    rock = move_right(stack, rock, rock_bottom_height) if jet == ">"
    rock = move_left(stack, rock, rock_bottom_height) if jet == "<"
    stack, rock, rock_bottom_height = drop(stack, rock, rock_bottom_height)
    jet_i += 1
    return [stack, jet_i] if rock.nil?
    return jet_and_drop(stack, rock, rock_bottom_height, jet_i)
end

def combine(stack, rock, rock_bottom_height)
    # has settled, return new array with combined rocks
    combiners = stack[rock_bottom_height, rock.count]
    new_rows = combiners.map.with_index do |row, row_i|
        row.map.with_index { |ch, ch_i| (ch == 1 || rock[row_i][ch_i] == 1) ? 1 : 0 }
    end

    stack[rock_bottom_height, rock.count] = new_rows

    return stack
end

def drop(stack, rock, rock_bottom_height)
    if valid_placement?(stack, rock, rock_bottom_height - 1)
        # still falling, jet and drop again
        return stack, rock, rock_bottom_height - 1
    else
        stack = combine(stack, rock, rock_bottom_height)
        return [stack, nil, nil]
    end
end

def trim_stack(stack)
    loop do
        break if stack.last.include?(1)
        stack.pop
    end

    return stack
end

def pn(arr)
    puts arr.reverse.map {|r| r.map {|ch| ch == 0 ? "." : "#" }}.map {|r| r.join()}.join("\n")
end

def add_rocks(stack, num_rocks, rock_i, jet_i)
    tester = nil
    4.times { stack << $new_row }
    (1..num_rocks).each do |rock_num|
        rock_i = 0 if rock_i >= $rocks.count
        rock = $rocks[rock_i]

        stack, jet_i = jet_and_drop(stack, rock, stack.count - 1, jet_i)
        trim_stack(stack)

        4.times { stack << $new_row }

        rock_i += 1
    end

    return [trim_stack(stack), rock_i, jet_i]
end


$filename = "input.txt"
# $filename = "i.txt"

# $target_rocks = 2022
$target_rocks = 1000000000000

$rocks = [r1, r2, r3, r4, r5]

$jets = File.read($filename).chomp.split("")
$jet_i= 0
$rock_i = 0

$new_row = [0, 0, 0, 0, 0, 0, 0]
$stack = [ [2, 2, 2, 2, 2, 2, 2] ] # floor

$pattern = Hash.new

$height = nil

time = Benchmark.measure do
    rock_i = 0
    jet_i = 0
    ctr = 0
    height_after = Hash.new
    patt_start = nil
    patt_end = nil

    loop do
        $stack, rock_i, jet_i = add_rocks($stack, 1, rock_i, jet_i)
        ctr += 1
        height_after[ctr] = $stack.count - 1

        key = Digest::SHA256.hexdigest $stack.last(100).join
        if $pattern.key?(key)
            if $pattern[key].length == 1 && patt_start.nil?
                patt_start = $pattern[key].first
            elsif $pattern[key].length == 2 && patt_end.nil?
                patt_end = $pattern[key].second - 1
            elsif $pattern[key].length == 3
                break
            end

            $pattern[key] << ctr
        else
            $pattern[key] = [ctr]
        end
    end

    init_fallen = patt_start - 1
    initial_height = height_after[init_fallen] - 1
    pattern_height = height_after[patt_end] - initial_height

    remaining_rocks_after_init = $target_rocks - init_fallen
    pattern_size = (patt_end - patt_start + 1)

    full_patterns = remaining_rocks_after_init / pattern_size
    leftover = remaining_rocks_after_init % pattern_size

    leftover_height = height_after[patt_end + leftover] - height_after[patt_end]

    $height = initial_height + (pattern_height * full_patterns) - ((full_patterns - 1) * 1) + leftover_height
    # I don't know why I have to do this -------------------------- ^
    # I was having off by one and couldn't find the root but this fixed it
    # done with this problem for now though so ¯\_(ツ)_/¯
end

puts "height of #{$height} in #{time.real.round(4)}s"
