class LanternFishSchool
  MAX_DAYS = 8

  def initialize(timers)
    @counts = Array.new(MAX_DAYS + 1, 0)
    timers.map { |timer| @counts[timer] += 1 }
  end

  def pass_day
    new_counts = Array.new(MAX_DAYS + 1, 0)
    @counts.each_with_index do |count, index|
      if index == 0
        new_counts[MAX_DAYS] += count
        new_counts[MAX_DAYS - 2] += count
      else
        new_counts[index - 1] += count
      end
    end
    @counts = new_counts
  end

  def pass_days(days)
    days.times.each { pass_day }
  end

  def count
    @counts.sum
  end

  def to_s
    @lantern_fish.map { |lf| lf.timer }.join(',')
  end
end

def run(name, filename, days)
  timers = File.read(filename).scan(/\d+/).map(&:to_i)
  lantern_fish_school = LanternFishSchool.new(timers)
  lantern_fish_school.pass_days(days)
  puts "#{name}: #{lantern_fish_school.count}"
end

# I did a class-based approach before, and missed that the fish could
# simply cycle together as a count based on the timer. This approach
# of compressing them is significantly faster, but it does not
# preserve the order as printed in the example.

run('Part 1 (Example)', 'day_06_example_input.txt', 80)
run('Part 1', 'day_06_input.txt', 80)
run('Part 2 (Example)', 'day_06_example_input.txt', 256)
run('Part 2', 'day_06_input.txt', 256)
