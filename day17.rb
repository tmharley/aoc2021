X = 0
Y = 1

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def parse_input(input)
  x_range = /x=(-?\d+)\.\.(-?\d+)/.match(input)
  y_range = /y=(-?\d+)\.\.(-?\d+)/.match(input)
  [x_range[1].to_i..x_range[2].to_i, y_range[1].to_i..y_range[2].to_i]
end

def can_reach?(position, velocity, target_area)
  position[X] + velocity[X] <= target_area[X].max &&
    position[Y] + velocity[Y] >= target_area[Y].min
end

def inside?(position, target_area)
  target_area[X].include?(position[X]) && target_area[Y].include?(position[Y])
end

TEST_INPUT = 'target area: x=20..30, y=-10..-5'
REAL_INPUT = import_from_file('day17_input.txt')

def simulate(input)
  target_area = parse_input(input)
  overall_y_max = 0
  good_start_velocities = []
  (1..target_area[X].max).each do |xx|
    (-100..100).each do |yy|
      position = [0, 0]
      velocity = [xx, yy]
      y_max = 0
      while can_reach?(position, velocity, target_area)
        position[X] += velocity[X]
        position[Y] += velocity[Y]
        y_max = [y_max, position[Y]].max
        if velocity[X].positive?
          velocity[X] -= 1
        elsif velocity[X].negative?
          velocity[X] += 1
        end
        velocity[Y] -= 1
        if inside?(position, target_area)
          overall_y_max = [overall_y_max, y_max].max
          good_start_velocities << [xx, yy]
          break
        end
      end
    end
  end
  [overall_y_max, good_start_velocities.length]
end

p simulate(TEST_INPUT) # should be [45, 112]
p simulate(REAL_INPUT)