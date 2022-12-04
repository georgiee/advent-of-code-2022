path = File.join(__dir__, 'input.txt')


def intersect_compartment(rucksack)
  size = rucksack.count
  p1 = rucksack[0...size/2]
  p2 = rucksack[size/2..]

  p1.intersection(p2)
end

input = File.read(path).each_line(chomp: true).map{_1.split("")}
result = input.map do |rucksack|
  intersect_compartment(rucksack).first
end

def is_upper?(chr)
  chr == chr.upcase
end

def calc_priority(char)
  if is_upper?(char)
    char.ord - 38
  else
    char.ord - 96
  end
end

p result.map {calc_priority(_1)}.sum
