class Diagnostic
  def initialize(filename)
    @lines = File.read(filename).strip.split("\n")
    @binary_length = @lines.first.length
  end

  # most common bit per position
  def gamma_rate
    digit_counts(@lines).map { |h| h.max_by { |_, count| count }[0] }.join.to_i(2)
  end

  def epsilon_rate
    gamma_rate ^ ('1' * @binary_length).to_i(2)
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end

  def oxygen_generator_rating
    candidates = @lines
    index = 0
    until candidates.length < 2
      target_sequence = most_common_sequence(candidates, '1')
      candidates = candidates.select { |candidate| candidate[index] == target_sequence[index] }
      index += 1
    end
    candidates[0].to_i(2)
  end

  def co2_scrubber_rating
    candidates = @lines
    index = 0
    until candidates.length < 2
      target_sequence = least_common_sequence(candidates, '0')
      candidates = candidates.select { |candidate| candidate[index] == target_sequence[index] }
      index += 1
    end
    candidates[0].to_i(2)
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  private

  def groups_by_index(lines)
    groups = []
    lines.each do |line|
      line.chars.each_with_index do |char, index|
        if groups[index]
          groups[index] << char
        else
          groups[index] = [char]
        end
      end
    end
    groups
  end

  def digit_counts(lines)
    lines
      .map { |line| line.chars.each_with_index.to_a }
      .flatten(1)
      .group_by { |_, index| index }
      .map { |index, elems| elems.map(&:first).tally }
  end

  def most_common_sequence(lines, tiebreaker)
    digit_counts(lines).map do |h|
      case h.fetch('0', 0) <=> h.fetch('1', 0)
      when -1 then '1'
      when 0 then tiebreaker
      when 1 then '0'
      end
    end.join
  end

  def least_common_sequence(lines, tiebreaker)
    digit_counts(lines).map do |h|
      case h.fetch('0', 0) <=> h.fetch('1', 0)
      when -1 then '0'
      when 0 then tiebreaker
      when 1 then '1'
      end
    end.join
  end
end

def run_part_1(name, filename)
  d = Diagnostic.new(filename)
  puts "#{name}: #{d.power_consumption}"
end

def run_part_2(name, filename)
  d = Diagnostic.new(filename)
  puts "#{name}: #{d.life_support_rating}"
end

run_part_1('Part 1 (Example)', 'day_03_example_input.txt')
run_part_1('Part 1', 'day_03_input.txt')
run_part_2('Part 2 (Example)', 'day_03_example_input.txt')
run_part_2('Part 2', 'day_03_input.txt')
