#!/usr/bin/env ruby

require "byebug"
require "active_support/all"
# content = File.read("i.txt")
# content = File.read("i2.txt")
content = File.read("input.txt")

class Monkey
    attr_accessor :id, :items, :inspections, :op_lambda, :test_lambda, :true_monkey, :false_monkey, :test_val
    def initialize(id:)
        @id = id
        @items = items
        @op_lambda = op_lambda
        @test_lambda = test_lambda
        @test_val = nil
        @inspections = 0
        @true_monkey = nil
        @false_monkey = nil
    end
end

monkeys = []
curr_m = nil
content.split("\n").each_with_index do |l, ind|
    if l == ""
        monkeys << curr_m
        curr_m = nil
        next
    elsif l.start_with?("Monkey")
        curr_m = Monkey.new(id: l.split(" ")[1].to_i)
        next
    elsif l.include?("Starting")
        items = l.split(" ")
        items.shift(2)
        items.map!(&:to_i)
        curr_m.items = items
    elsif l.include?("Operation")
        op = l.split(" ")
        op.shift(3)
        eval_str = op.join(" ")
        curr_m.op_lambda = lambda do |old|
            str = eval_str
            return eval(eval_str)
        end
    elsif l.include?("Test")
        op = l.split(" ")
        divisible_by = op.pop().to_i
        curr_m.test_val = divisible_by
        curr_m.test_lambda = lambda do |val|
            return (val % divisible_by) == 0
        end
    elsif l.include?("If true:")
        curr_m.true_monkey = l.split(" ").pop().to_i
    elsif l.include?("If false:")
        curr_m.false_monkey = l.split(" ").pop().to_i
    end

    if (ind == content.split("\n").count - 1)
        monkeys << curr_m
        curr_m = nil
        next
    end
end

least_common_multiple = monkeys.map(&:test_val).reduce(:lcm)

10000.times do
    monkeys.each do |monkey|
        loop do
            break if monkey.nil?
            break if monkey.items.count == 0
            monkey.inspections += 1
            item = monkey.items.shift()
            newv = monkey.op_lambda.call(item) % least_common_multiple
            if monkey.test_lambda.call(newv)
                monkeys[monkey.true_monkey].items << newv
            else
                monkeys[monkey.false_monkey].items << newv
            end
        end
    end
end

insps = monkeys.map(&:inspections)
puts insps.max(2).inject(:*)