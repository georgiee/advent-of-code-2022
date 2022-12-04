path = File.join(__dir__, 'input.txt')


input = File.read(path).each_line(chomp: true).map{_1.split(',')}
input = input.map{_1.map { |pair| pair.split('-').map(&:to_i) }}
input = input.map {|a,b| [a[0]..a[1], b[0]..b[1]]}

p input.count{|a, b| a.cover?(b) || b.cover?(a)}
