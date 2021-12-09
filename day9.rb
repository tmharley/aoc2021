require 'set'

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
INPUT

REAL_INPUT = import_from_file('day9_input.txt')

def parse(input)
  output = []
  input.each_line do |line|
    new_row = []
    output << new_row
    line.chomp.chars.each do |cell|
      new_row << cell.to_i
    end
  end
  output
end

def low_point?(grid, x, y)
  lower_points(grid, x, y).none?
end

def lower_points(grid, x, y)
  cells_to_check = []
  cells_to_check << [x - 1, y] if x.positive?
  cells_to_check << [x, y - 1] if y.positive?
  cells_to_check << [x + 1, y] if x < grid.length - 1
  cells_to_check << [x, y + 1] if y < grid.first.length - 1
  cells_to_check.select { |coords| grid[coords[0]][coords[1]] <= grid[x][y] }
end

def part_one(input)
  total_risk = 0
  grid = parse(input)
  grid.each_index do |row|
    grid[row].each_index do |cell|
      total_risk += (grid[row][cell] + 1) if low_point?(grid, row, cell)
    end
  end
  total_risk
end

def part_two(input)
  grid = parse(input)
  basins = []

  grid.each_index do |row|
    grid[row].each_index do |cell|
      next if grid[row][cell] == 9 # not part of any basin
      next if basins.any? { |b| b.include?([row, cell]) } # already in a basin

      points_to_check = []
      basins << (this_basin = Set.new)
      this_basin << [row, cell]
      x = row
      y = cell
      lower_points(grid, x, y).each { |lp| points_to_check << lp }
      points_to_check.each do |point|
        if (existing_basin = basins.select { |b| b.include?(point) }.first)
          basins.delete(existing_basin)
          basins.delete(this_basin)
          basins << this_basin + existing_basin
        end
        this_basin << point
        lower_points(grid, *point).each do |lp|
          points_to_check << lp unless points_to_check.include?(lp)
        end
      end
    end
  end
  basins.map(&:size).max(3).reduce(&:*)
end

p part_one(TEST_INPUT) # should be 15
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 1134
p part_two(REAL_INPUT)
