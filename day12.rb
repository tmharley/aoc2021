def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = [
  import_from_file('day12_test_input1.txt'),
  import_from_file('day12_test_input2.txt'),
  import_from_file('day12_test_input3.txt')
]
REAL_INPUT = import_from_file('day12_input.txt')

def big_cave?(cave_name)
  cave_name.upcase == cave_name
end

def small_cave_visited_twice?(path)
  visited = []
  small_caves = path.reject { |c| %w[start end].include?(c) || big_cave?(c) }
  small_caves.each do |c|
    return true if visited.include?(c)

    visited << c
  end
  false
end

# for use with part two only
def can_visit?(path, cave)
  return false if cave == 'start'
  return true if big_cave?(cave)
  return true if path.none?(cave)

  !small_cave_visited_twice?(path)
end

def part_one(input)
  segments = {}
  potential_paths = []
  complete_paths = []
  input.each_line do |line|
    segment_start, segment_end = line.chomp.split('-')
    if segments.key?(segment_start)
      segments[segment_start] << segment_end
    else
      segments[segment_start] = Array(segment_end)
    end
    if segments.key?(segment_end)
      segments[segment_end] << segment_start
    else
      segments[segment_end] = Array(segment_start)
    end
  end
  segments['start'].each do |s|
    potential_paths << ['start', s]
  end
  until potential_paths.empty?
    new_potential_paths = []
    potential_paths.each do |path|
      if path.last == 'end'
        complete_paths << path
        next
      end
      next_steps = segments[path.last].dup
      next_steps.reject! { |n| !big_cave?(n) && path.include?(n) }
      new_potential_paths += next_steps.map { |n| path.dup << n }
    end
    potential_paths = new_potential_paths
  end
  complete_paths.length
end

def part_two(input)
  segments = {}
  potential_paths = []
  complete_paths = []
  input.each_line do |line|
    segment_start, segment_end = line.chomp.split('-')
    if segments.key?(segment_start)
      segments[segment_start] << segment_end
    else
      segments[segment_start] = Array(segment_end)
    end
    if segments.key?(segment_end)
      segments[segment_end] << segment_start
    else
      segments[segment_end] = Array(segment_start)
    end
  end
  segments['start'].each do |s|
    potential_paths << ['start', s]
  end
  until potential_paths.empty?
    new_potential_paths = []
    potential_paths.each do |path|
      if path.last == 'end'
        complete_paths << path
        next
      end
      next_steps = segments[path.last].dup
      next_steps.select! { |n| can_visit?(path, n) }
      new_potential_paths += next_steps.map { |n| path.dup << n }
    end
    potential_paths = new_potential_paths
  end
  complete_paths.length
end

# should be 10, 19, and 226
TEST_INPUT.each do |t|
  p part_one(t)
end
p part_one(REAL_INPUT)

# should be 36, 103, and 3509
TEST_INPUT.each do |t|
  p part_two(t)
end
p part_two(REAL_INPUT)