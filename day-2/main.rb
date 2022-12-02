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
        X: :rock,
        Y: :paper,
        Z: :scissors,
    }

    SCORES = {
        A: 0, # rock
        B: 1, # paper
        C: 2, # scissors
        X: 0, # rock
        Y: 1, # paper
        Z: 2, # scissors
    }

    def initialize(opp, my)
        @opp = opp.to_sym
        @my = my.to_sym
    end

    def score
        score = (SCORES[@my] + 1)
        score += 3 if draw?
        score += 6 if win?

        score
    end

    def win?
        opp_conv = CONVERSION[@opp]
        case CONVERSION[@my]
        when :rock
            return opp_conv == :scissors
        when :paper
            return opp_conv == :rock
        when :scissors
            return opp_conv == :paper
        end
    end

    def draw?
        SCORES[@my] == SCORES[@opp]
    end

    def result
        return "win" if win?
        return "draw" if draw?
        return "loss" if !win? && !draw?
    end
end

matches = []
content.split("\n").each do |line|
    choices = line.split(" ")
    matches << Match.new(choices[0], choices[1])
end

puts matches.map(&:score).inject(0, :+)
# puts matches.map(&:result)