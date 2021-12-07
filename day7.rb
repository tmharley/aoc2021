def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = '16,1,2,0,4,2,7,1,2,14'
REAL_INPUT = import_from_file('day7_input.txt')

def part_one(input)
  start_positions = input.split(',').map(&:to_i)
  movement_costs = []
  (start_positions.min..start_positions.max).each do |i|
    movement_costs[i] = start_positions.map { |p| (p - i).abs }.reduce(&:+)
  end
  movement_costs.min
end

def part_two(input)
  start_positions = input.split(',').map(&:to_i)
  movement_costs = []
  (start_positions.min..start_positions.max).each do |i|
    movement_costs[i] = start_positions.map do |p|
      dist = (p - i).abs
      (dist * (dist + 1)) / 2
    end.reduce(&:+)
  end

  movement_costs.min
end

p part_one(TEST_INPUT) # should be 37
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 168
p part_two(REAL_INPUT)
