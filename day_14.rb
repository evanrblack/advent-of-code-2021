# First pass was 1:1
# Second pass just keeps track of pair counts

class Polymerizer
  def initialize(filename)
    parts = File.read(filename).strip.split(/^$/)
    @pair_counts = Hash.new(0)
    @letter_counts = Hash.new(0)
    template = parts[0].strip.chars
    template.each { |letter| @letter_counts[letter] += 1 }
    adjacent_pairs(template).each { |pair| @pair_counts[pair] += 1 }
    @insertion_rules = parts[1].scan(/^([A-Z]{2}) -> ([A-Z])$/).map { |a, b| [a.chars, b] }.to_h
  end

  def step
    new_pair_counts = @pair_counts.dup
    @pair_counts.each do |pair, count|
      letter = @insertion_rules[pair]
      if count > 0 && letter
        @letter_counts[letter] += count
        new_pair_counts[pair] -= count
        new_pair_counts[[pair[0], letter]] += count
        new_pair_counts[[letter, pair[1]]] += count
      end
    end
    @pair_counts = new_pair_counts
  end

  def most_minus_least
    min, max = @letter_counts.values.minmax
    max - min
  end

  private

  def adjacent_pairs(array)
    array.reduce([[]]) do |acc, cur|
      if acc.last.size <= 1
        acc.last << cur
        acc
      else
        acc << [acc.last[1], cur]
      end
    end
  end
end

def run_part(name, filename, steps = 10)
  p = Polymerizer.new(filename)
  steps.times { p.step }
  puts "#{name}: #{p.most_minus_least}"
end

run_part('Part 1 (Example)', 'day_14_example_input.txt')
run_part('Part 1', 'day_14_input.txt')

run_part('Part 2 (Example)', 'day_14_example_input.txt', 40)
run_part('Part 2', 'day_14_input.txt', 40)
