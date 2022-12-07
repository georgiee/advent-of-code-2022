require 'ostruct'

path = File.join(__dir__, 'input.txt')


log = File.read(path).each_line(chomp: true).to_a

Folder = Struct.new(:files, :parent)


result = log[1..].inject({cwd: ['/'], fs: {}}) do |system, line|
  if folder = line[/\$ cd (.*)/, 1]
    if folder == ".."
      system[:cwd].pop
    else
      system[:cwd] << folder
    end
  end

  system[:fs][system[:cwd].join('\/')] ||= []
  
  if line[/\d+ (.*)/]
    size, name = /(\d+) (.*)/.match(line)[1 ,2]
    system[:fs][system[:cwd].join('\/')] << [size.to_i, name]
  end
  
  # p system
  system

end


fs = result[:fs]
# ok that list works but it misses the point of indirect files (folder in folders)
sizes = fs.each_with_object(Hash.new(0)) {|(key, value), h| h[key] += value.sum{_1[0]}}
p sizes
p sizes.values.reject{_1 > 100000}.sum

# paths = sizes.keys.map{_1.split('\/')}
# folders = Hash[]
