require "byebug"
require_relative "elf"
fname = "input.txt"
content = File.read(fname)

puts Elf.arrange_elves(content).map(&:calories).max