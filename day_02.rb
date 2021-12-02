class Plan
  attr_reader :steps

  def initialize(filename)
    lines = File.read(filename).strip.split("\n")
    @steps = lines.map { |line| line_to_step(line) }
  end

  private

  def line_to_step(line)
    action, magnitude_string = line.split(' ')
    [action, magnitude_string.to_i]
  end
end

class Submarine
  attr_reader :position

  def initialize()
    @position = [0, 0, 0]
    @aim = 0
  end

  def follow_plan(plan)
    plan.steps.each { |step| follow_step(step) }
  end

  def follow_plan_with_aim(plan)
    plan.steps.each { |step| follow_step_with_aim(step) }
  end

  private

  def follow_step(step)
    action, magnitude = step
    point = case action
            when 'left' then [-magnitude, 0, 0]
            when 'right' then [magnitude, 0, 0]
            when 'backward' then [0, -magnitude, 0]
            when 'forward' then [0, magnitude, 0]
            when 'up' then [0, 0, -magnitude]
            when 'down' then [0, 0, magnitude]
            end
    @position = @position.zip(point).map(&:sum)
  end

  def follow_step_with_aim(step)
    action, magnitude = step
    pos_change, aim_change = case action
                             when 'left' then [[-magnitude, 0, 0], 0]
                             when 'right' then [[magnitude, 0, 0], 0]
                             when 'backward' then [[0, -magnitude, magnitude * @aim], 0]
                             when 'forward' then [[0, magnitude, magnitude * @aim], 0]
                             when 'up' then [[0, 0, 0], -magnitude]
                             when 'down' then [[0, 0, 0], magnitude]
                             end
    @position = @position.zip(pos_change).map(&:sum)
    @aim += aim_change
  end
end

def run_sub(name, filename, with_aim = false)
  sub = Submarine.new
  plan = Plan.new(filename)
  if with_aim then sub.follow_plan_with_aim(plan) else sub.follow_plan(plan) end
  puts "#{name}: #{sub.position[1] * sub.position[2]}"
end

run_sub('Part 1 (Example)', 'day_02_example_input.txt')
run_sub('Part 1', 'day_02_input.txt')
run_sub('Part 2 (Example)', 'day_02_example_input.txt', true)
run_sub('Part 2', 'day_02_input.txt', true)
