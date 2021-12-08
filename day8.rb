require 'set'

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

DIGITS = %w[abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg]
TEST_INPUT = import_from_file('day8_test_input.txt')
REAL_INPUT = import_from_file('day8_input.txt')

def digit_length(digit)
  DIGITS[digit].length
end

def matches_any_digit_length(input, digit_list)
  digit_list.any? { |d| input.length == digit_length(d) }
end

def part_one(input)
  count = 0
  input.each_line do |line|
    output_digits = line.split(' | ')[1].chomp.split(' ')
    output_digits.each do |d|
      count += 1 if matches_any_digit_length(d, [1, 4, 7, 8])
    end
  end
  count
end

def part_two(input)
  total = 0
  input.each_line do |line|
    translated_digits = Array.new(10)
    signal_patterns, output_digits = line.chomp.split(' | ').map { |s| s.split(' ') }
    signal_patterns = Set.new(signal_patterns)
    output_digits.map! { |d| Set.new(d.chars) }

    # first get the trivial cases of 1, 4, 7, 8
    signal_patterns.each do |d|
      case d.length
      when 2
        translated_digits[1] = Set.new(d.chars)
      when 3
        translated_digits[7] = Set.new(d.chars)
      when 4
        translated_digits[4] = Set.new(d.chars)
      when 7
        translated_digits[8] = Set.new(d.chars)
      else
        next # we'll get these in future passes
      end
    end

    # next, do 6-segment digits (0, 6, 9)
    digits6 = signal_patterns.select { |d| d.length == 6 }.map { |d| Set.new(d.chars) }

    # 9 is a superset of 4
    translated_digits[9] = digits6.select { |d| d.superset?(translated_digits[4]) }.first
    digits6.delete(translated_digits[9])

    # now 1 is a subset of 0, but not of 6
    if digits6.first.superset?(translated_digits[1])
      translated_digits[0] = digits6.first
      translated_digits[6] = digits6.last
    else
      translated_digits[0] = digits6.last
      translated_digits[6] = digits6.first
    end

    # finally, 5-segment digits (2, 3, 5)
    digits5 = signal_patterns.select { |d| d.length == 5 }.map { |d| Set.new(d.chars) }

    # 3 is a superset of 1
    translated_digits[3] = digits5.select { |d| d.superset?(translated_digits[1]) }.first
    digits5.delete(translated_digits[3])

    # now 6 is a superset of 5, but not of 2
    if translated_digits[6].superset?(digits5.first)
      translated_digits[5] = digits5.first
      translated_digits[2] = digits5.last
    else
      translated_digits[2] = digits5.first
      translated_digits[5] = digits5.last
    end

    output_digits.each_with_index do |digit, index|
      total += translated_digits.index(digit) * 10 ** (3 - index)
    end
  end
  total
end

p part_one(TEST_INPUT) # should be 26
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 61229
p part_two(REAL_INPUT)
