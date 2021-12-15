def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
INPUT

REAL_INPUT = import_from_file('day15_input.txt')

def parse_grid(input)
  risk_levels = []
  input.each_line { |line| risk_levels << line.chomp.chars.map(&:to_i) }
  Array.new(risk_levels.length) do |x|
    Array.new(risk_levels.length) do |y|
      {
        risk: risk_levels[x][y],
        cumulative_risk: nil
      }
    end
  end
end

def extend_grid(grid, multiplier)
  (0...multiplier).map do |i|
    grid.map do |row|
      (0...multiplier).map do |j|
        row.map do |cell|
          c = cell.dup
          c[:risk] = cell[:risk] + i + j
          c[:risk] -= 9 while c[:risk] > 9
          c
        end
      end.reduce(&:+)
    end
  end.reduce(&:+)
end

def build_cumulative_risks(grid, distance)
  if distance.zero?
    grid[0][0][:cumulative_risk] = 0
    return
  end
  (0..distance).each do |x|
    next if x >= grid.length

    y = distance - x
    cell = grid[x][y]
    next unless cell

    adjacent_cells = []
    adjacent_cells << grid[x - 1][y] if x.positive?
    adjacent_cells << grid[x][y - 1] if y.positive?
    adjacent_cells << grid[x + 1][y] if x + 1 < grid.length
    adjacent_cells << grid[x][y + 1] if y + 1 < grid.length
    cell[:cumulative_risk] = adjacent_cells.map { |a| a[:cumulative_risk] }
                                           .reject(&:nil?).min + cell[:risk]
  end
end

def part_one(input)
  grid = parse_grid(input)
  max_distance = (grid.length - 1) * 2
  (0..max_distance).each do |dist|
    build_cumulative_risks(grid, dist)
  end
  grid[-1][-1][:cumulative_risk]
end

def part_two(input)
  grid = extend_grid(parse_grid(input), 5)
  max_distance = (grid.length - 1) * 2
  # an arbitrary number of iterations to hopefully converge on the result
  10.times do
    (0..max_distance).each do |dist|
      build_cumulative_risks(grid, dist)
    end
  end
  grid[-1][-1][:cumulative_risk]
end

p part_one(TEST_INPUT) # should be 40
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 315
p part_two(REAL_INPUT)
