def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = '3,4,3,1,2'
REAL_INPUT = import_from_file('day6_input.txt')

def simulate(input, num_days)
  starting_fish = input.split(',').map(&:to_i)
  fish_count = Array.new(9) { 0 }
  starting_fish.each { |sf| fish_count[sf] += 1 }
  num_days.times do
    spawning_fish = fish_count[0]
    (0..7).each { |i| fish_count[i] = fish_count[i + 1] }
    fish_count[6] += spawning_fish
    fish_count[8] = spawning_fish
  end
  fish_count.sum
end

def part_one(input)
  simulate(input, 80)
end

def part_two(input)
  simulate(input, 256)
end

p part_one(TEST_INPUT) # should be 5934
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 26984457539
p part_two(REAL_INPUT)
