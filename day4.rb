# frozen_string_literal: true

class BingoBoard
  def initialize(raw_input)
    @grid = []
    @found = Array.new(5) { [false] * 5 }
    raw_input.each_line do |line|
      @grid << line.chomp.split(/\s+/).reject { |s| s == '' }
    end
  end

  def mark(called_number)
    (0...5).each do |x|
      (0...5).each do |y|
        @found[x][y] = true if @grid[x][y] == called_number
      end
    end
  end

  def winner?
    @found.each do |row|
      return true unless row.any?(false)
    end
    (0...5).each do |y|
      return true unless (0...5).map { |x| @found[x][y] }.any?(false)
    end
    false
  end

  def board_score
    total = 0
    (0...5).each do |x|
      (0...5).each do |y|
        total += @grid[x][y].to_i unless @found[x][y]
      end
    end
    total
  end
end

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day4_test_input.txt')
REAL_INPUT = import_from_file('day4_input.txt')

def part_one(input)
  drawn_number_list, *raw_boards = input.split("\n\n")
  numbers_drawn = drawn_number_list.split(',')
  boards = raw_boards.map { |b| BingoBoard.new(b) }
  numbers_drawn.each do |called_number|
    boards.each do |board|
      board.mark(called_number)
      return board.board_score * called_number.to_i if board.winner?
    end
  end
end

def part_two(input)
  drawn_number_list, *raw_boards = input.split("\n\n")
  numbers_drawn = drawn_number_list.split(',')
  boards = raw_boards.map { |b| BingoBoard.new(b) }
  numbers_drawn.each do |called_number|
    boards.each do |board|
      board.mark(called_number)
      if board.winner?
        if boards.length == 1
          return board.board_score * called_number.to_i
        else
          boards -= Array(board)
        end
      end
    end
  end
end

p part_one(TEST_INPUT) # should be 4512
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 1924
p part_two(REAL_INPUT)