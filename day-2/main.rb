#!/usr/bin/env ruby

require "byebug"
fname = "input.txt"
content = File.read(fname)

class Match
    attr_accessor :opp, :my

    # scissors > paper > rock > scissors

    CONVERSION = {
        A: :rock,
        B: :paper,
        C: :scissors,
        X: :lose,
        Y: :draw,
        Z: :win,
    }

    SCORES = {
        :rock => 0,
        :paper => 1,
        :scissors => 2,
        :lose => 0,
        :draw => 3,
        :win => 6
    }

    def initialize(opp:, my: nil, result:)
        @opp = CONVERSION[opp.to_sym]
        @result = CONVERSION[result.to_sym]
        @my = needed_throw
    end

    def score
        score = (SCORES[@my] + 1)
        score += SCORES[@result]

        score
    end

    def needed_throw
        case @result
        when :lose
            return losing_throw(@opp)
        when :draw
            return @opp
        when :win
            return winning_throw(@opp)
        end
    end

    def winning_throw(against)
        case against
        when :rock
            return :paper
        when :paper
            return :scissors
        when :scissors
            return :rock
        end
    end

    def losing_throw(against)
        case against
        when :rock
            return :scissors
        when :paper
            return :rock
        when :scissors
            return :paper
        end
    end

end

matches = []
content.split("\n").each do |line|
    choices = line.split(" ")
    matches << Match.new(opp: choices[0], result: choices[1])
end

puts matches.map(&:score).inject(0, :+)