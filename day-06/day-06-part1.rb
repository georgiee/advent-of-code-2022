path = File.join(__dir__, 'input.txt')


signal = File.read(path).split("").reject{_1 == "\n"}

counter = 0
signal.each_cons(4) do |seq|
  counter+=1
  if seq.uniq.count == 4
    p counter + 3
    return 
  end
end
