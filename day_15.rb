require 'set'
require 'stringio'

class PriorityQueue
  def initialize
    @q = []
  end

  def pop
    @q.pop&.at(0)
  end

  def push(value, priority)
    index = @q.bsearch_index { |_, p| p >= priority }
    @q.insert(index || @q.size, [value, priority])
    self
  end

  def empty?
    @q.empty?
  end
end

class RiskyCave
  def initialize(filename, multiplier = 1)
    original_risk_levels = {}
    original_width = 0
    original_height = 0
    File.read(filename).strip.split("\n").each_with_index do |line, y|
      original_height = y + 1
      line.chars.each_with_index do |char, x|
        original_width = x + 1
        original_risk_levels[[x, y]] = char.to_i
      end
    end

    @risk_levels = {}
    @width = original_width * multiplier
    @height = original_height * multiplier

    multiplier.times do |mx|
      multiplier.times do |my|
        added_risk = mx + my
        x_offset = original_width * mx
        y_offset = original_height * my
        original_risk_levels.each do |pos, risk|
          @risk_levels[[x_offset + pos[0], y_offset + pos[1]]] = ((risk - 1 + added_risk) % 9) + 1
        end
      end
    end
  end

  def lowest_risk
    entry_pos = [0, 0]
    risk_levels_keys = @risk_levels.keys
    exit_pos = [@width - 1, @height - 1]

    visited = Set.new()
    queue = PriorityQueue.new()
    path_risk = risk_levels_keys.map { |pos| [pos, Float::INFINITY] }.to_h

    queue.push(entry_pos, 0)
    path_risk[entry_pos] = 0

    until queue.empty?
      # if visited.size % 1000 == 0
      #   puts '%.2f' % (visited.size.to_f / path_risk.size)
      # end
      current_pos = queue.pop()
      next if visited.include?(current_pos)
      break if current_pos == exit_pos
      visited.add(current_pos)
      current_risk = path_risk[current_pos]

      unvisited_neighbors = neighbors(current_pos).reject { |n| visited.include?(n) }
      pushed = false
      unvisited_neighbors.each do |neighbor|
        neighbor_risk = current_risk + @risk_levels[neighbor]
        if neighbor_risk < path_risk[neighbor]
          pushed = true
          path_risk[neighbor] = neighbor_risk
          queue.push(neighbor, -path_risk[neighbor])
        end
      end
    end

    path_risk[exit_pos]
  end

  def to_s
    s = StringIO.new()
    @height.times do |y|
      @width.times do |x|
        s << @risk_levels[[x, y]]
      end
      s << "\n"
    end
    s.string
  end

  private

  def neighbors(pos)
    x, y = pos
    [[x, y - 1],
     [x + 1, y],
     [x, y + 1],
     [x - 1, y]].select { |neighbor_pos| @risk_levels.include?(neighbor_pos) }
  end
end

def run(name, filename, multiplier = 1)
  risky_cave = RiskyCave.new(filename, multiplier)
  puts "#{name}: #{risky_cave.lowest_risk}"
end

run('Part 1 (Example)', 'day_15_example_input.txt')
run('Part 1', 'day_15_input.txt')
run('Part 2 (Example)', 'day_15_example_input.txt', 5)
# Pretty slow. Heuristics or priority queue?
run('Part 2', 'day_15_input.txt', 5)
