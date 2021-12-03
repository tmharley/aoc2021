TEST_INPUT = <<~INPUT
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day2_input.txt')

def part_one(input)
  pos = 0
  depth = 0
  input.each_line do |line|
    direction, amount = line.split(' ')
    case direction
    when 'forward'
      pos += amount.to_i
    when 'down'
      depth += amount.to_i
    when 'up'
      depth -= amount.to_i
    end
  end
  pos * depth
end

def part_two(input)
  pos = 0
  depth = 0
  aim = 0
  input.each_line do |line|
    direction, amount = line.split(' ')
    case direction
    when 'forward'
      pos += amount.to_i
      depth += amount.to_i * aim
    when 'down'
      aim += amount.to_i
    when 'up'
      aim -= amount.to_i
    end
  end
  pos * depth
end

p part_one(TEST_INPUT) # should be 150
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 900
p part_two(REAL_INPUT)
