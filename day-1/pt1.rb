require "byebug"
require_relative "../helpers/elf"
fname = "input.txt"
content = File.read(fname)

puts Elf.arrange_elves(content).map(&:calories).max