class Heightmap
  def initialize(filename)
    lines = File.read(filename).strip.split("\n")
    @heights = lines.each_with_index.flat_map do |line, y|
      line.chars.each_with_index.map { |c, x| [[x, y], c.to_i] }
    end.to_h
  end

  def risk_levels_sum
    @heights
      .select { |pos, _| lower_options(pos).size.zero? }
      .map { |_, height| height + 1 }
      .sum
  end

  def basin_sizes_product(limit)
    lookup = {}
    @heights
      .select { |_, height| height < 9 }
      .each { |pos, _| low_points_for_pos(pos, lookup) }

    basin_sizes = Hash.new(0)
    lookup.each do |_, low_points|
      # Everything will have just 1 lowest point, by setup.
      basin_sizes[low_points[0]] += 1
    end

    basin_sizes.values.sort.last(limit).reduce(:*)
  end

  private

  def lower_options(pos)
    x, y = pos

    [[x, y - 1], [x + 1, y], [x, y + 1], [x - 1, y]].select do |opt|
      @heights.fetch(opt, 10) < @heights[pos]
    end
  end

  def low_points_for_pos(pos, lookup = {})
    return lookup[pos] if lookup[pos]
    opts = lower_options(pos)
    lookup[pos] = if opts.empty?
                    [pos]
                  else
                    # First option is fine?
                    opts.flat_map { |opt| low_points_for_pos(opt, lookup) }.uniq
                  end
  end
end

def run_part_1(name, filename)
  heightmap = Heightmap.new(filename)
  puts "#{name}: #{heightmap.risk_levels_sum}"
end

def run_part_2(name, filename)
  heightmap = Heightmap.new(filename)
  puts "#{name}: #{heightmap.basin_sizes_product(3)}"
end


run_part_1('Part 1 (Example)', 'day_09_example_input.txt')
run_part_1('Part 1', 'day_09_input.txt')
run_part_2('Part 2 (Example)', 'day_09_example_input.txt')
run_part_2('Part 2', 'day_09_input.txt')
