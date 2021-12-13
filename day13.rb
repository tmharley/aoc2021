require 'set'

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day13_test_input.txt')
REAL_INPUT = import_from_file('day13_input.txt')

def points_and_folds(input)
  point_section, fold_section = input.split("\n\n")
  [parse_points(point_section), parse_folds(fold_section)]
end

def parse_points(input)
  points = Set.new
  input.each_line do |line|
    pt = line.chomp.split(',').map(&:to_i)
    points << pt
  end
  points
end

def parse_folds(input)
  input.each_line.map do |line|
    line.match(/[xy]=\d+/).to_s
  end
end

def part_one(input)
  points, fold_list = points_and_folds(input)
  axis, position = fold_list.first.split('=')
  position = position.to_i
  if axis == 'x'
    # folding across vertical line
    points_to_fold = points.select { |pt| pt[0] > position }
    points.subtract(points_to_fold)
    points_to_fold.each do |pt|
      pt[0] = position * 2 - pt[0]
      points << pt
    end
  elsif axis == 'y'
    # folding across horizontal line
    points_to_fold = points.select { |pt| pt[1] > position }
    points.subtract(points_to_fold)
    points_to_fold.each do |pt|
      pt[1] = position * 2 - pt[1]
      points << pt
    end
  end
  points.length
end

def part_two(input)
  points, fold_list = points_and_folds(input)
  fold_list.each do |fold|
    axis, position = fold.split('=')
    position = position.to_i
    if axis == 'x'
      # folding across vertical line
      points_to_fold = points.select { |pt| pt[0] > position }
      points.subtract(points_to_fold)
      points_to_fold.each do |pt|
        pt[0] = position * 2 - pt[0]
        points << pt
      end
    elsif axis == 'y'
      # folding across horizontal line
      points_to_fold = points.select { |pt| pt[1] > position }
      points.subtract(points_to_fold)
      points_to_fold.each do |pt|
        pt[1] = position * 2 - pt[1]
        points << pt
      end
    end
  end
  grid_size = points.to_a.flatten.max + 1
  grid = Array.new(grid_size) { ' ' * grid_size }
  points.each { |pt| grid[pt[1]][pt[0]] = '#' }
  grid
end

p part_one(TEST_INPUT) # should be 17
p part_one(REAL_INPUT)

part_two(TEST_INPUT).each { |line| p line } # should look like a square
part_two(REAL_INPUT).each { |line| p line }
