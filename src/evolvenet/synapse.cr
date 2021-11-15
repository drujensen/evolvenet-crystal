module EvolveNet
  class Synapse
    property :neuron, :weight

    def initialize(@neuron : Neuron, @weight : Float64 = 0.0_f64)
    end

    def randomize
      @weight = rand(-0.1_f64..0.1_f64)
    end

    def evolve
      @weight += rand(-0.001_f64..0.001_f64)
    end
  end
end
