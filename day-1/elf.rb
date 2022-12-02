class Elf
    attr_accessor :calories

    def initialize(calories)
        @calories = calories
    end

    def self.arrange_elves(input_str)
        elves = []
        current_calories = 0
        input_str.split("\n").each_with_index do |line, index|
            if line.empty?
                current_calories += line.to_i if index == input_str.split("\n").length - 1
                elves << Elf.new(current_calories)
                current_calories = 0
            else
                current_calories += line.to_i
            end
        end

        return elves
    end
end