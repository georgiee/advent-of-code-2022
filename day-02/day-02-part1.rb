path = File.join(__dir__, 'input.txt')

SCORING_MAP = {
  :rock => :scissors,
  :paper =>  :rock,
  :scissors => :paper
}

SHAPES = {
  "X": :rock,
  "Y": :paper,
  "Z": :scissors,
  "A": :rock,
  "B": :paper,
  "C": :scissors
}

INDEX = {
  :rock => 1,
  :paper => 2,
  :scissors => 3
}

def calc_round_score(s1, s2)
  if SCORING_MAP[s1] == s2
    6
  elsif s1 == s2
    3
  else
    0
  end
end

def score(opponent, you)
  [calc_round_score(you, opponent),  INDEX[you]]
end

input = File.read(path).split.map{ SHAPES[_1.to_sym]}
rounds = p input.each_slice(2).to_a

total = rounds.map do |(opponent, you)|
  score(opponent, you)
end

p total.flatten.sum
