TEST_INPUT = <<~INPUT
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day5_input.txt')

def part_one(input)
  grid = []

  input.each_line do |line|
    parts = line.split(' ')
    x1, y1 = parts[0].split(',').map(&:to_i)
    x2, y2 = parts[2].split(',').map(&:to_i)
    if x1 == x2
      grid[x1] ||= []
      range = y2 > y1 ? y1..y2 : y2..y1
      range.each do |y|
        grid[x1][y] = grid[x1][y] ? grid[x1][y] + 1 : 1
      end
    elsif y1 == y2
      range = x2 > x1 ? x1..x2 : x2..x1
      range.each do |x|
        grid[x] ||= []
        grid[x][y1] = grid[x][y1] ? grid[x][y1] + 1 : 1
      end
    end
  end

  grid.flatten.count { |cell| cell && cell > 1 }
end

def part_two(input)
  grid = []

  input.each_line do |line|
    parts = line.split(' ')
    x1, y1 = parts[0].split(',').map(&:to_i)
    x2, y2 = parts[2].split(',').map(&:to_i)
    if x1 == x2 # vertical line
      grid[x1] ||= []
      range = y2 > y1 ? y1..y2 : y2..y1
      range.each do |y|
        grid[x1][y] = grid[x1][y] ? grid[x1][y] + 1 : 1
      end
    elsif y1 == y2 # horizontal line
      range = x2 > x1 ? x1..x2 : x2..x1
      range.each do |x|
        grid[x] ||= []
        grid[x][y1] = grid[x][y1] ? grid[x][y1] + 1 : 1
      end
    else # diagonal line
      x_start, x_end = [x1, x2].minmax
      y_start = x_start == x1 ? y1 : y2
      y_end = x_end == x1 ? y1 : y2
      x = x_start
      y = y_start
      loop do
        break if x > x_end

        grid[x] ||= []
        grid[x][y] = grid[x][y] ? grid[x][y] + 1 : 1
        x += 1
        y = y_start < y_end ? y + 1 : y - 1
      end
    end
  end

  grid.flatten.count { |cell| cell && cell > 1 }
end

p part_one(TEST_INPUT) # should be 5
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 12
p part_two(REAL_INPUT)
