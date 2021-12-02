class SonarSweep
  def initialize(filename)
    @depths = File.read(filename).strip.split("\n").map(&:to_i)
  end

  def depth_increases
    windows(@depths, 2).count { |a, b| b > a }
  end

  def windowed_depth_increases(window_size)
    windows(windows(@depths, window_size).map(&:sum), 2).count { |a, b| b > a }
  end

  private

  def windows(array, window_size)
    elems = []
    (array.size - (window_size - 1)).times do |i|
      elems << array[i...(i + window_size)]
    end
    elems
  end
end

example_sonar_sweep = SonarSweep.new('day_01_example_input.txt')
sonar_sweep = SonarSweep.new('day_01_input.txt')
puts "Part 1 (Example): #{example_sonar_sweep.depth_increases}"
puts "Part 1: #{sonar_sweep.depth_increases}"
puts "Part 2 (Example): #{example_sonar_sweep.windowed_depth_increases(3)}"
puts "Part 2: #{sonar_sweep.windowed_depth_increases(3)}"
