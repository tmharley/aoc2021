def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day10_test_input.txt')
REAL_INPUT = import_from_file('day10_input.txt')

ERROR_SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}.freeze

COMPLETION_SCORES = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}.freeze

class StackItem
  def initialize(char, next_item)
    @token = char
    @next_item = next_item
  end

  def empty?
    @token.nil?
  end

  def match?(other_token)
    other_token == matching_token
  end

  def matching_token
    case @token
    when '(' then ')'
    when '[' then ']'
    when '{' then '}'
    when '<' then '>'
    else nil
    end
  end

  def pop
    @next_item
  end

  def self.chunk_start?(char)
    %w|( [ { <|.include?(char)
  end
end

def part_one(input)
  error_score = 0
  input.each_line do |line|
    stack = StackItem.new(nil, nil)
    line.chomp.chars do |char|
      if StackItem.chunk_start?(char)
        stack = StackItem.new(char, stack)
      elsif stack.match?(char)
        stack = stack.pop
      else
        error_score += ERROR_SCORES[char]
        break
      end
    end
  end
  error_score
end

def part_two(input)
  completion_scores = []
  input.each_line do |line|
    stack = StackItem.new(nil, nil)
    line.chomp.chars do |char|
      if StackItem.chunk_start?(char)
        stack = StackItem.new(char, stack)
      elsif stack.match?(char)
        stack = stack.pop
      else
        # we have a corrupted line, clear the stack to discard
        stack = stack.pop until stack.empty?
        break
      end
    end
    next if stack.empty? # complete or corrupted line, discard

    score = 0
    until stack.empty?
      cs = COMPLETION_SCORES[stack.matching_token]
      score = score * 5 + cs
      stack = stack.pop
    end
    completion_scores << score
  end
  completion_scores.sort[completion_scores.length / 2]
end

p part_one(TEST_INPUT) # should be 26397
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 288957
p part_two(REAL_INPUT)
