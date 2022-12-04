path = File.join(__dir__, 'input.txt')


def intersect_compartment(rucksack)
  size = rucksack.count
  p1 = rucksack[0...size/2]
  p2 = rucksack[size/2..]

  p1.intersection(p2)
end

input = File.read(path).each_line(chomp: true).map{_1.split("")}
badges = input.each_slice(3).map do |(a,b,c)|
  badge = a.intersection(b,c)
  p badge
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

p badges.flatten.map {calc_priority(_1)}.sum
