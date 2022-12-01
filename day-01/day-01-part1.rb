path = File.join(__dir__, 'input.txt')
lines = *File.readlines(path).to_a
input = File.read(path)

calories = input.split("\n\n").map{_1.split.map(&:to_i).sum}
p calories.max
