require "matrix"

path = File.join(__dir__, 'input.txt')

input = File.read(path).each_line(chomp: true).map do |line|
  dir, distance = line.split(" ")
  [dir, distance.to_i]
end

START = [0, 0]

def to_distance(distance)
  {
    "R": [distance, 0],
    "L": [-distance, 0],
    "D": [0, -distance],
    "U": [0, distance]
  }
end

def manhattan((x1, y1), (x2, y2))
  (x1-x2).abs + (y1-y2).abs
end

def goto((x, y), (dir, distance))
  unit_vector = to_distance(1)[dir.to_sym]
  
  steps = distance.times.map do |index|
    dx, dy = unit_vector
    [x + dx * (index + 1) , y + dy* (index + 1)]
  end

  steps
end

def touching?(p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  
  distance = manhattan(p1, p2)
  return true if distance == 0
  
  return true if distance == 1
  
  # diagonal 
  return true if distance == 2 && (x1 - x2).abs == 1 && (y1 - y2).abs == 1
    
  false
end

DIAGONAL = [-1, 1].repeated_permutation(2).to_a

def pull_tail(head, tail)
  return tail if touching?(head, tail)
  vh = Vector[*head]
  vt = Vector[*tail]
  d = vh - vt

  if d[0] == 0 || d[1] == 0
    p "horizontal: #{tail} -> #{head}"
    vdelta = Vector[*d.normalize.to_a.map(&:to_i)]
    return (vt + vdelta).to_a
  else
    p "diagonal: #{tail} -> #{head}"
    candidates = DIAGONAL.map {[tail[0] + _1[0], tail[1] + _1[1]]}

    # p "candidates #{candidates}"
    new_tail = candidates.find do |candidate|
      touching?(candidate, head)
    end

    new_tail
  end
  
  
 
end

# p pull_tail([0,0], [1, 2])
# p touching?([0,0], [0,0])
# p touching?([0,0], [1,0])
# p touching?([0,0], [-1,0])
# p touching?([0,0], [0,1])
# p touching?([0,0], [0,-1])
# p touching?([0,0], [1,1])
# p touching?([0,0], [1,-1])
# p touching?([0,0], [-1,1])
# p touching?([0,0], [-1,-1])
# p touching?([0,0], [2,0])

result = input.inject(head: START, tail: START, trail: [START]) do |hash, command|
  p "-- command #{command}"
  steps = goto(hash[:head], command)
  
  new_trail, _ = steps.inject([[], hash[:tail]]) do |(trail, current_tail), new_head|
    # p "trail #{trail} current_tail #{current_tail} new_head #{new_head}"
    next_tail = pull_tail(new_head, current_tail)
    p "next_tail #{next_tail}"
    trail << next_tail

    [trail, next_tail]
  end
  

  hash[:trail] +=new_trail
  hash[:tail] = new_trail.last
  hash[:head] = steps.last

  hash
end
p "end"
p result[:trail].uniq{_1[0] + _1[1] * 1000}.count
