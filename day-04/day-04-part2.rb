path = File.join(__dir__, 'input.txt')


input = File.read(path).each_line(chomp: true).map{_1.split(',')}
input = input.map{_1.map { |pair| pair.split('-').map(&:to_i) }}
input = input.map {|a,b| [a[0]..a[1], b[0]..b[1]]}

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

p input.count{|a, b| a.overlaps?(b) || b.overlaps?(a)}
