class VentLine
  attr_reader :x1, :y1, :x2, :y2, :x_min, :x_max, :y_min, :y_max, :orientation

  def initialize(x1, y1, x2, y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
    @x_min = [x1, x2].min
    @x_max = [x1, x2].max
    @y_min = [y1, y2].min
    @y_max = [y1, y2].max
    @orientation = if x1 == x2
                     :vertical
                   elsif y1 == y2
                     :horizontal
                   else
                     :diagonal
                   end
  end

  def vertical?
    orientation == :vertical
  end

  def horizontal?
    orientation == :horizontal
  end

  def diagonal?
    orientation == :diagonal
  end

  def coordinate_pairs
    @coordinate_pairs ||= if vertical?
                          (y_min..y_max).map { |y| [x1, y] }
                        elsif horizontal?
                          (x_min..x_max).map { |x| [x, y1] }
                        elsif diagonal?
                          xs = if x1 < x2 then x1.upto(x2) else x1.downto(x2) end
                          ys = if y1 < y2 then y1.upto(y2) else y1.downto(y2) end
                          return xs.zip(ys)
                        end
  end

  def intersections_with(other)
    coordinate_pairs & other.coordinate_pairs
  end

  def to_s
    "#{x1},#{y1} -> #{x2},#{y2}"
  end
end

class VentLines
  def initialize(filename)
    @vent_lines = File.read(filename).strip.split("\n").map do |text_line|
      coords = text_line.scan(/\d+/).map(&:to_i)
      VentLine.new(*coords)
    end
  end

  def count_intersections(**kwargs)
    @vent_lines
      .reject { |vent_line| kwargs[:ignore_diagonals] && vent_line.diagonal? }
      .combination(2)
      .flat_map { |a, b| a.intersections_with(b) }
      .uniq
      .count
  end
end

def run_part_1(name, filename)
  vent_lines = VentLines.new(filename)
  puts "#{name}: #{vent_lines.count_intersections(ignore_diagonals: true)}"
end

def run_part_2(name, filename)
  vent_lines = VentLines.new(filename)
  puts "#{name}: #{vent_lines.count_intersections}"
end

# Super slow! It takes like a minute. I originally wanted to do some
# sort of AABB thing, but Ruby's intersection operator looked too
# appetizing.

run_part_1('Part 1 (Example)', 'day_05_example_input.txt')
run_part_1('Part 1', 'day_05_input.txt')
run_part_2('Part 2 (Example)', 'day_05_example_input.txt')
run_part_2('Part 2', 'day_05_input.txt')
