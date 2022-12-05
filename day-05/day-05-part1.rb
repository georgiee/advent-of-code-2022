path = File.join(__dir__, 'input.txt')


visual, instructions = File.read(path).split("\n\n")


visual = visual.each_line(chomp: true).to_a
result = visual.map do |line|
  value = line.split("").each_slice(4).map{_1.join}.to_a
  value.map{_1.strip}.map{_1[/([A-Z]|\d)/, 1]}
end.transpose

initial_stacks = result.map{|row| row.reject{_1.nil?}}.map{_1[0..-2].reverse}

instructions = instructions.each_line(chomp: true).to_a
regex = /move (\d+) from (\d+) to (\d+)/

instructions = instructions.map do |instruction|
  result = regex.match(instruction)
  result = [result[1], result[2], result[3]].map(&:to_i)
end

stack = initial_stacks.dup
p stack
# process
instructions.each do |(amount, source, destination)|
  items = stack[source - 1].pop(amount)
  stack[destination - 1].push(*items.reverse)
end

result = stack.map{_1.last}
p result.join
