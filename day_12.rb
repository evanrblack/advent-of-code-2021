require 'set'

class CaveSystem
  def initialize(filename)
    @graph = {}
    File.read(filename).strip.split("\n").each do |line|
      a, b = line.split('-')
      @graph[a] ||= Set.new()
      @graph[a].add(b)
      @graph[b] ||= Set.new()
      @graph[b].add(a)
    end
  end

  def paths_to_end(cave = 'start', current_path = [])
    return 1 if cave == 'end'
    options = @graph[cave].select do |option|
       option =~ /^\p{Upper}/ || !current_path.include?(cave)
    end
    options.map { |option| paths_to_end(option, [*current_path, cave]) }.sum
  end

  def paths_to_end_again(cave = 'start', current_path = [], second_visit_in_play = true)
    return 1 if cave == 'end'

    set = current_path.to_set
    options = @graph[cave].select do |option|
      if option == 'start'
        false
      elsif option =~ /^\p{Upper}/
        true
      else
        # must be small
        !set.include?(option) || second_visit_in_play
      end
    end

    options.map do |option|
      big = option =~ /^\p{Upper}/
      paths_to_end_again(option, [*current_path, cave], second_visit_in_play && (big || !set.include?(option)))
    end.sum
  end
end

def run_part_1(name, filename)
  cave = CaveSystem.new(filename)
  puts "#{name}: #{cave.paths_to_end}"
end

def run_part_2(name, filename)
  cave = CaveSystem.new(filename)
  puts "#{name}: #{cave.paths_to_end_again}"
end

run_part_1('Part 1 (Example 1)', 'day_12_example_input_1.txt')
run_part_1('Part 1 (Example 2)', 'day_12_example_input_2.txt')
run_part_1('Part 1 (Example 3)', 'day_12_example_input_3.txt')
run_part_1('Part 1', 'day_12_input.txt')
run_part_2('Part 2 (Example 1)', 'day_12_example_input_1.txt')
run_part_2('Part 2 (Example 2)', 'day_12_example_input_2.txt')
run_part_2('Part 2 (Example 3)', 'day_12_example_input_3.txt')
run_part_2('Part 2', 'day_12_input.txt')
