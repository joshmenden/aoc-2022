#!/usr/bin/env ruby

require "byebug"
require "active_support/all"

input = File.read("input.txt").split("\n").map! {|r| r.split("")}

puts "Happy Coding!"
