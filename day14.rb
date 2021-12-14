def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day14_test_input.txt')
REAL_INPUT = import_from_file('day14_input.txt')

def parse_rules(input)
  rules = {}
  input.each_line do |line|
    k, v = line.chomp.split(' -> ')
    rules[k] = v
  end
  rules
end

def part_one(input)
  polymer, raw_rules = input.split("\n\n")
  rules = parse_rules(raw_rules)
  frequencies = {}

  10.times do
    new_polymer = polymer.dup
    (1...polymer.length).each do |i|
      pair = polymer[i - 1, 2]
      char_to_insert = rules[pair]
      new_polymer.insert(i * 2 - 1, char_to_insert)
    end
    polymer = new_polymer
  end

  polymer.chars do |c|
    if frequencies.key?(c)
      frequencies[c] += 1
    else
      frequencies[c] = 1
    end
  end
  min, max = frequencies.values.minmax
  max - min
end

def part_two(input)
  polymer, raw_rules = input.split("\n\n")
  original = polymer.chomp
  rules = parse_rules(raw_rules)
  pair_frequencies = {}
  pair_children = {}
  letter_frequencies = {}
  rules.each do |k, v|
    pair_children[k] = [k[0] + v, v + k[1]]
  end

  # parse original polymer into pairs
  (1...polymer.length).each do |i|
    pair = polymer[i - 1, 2]
    if pair_frequencies.key?(pair)
      pair_frequencies[pair] += 1
    else
      pair_frequencies[pair] = 1
    end
  end

  40.times do
    new_frequencies = {}
    pair_frequencies.each do |pair, amount|
      children = pair_children[pair]
      children.each do |child|
        if new_frequencies.key?(child)
          new_frequencies[child] += amount
        else
          new_frequencies[child] = amount
        end
      end
    end
    pair_frequencies = new_frequencies
  end

  # translate pairs back into letters
  pair_frequencies.each do |pair, amount|
    pair.chars do |letter|
      if letter_frequencies.key?(letter)
        letter_frequencies[letter] += amount
      else
        letter_frequencies[letter] = amount
      end
    end
  end

  # each letter was in two pairs
  letter_frequencies.each do |letter, amount|
    letter_frequencies[letter] = amount / 2
  end

  # account for first and last letter appearing in only one pair
  letter_frequencies[original[0]] += 1
  letter_frequencies[original[-1]] += 1

  min, max = letter_frequencies.values.minmax
  max - min
end

p part_one(TEST_INPUT) # should be 1588
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 2188189693529
p part_two(REAL_INPUT)
