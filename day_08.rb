class SevenSegmentDisplays
  DIGIT_SEGMENTS = ['abcefg',
                    'cf',
                    'acdeg',
                    'acdfg',
                    'bcdf',
                    'abdfg',
                    'abdefg',
                    'acf',
                    'abcdefg',
                    'abcdfg']

  def initialize(filename)
    @displays = File.read(filename).strip.split("\n").map do |line|
      line.split("|").map { |value| value.scan(/[a-g]+/) }
    end
  end

  def part_1
    unique_lengths = [1, 4, 7, 8].map do |i|
      DIGIT_SEGMENTS[i].length
    end

    @displays.flat_map { |_signal, output| output }.count do |segments|
      unique_lengths.member?(segments.length)
    end
  end

  def part_2
    @displays.sum do |display|
      value = output_value(display)
    end
  end

  private

  def output_value(display)
    map = {}
    freqs = display[0].flat_map(&:chars).tally.invert

    # b, e, and f all have unique frequencies
    map['b'] = freqs[6]
    map['e'] = freqs[4]
    map['f'] = freqs[9]

    # since we know 'f', we now know the other segment in 1 will be 'c'
    ones = display[0].find { |segments| segments.length == 2 }
    map['c'] = (ones.chars - [map['f']]).first

    # since we know 1's segments, we can find 'a' from 7's segments.
    sevens = display[0].find { |segments| segments.length == 3 }
    map['a'] = (sevens.chars - [map['c'], map['f']]).first

    # since we know 1's segments and 'b', we can find 'd' from 4's segments.
    fours = display[0].find { |segments| segments.length == 4 }
    map['d'] = (fours.chars - [map['b'], map['c'], map['f']]).first

    # at this point we know a, b, c, d, e, and f. So the only one left is g.
    map['g'] = (%w[a b c d e f g] - map.values).first

    # let's translate the output portion!
    tr_1 = map.values.join
    tr_2 = map.keys.join

    display[1]
      .map { |segments| segments.tr(tr_1, tr_2) }
      .map { |segments| segments_to_digit(segments) }
      .join
      .to_i
  end

  def segments_to_digit(segments)
    DIGIT_SEGMENTS.find_index(segments.chars.sort.join)
  end
end

def run_part_1(name, filename)
  seven_segment_displays = SevenSegmentDisplays.new(filename)
  puts "#{name}: #{seven_segment_displays.part_1}"
end

def run_part_2(name, filename)
  seven_segment_displays = SevenSegmentDisplays.new(filename)
  puts "#{name}: #{seven_segment_displays.part_2}"
end

run_part_1('Part 1 (Example)', 'day_08_example_input.txt')
run_part_1('Part 1', 'day_08_input.txt')
run_part_2('Part 2 (Example)', 'day_08_example_input.txt')
run_part_2('Part 2', 'day_08_input.txt')
