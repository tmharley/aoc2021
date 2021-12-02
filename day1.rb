TEST_INPUT = <<~INPUT
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def parse(input)
  input.split("\n").map!(&:chomp).map!(&:to_i)
end

def part_one(measurements)
  result = 0
  measurements.each_with_index do |value, index|
    next if index.zero?

    result += 1 if value > measurements[index - 1]
  end
  result
end

def build_sums(measurements, window_size)
  return nil if window_size < 1

  (window_size..measurements.size).map do |i|
    measurements[(i - window_size)...i].reduce(&:+)
  end
end

def part_two(measurements)
  result = 0
  sums = build_sums(measurements, 3)
  sums.each_with_index do |value, index|
    next if index.zero?

    result += 1 if value > sums[index - 1]
  end
  result
end

p part_one(parse(TEST_INPUT)) # should be 7
p part_one(parse(import_from_file('day1_input.txt')))

p part_two(parse(TEST_INPUT)) # should be 5
p part_two(parse(import_from_file('day1_input.txt')))
