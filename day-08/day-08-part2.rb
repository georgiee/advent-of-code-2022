path = File.join(__dir__, 'input.txt')

input = File.read(path).each_line(chomp: true)

trees_data = input.each_with_index.inject({}) do |memo, (row, y)|
  row.split("").each_with_index do |value, x|
    memo[[x,y]] = value.to_i
  end
  memo
end


class Forest
  include Enumerable

  # left, bottom, right, top
  NEIGHBOURS = [[-1, 0],  [0, 1], [1, 0], [0, -1]]

  def initialize(trees, size)
    @trees = trees
    @size = size
  end

  def sightline(x,y, direction)
    coordinates = case direction
                  when :left
                    (x).times.collect { |bit| [x + -1 * bit - 1, y] }
                  when :top
                    (y).times.collect { |bit| [x, y + -1 * bit - 1] }
                  when :right
                    (@size - x - 1).times.collect { |bit|  [x +  1 * bit + 1, y]  }
                  when :bottom
                    (@size - y - 1).times.collect { |bit| [x, y + 1 * bit + 1] }
                  end
    coordinates.map { |(x, y)| self[x, y]}
  end

  def score(x, y)
    me = self[x,y]
    # p "check #{me} #{[x,y]}"
    other_trees = [:top, :left, :right, :bottom].map do |direction|
      line = sightline(x,y, direction)
      res = line.inject([]) do |sum, height|
        if height >= me
          break sum << height
        end

        sum << height
      end

      res
    end


    other_trees.map {_1.count}.inject(:*)
  end

  def each(&block)
    @trees.each {block.call _1[0]}
  end

  def [](x,y)
    @trees[[x,y]]
  end

end

forest = Forest.new(trees_data, input.to_a[0].split("").count)

scores = forest.map do |(x,y)|
  forest.score(x, y)
end

p scores.max
