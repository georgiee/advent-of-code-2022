require 'ostruct'

path = File.join(__dir__, 'input.txt')


log = File.read(path).each_line(chomp: true).to_a

class Folder
  attr_accessor :name
  attr_accessor :parent
  attr_accessor :files
  
  def initialize(name, size, parent, is_folder = false)
    @name = name
    @size = size
    @parent = parent
    @files = [] if is_folder
  end
  
  def <<(file)
    @files << file
  end
  
  def path
    return @name if @parent.nil?
    [@parent.path, @name].join('/')
  end

  def file?
    @files.nil?
  end
  
  def folder?
    !@files.nil?
  end
  
  def size
    if file?
      @size
    else
      @files.sum{_1.size}
    end
  end
  
  def to_s
    path
  end
  
  def self.path(name, parent)
    [parent.path, name].join('/')
  end
end

root = Folder.new('<root>', 0, nil, true)

$fs = {}
def create_or_find_folder(name, parent)
  $fs[Folder.path(name, parent)] ||= Folder.new(name, 0, parent, true)
end

result = log[1..].inject({cwd: root, index: {}}) do |system, line|
  if folder = line[/\$ cd (.*)/, 1]
    if folder == ".."
      system[:cwd] = system[:cwd].parent
    else
      newFolder = create_or_find_folder(folder, system[:cwd])
      # add to current folder
      system[:cwd] << newFolder
      # switch to folder
      system[:cwd] = newFolder
    end
  end

  if line[/\d+ (.*)/]
    size, name = /(\d+) (.*)/.match(line)[1 ,2]
    system[:cwd] << Folder.new(name, size.to_i, system[:cwd])
  end
  
  # p system
  system

end

def print_tree(folder)
  if folder.folder?
    p "#{folder.path} (#{folder.size})"
    folder.files.each {print_tree _1}
  else
    p "#{folder.name} (#{folder.size})"
  end
end

# print_tree(root)
p $fs.values.reject{_1.file?}.map{_1.size}.reject{_1 > 100000}.sum

# fs = result[:fs]
# # ok that list works but it misses the point of indirect files (folder in folders)
# sizes = fs.each_with_object(Hash.new(0)) {|(key, value), h| h[key] += value.sum{_1[0]}}
# p sizes
# p sizes.values.reject{_1 > 100000}.sum

# paths = sizes.keys.map{_1.split('\/')}
# folders = Hash[]
