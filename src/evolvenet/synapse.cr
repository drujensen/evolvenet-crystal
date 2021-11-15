module EvolveNet
  class Synapse
    property :neuron, :weight

    def initialize(@neuron : Neuron, @weight : Float64 = 0.0_f64)
    end

    def randomize
      @weight = rand(-1_f64..1_f64)
    end

    def mutate(mutation_rate : Float64)
      @weight += rand(-mutation_rate..mutation_rate)
    end
  end
end
