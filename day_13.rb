require 'set'
require 'stringio'

class TransparentOrigami
  def initialize(filename)
    @dots = Set.new
    @folds = []

    File.read(filename).strip().split("\n").each do |line|
      if line =~ /^(\d+),(\d+)$/
        @dots.add([$1.to_i, $2.to_i])
      elsif line =~ /^fold along ([xy])=(\d+)$/
        @folds << [$1.to_sym, $2.to_i]
      end
    end
  end

  def apply_next_fold
    fold(*@folds.shift)
  end

  def apply_all_folds
    apply_next_fold until @folds.empty?
  end

  def total_dots
    @dots.size
  end

  def to_s
    s = StringIO.new
    width = @dots.max_by { |x, _y| x }[0] + 1
    height = @dots.max_by { |_x, y| y }[1] + 1
    height.times do |y|
      width.times do |x|
        if @dots.include?([x, y])
          s << '#'
        else
          s << ' '
        end
      end
      s << "\n"
    end
    s.string
  end

  private

  def fold(axis, offset)
    new_dots = Set.new

    @dots.each do |pos|
      if axis == :x && pos[0] > offset
        new_dots.add([offset * 2 - pos[0], pos[1]])
      elsif axis == :y && pos[1] > offset
        new_dots.add([pos[0], offset * 2 - pos[1]])
      else
        new_dots.add(pos)
      end
    end

    @dots = new_dots
  end
end


def run_part_1(name, filename)
  t = TransparentOrigami.new(filename)
  t.apply_next_fold
  puts "#{name}: #{t.total_dots}"
end

def run_part_2(name, filename)
  t = TransparentOrigami.new(filename)
  t.apply_all_folds
  puts "#{name}:\n#{t}"
end

run_part_1('Part 1 (Example)', 'day_13_example_input.txt')
run_part_1('Part 1', 'day_13_input.txt')
run_part_2('Part 2 (Example)', 'day_13_example_input.txt')
run_part_2('Part 2 (Example)', 'day_13_input.txt')
