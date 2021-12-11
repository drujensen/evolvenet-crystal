require "json"

# y = ax**2 + bx + c
module EvolveNet
  class QuadradicNetwork < Network
    include JSON::Serializable

    @[JSON::Field(key: "e")]
    property error : Float64
    property a : Float64
    property b : Float64
    property c : Float64

    def initialize
      @error = 1_f64
      @a = 0_f64
      @b = 0_f64
      @c = 0_f64
    end

    def clone
      network = QuadradicNetwork.new
      network.a = @a
      network.b = @b
      network.c = @c
      network
    end

    def randomize
      @a = rand(-1_f64..1_f64)
      @b = rand(-1_f64..1_f64)
      @c = rand(-1_f64..1_f64)
      self
    end

    def mutate
      @a += rand(-@error..@error)
      @b += rand(-@error..@error)
      @c += rand(-@error..@error)
      self
    end

    def punctuate(pos : Int32)
      @a = @a.round(pos)
      @b = @b.round(pos)
      @c = @c.round(pos)
      self
    end

    def run(data : Array(Number))
      x = data[0]
      [(@a * x**2) + (@b * x) + @c]
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
