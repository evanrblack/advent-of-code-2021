class Octopodes
  attr_reader :total_flashes

  def initialize(filename)
    @grid = {}
    @total_flashes = 0
    File.read(filename).strip.split("\n").each_with_index do |line, y|
      line.scan(/\d/).each_with_index do |char, x|
        @grid[[x, y]] = char.to_i
      end
    end
  end

  def run(iterations = 1)
    iterations.times do |i|
      @grid.each { |pos, _| @grid[pos] += 1 }

      to_flash = @grid.select { |_, level| level == 10 }
      to_flash.each { |pos, _| flash(pos) }

      @grid.each do |pos, level|
        if level > 9
          @grid[pos] = 0
          @total_flashes += 1
        end
      end
    end
  end

  def run_until_all_flash
    iterations = 0
    until @grid.values.all?(&:zero?) do
      run()
      iterations += 1
    end
    iterations
  end

  def to_s
    size = Math.sqrt(@grid.size).to_i
    @grid.values.map(&:to_s).each_slice(size).to_a.map(&:join).join("\n")
  end

  private

  def neighbors(pos)
    x, y = pos
    [[x,     y - 1],
     [x + 1, y - 1],
     [x + 1, y],
     [x + 1, y + 1],
     [x,     y + 1],
     [x - 1, y + 1],
     [x - 1, y],
     [x - 1, y - 1]].select { |neighbor_pos| @grid.include?(neighbor_pos) }
  end

  def flash(pos)
    neighbors(pos).each do |neighbor_pos|
      @grid[neighbor_pos] += 1
      if @grid[neighbor_pos] == 10
        flash(neighbor_pos)
      end
    end
  end
end

def run_part_1(name, filename)
  octopodes = Octopodes.new(filename)
  octopodes.run(100)
  puts "#{name}: #{octopodes.total_flashes}"
end

def run_part_2(name, filename)
  octopodes = Octopodes.new(filename)
  puts "#{name}: #{octopodes.run_until_all_flash}"
end

run_part_1('Part 1 (Example)', 'day_11_example_input.txt')
run_part_1('Part 1', 'day_11_input.txt')
run_part_2('Part 2 (Example)', 'day_11_example_input.txt')
run_part_2('Part 2', 'day_11_input.txt')
