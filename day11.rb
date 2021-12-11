def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
INPUT

REAL_INPUT = import_from_file('day11_input.txt')

def parse(input)
  grid = []
  input.each_line do |line|
    grid << line.chomp.chars.map(&:to_i)
  end
  grid
end

def any_energized?(grid)
  grid.flatten.any? { |cell| cell > 9 }
end

# returns the grid and the number of flashes that occurred during this step
def step(grid)
  step_flashes = 0
  # increment each octopus' power
  grid.each do |row|
    row.each_index { |cell| row[cell] += 1 }
  end
  # check for flashes
  while any_energized?(grid)
    grid.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        next if cell < 10

        [x - 1, x, x + 1].select { |xx| xx >= 0 && xx < grid.length }.each do |xx|
          [y - 1, y, y + 1].select { |yy| yy >= 0 && yy < row.length }.each do |yy|
            grid[xx][yy] += 1 unless grid[xx][yy].zero? # prevent multiple flashes per step
          end
        end
        step_flashes += 1
        row[y] = 0
      end
    end
  end
  [grid, step_flashes]
end

def part_one(input)
  total_flashes = 0
  grid = parse(input)
  100.times do
    grid, step_flashes = step(grid)
    total_flashes += step_flashes
  end
  total_flashes
end

def part_two(input)
  grid = parse(input)
  i = 0
  loop do
    i += 1
    grid, flashes = step(grid)
    break if flashes == 100
  end
  i
end

p part_one(TEST_INPUT) # should be 1656
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 195
p part_two(REAL_INPUT)
