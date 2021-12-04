TEST_INPUT = <<~INPUT
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day3_input.txt')

def gamma_epsilon(input)
  lines = input.split("\n")
  num_cols = lines.first.length
  sums = Array.new(num_cols) { 0 }
  lines.each do |line|
    (0...num_cols).each do |index|
      sums[index] += line[index].to_i
    end
  end
  gamma_bits = sums.map { |s| s > lines.length / 2 ? 1 : 0 }
  epsilon_bits = sums.map { |s| s < lines.length / 2 ? 1 : 0 }
  [gamma_bits.reduce { |a, b| a * 2 + b }, epsilon_bits.reduce { |a, b| a * 2 + b }]
end

def part_one(input)
  gamma, epsilon = gamma_epsilon(input)
  gamma * epsilon
end

def oxygen_rating(input)
  bit_pos = 0
  ones = []
  zeroes = []
  lines = input.split("\n")
  loop do
    lines.each do |line|
      if line[bit_pos] == '1'
        ones << line
      else
        zeroes << line
      end
    end
    lines = if ones.length >= zeroes.length
              ones.dup
            else
              zeroes.dup
            end
    return lines.first.to_i(2) if lines.length == 1

    ones.clear
    zeroes.clear
    bit_pos += 1
  end
end

def co2_rating(input)
  bit_pos = 0
  ones = []
  zeroes = []
  lines = input.split("\n")
  loop do
    lines.each do |line|
      if line[bit_pos] == '1'
        ones << line
      else
        zeroes << line
      end
    end
    lines = if ones.length >= zeroes.length
              zeroes.dup
            else
              ones.dup
            end
    return lines.first.to_i(2) if lines.length == 1

    ones.clear
    zeroes.clear
    bit_pos += 1
  end
end

def part_two(input)
  oxygen_rating(input) * co2_rating(input)
end

p part_one(TEST_INPUT) # should be 198
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 230
p part_two(REAL_INPUT)
