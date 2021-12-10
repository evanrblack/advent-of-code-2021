class NavigationSubsystem
  OPEN_CHARS = ['(', '[', '{', '<']
  CLOSE_CHARS = [')', ']', '}', '>']
  SYNTAX_ERROR_POINTS = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
  AUTOCOMPLETE_POINTS =  { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }

  def initialize(filename)
    @lines = File.read(filename).strip.split("\n")
  end

  def syntax_error_score
    @lines
      .map { |line| line_status(line) }
      .select { |status, _| status == :corrupted }
      .map { |_, bad_char| SYNTAX_ERROR_POINTS[bad_char] }
      .sum
  end

  def autocomplete_score
    line_points = @lines
                    .map { |line| line_status(line) }
                    .select { |status, _| status == :incomplete }
                    .map { |_, open_stack| open_stack.map { |c| AUTOCOMPLETE_POINTS[matching_close_char(c)] } }
                    .map { |points| points.reverse.reduce(0) { |acc, cur| acc * 5 + cur } }
                    .sort
    line_points[line_points.size / 2]
  end

  private

  def matching_close_char(open_char)
    CLOSE_CHARS[OPEN_CHARS.find_index(open_char)]
  end

  def line_status(line)
    open_stack = []
    line.chars.each do |char|
      if OPEN_CHARS.include?(char)
        open_stack.push(char)
      else
        if char != matching_close_char(open_stack.last)
          return [:corrupted, char]
        else
          open_stack.pop
        end
      end
    end

    if open_stack.empty?
      [:complete]
    else
      [:incomplete, open_stack]
    end
  end
end

def run_part_1(name, filename)
  nav_sub = NavigationSubsystem.new(filename)
  puts "#{name}: #{nav_sub.syntax_error_score}"
end


def run_part_2(name, filename)
  nav_sub = NavigationSubsystem.new(filename)
  puts "#{name}: #{nav_sub.autocomplete_score}"
end

run_part_1('Part 1 (Example)', 'day_10_example_input.txt')
run_part_1('Part 1', 'day_10_input.txt')
run_part_2('Part 2 (Example)', 'day_10_example_input.txt')
run_part_2('Part 2', 'day_10_input.txt')
