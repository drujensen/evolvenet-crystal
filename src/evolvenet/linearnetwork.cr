require "./network"

# y = mx + b
module EvolveNet
  class LinearNetwork < Network
    property error : Float64
    property m : Float64
    property b : Float64

    def initialize
      @error = 1_f64
      @m = 0_f64
      @b = 0_f64
    end

    def clone
      network = LinearNetwork.new
      network.m = @m
      network.b = @b
      network
    end

    def randomize
      @m = rand(-1_f64..1_f64)
      @b = rand(-1_f64..1_f64)
      self
    end

    def mutate
      @m += rand(-@error..@error)
      @b += rand(-@error..@error)
      self
    end

    def punctuate(pos : Int32)
      @m = @m.round(pos)
      @b = @b.round(pos)
      self
    end

    def run(data : Array(Number))
      x = data[0]
      [(@m * x) + @b]
    end

    def evaluate(data : Array(Array(Array(Number))))
      sum = 0_f64
      data.each do |row|
        actual = run(row[0])
        expected = row[1]
        expected.each_with_index do |exp, idx|
          act = actual[idx]
          sum += (exp - act)**2
        end
      end
      @error = sum / (2 * data.size)
    end
  end
end
