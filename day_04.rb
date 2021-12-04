require 'set'

class BingoCard
  def initialize(numbers)
    @size = Math.sqrt(numbers.length).to_i
    @numbers = numbers.each_slice(@size).to_a
    @marks = Array.new(@size) { Array.new(@size, false) }
    @winning = false
  end

  def mark(called_number)
    @numbers.each_with_index do |row, i|
      row.each_with_index do |number, j|
        if number == called_number
          @marks[i][j] = true
          update_winning
        end
      end
    end
  end

  def winning?
    return @winning
  end

  def unmarked_sum
    sum = 0
    @marks.each_with_index do |row, i|
      row.each_with_index do |marked, j|
        sum += @numbers[i][j] unless marked
      end
    end
    sum
  end

  private

  def winning_array?(array)
    array.count(&:itself) == @size
  end

  def any_winning_rows?
    @marks.any? { |row| winning_array?(row) }
  end

  def any_winning_columns?
    columns = Array.new(@size) { Array.new(@size, false) }
    columns.each_with_index do |column, i|
      column.each_with_index do |_, j|
        columns[i][j] = @marks[j][i]
      end
    end
    columns.any? { |column| winning_array?(column) }
  end

  def any_winning_diagonals?
    diagonals = []
    diagonals << @size.times.map { |n| @marks[n][n] }
    diagonals << @size.times.map { |n| @marks[(@size - 1) - n][n] }
    diagonals.any? { |diagonal| winning_array?(diagonal) }
  end

  def update_winning
    @winning = any_winning_rows? || any_winning_columns?
  end
end

class BingoSubsystem
  def initialize(filename)
    chunks = File.read(filename).strip.split(/^$/).map(&:strip)
    @numbers_to_call = chunks.shift.split(',').map(&:to_i)
    @bingo_card_numbers = chunks.map { |chunk| chunk.scan(/\d+/).map(&:to_i) }
  end

  def first_winning_score
    bingo_cards = @bingo_card_numbers.map { |numbers| BingoCard.new(numbers) }
    @numbers_to_call.each do |number|
      bingo_cards.each do |bingo_card|
        bingo_card.mark(number)
        if bingo_card.winning?
          return number * bingo_card.unmarked_sum
        end
      end
    end
  end

  def last_winning_score
    bingo_cards = @bingo_card_numbers.map { |numbers| BingoCard.new(numbers) }
    winning_bingo_cards = Set.new()
    last_winning_score = nil
    @numbers_to_call.each do |number|
      bingo_cards.each do |bingo_card|
        next if winning_bingo_cards.member?(bingo_card)
        bingo_card.mark(number)
        if bingo_card.winning?
          winning_bingo_cards.add(bingo_card)
          last_winning_score = number * bingo_card.unmarked_sum
        end
      end
    end
    last_winning_score
  end
end

def run_part_1(name, filename)
  bingo_subsystem = BingoSubsystem.new(filename)
  puts "#{name}: #{bingo_subsystem.first_winning_score}"
end

def run_part_2(name, filename)
  bingo_subsystem = BingoSubsystem.new(filename)
  puts "#{name}: #{bingo_subsystem.last_winning_score}"
end

run_part_1("Part 1 (Example)", "day_04_example_input.txt")
run_part_1("Part 1", "day_04_input.txt")
run_part_2("Part 2 (Example)", "day_04_example_input.txt")
run_part_2("Part 2", "day_04_input.txt")
