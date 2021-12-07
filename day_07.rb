class CrabSubmarines
  def initialize(positions)
    @positions = positions
  end



  def alignment_fuel_cost()
    (@positions.min..@positions.max).map do |p1|
      @positions.map { |p2| (p1 - p2).abs }.sum
    end.min
  end

  def other_alignment_fuel_cost
    (@positions.min..@positions.max).map do |p1|
      @positions.map do |p2|
        n = (p1 - p2).abs
        n * (n + 1) / 2
      end.sum
    end.min
  end
end

def run_part_1(name, filename)
  positions = File.read(filename).scan(/\d+/).map(&:to_i)
  crab_submarines = CrabSubmarines.new(positions)
  puts "#{name}: #{crab_submarines.alignment_fuel_cost}"
end

def run_part_2(name, filename)
  positions = File.read(filename).scan(/\d+/).map(&:to_i)
  crab_submarines = CrabSubmarines.new(positions)
  puts "#{name}: #{crab_submarines.other_alignment_fuel_cost}"
end


run_part_1('Part 1 (Example)', 'day_07_example_input.txt')
run_part_1('Part 1', 'day_07_input.txt')

run_part_2('Part 2 (Example)', 'day_07_example_input.txt')
run_part_2('Part 2', 'day_07_input.txt')
