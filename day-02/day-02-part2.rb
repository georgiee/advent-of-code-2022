path = File.join(__dir__, 'input.txt')

SCORING_MAP = {
  :rock => :scissors,
  :paper =>  :rock,
  :scissors => :paper
}

SHAPES = {
  "A": :rock,
  "B": :paper,
  "C": :scissors,
  "X": :loose,
  "Y": :draw,
  "Z": :win,
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
rounds = input.each_slice(2).to_a

adjusted_rounds = rounds.map do |(opponent, expected_result)|
  # reverse lookup
  you = case expected_result
        when :draw
          opponent
        when :win
          SCORING_MAP.key(opponent)
        when :loose
          SCORING_MAP[opponent]
        end
  [opponent, you]
end

total = adjusted_rounds.map do |(opponent, you)|
  score(opponent, you)
end

p total.flatten.sum
