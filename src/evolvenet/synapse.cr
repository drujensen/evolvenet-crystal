module EvolveNet
  class Synapse
    property :neuron, :a_weight, :b_weight

    def initialize(@neuron : Neuron, @a_weight : Float64 = 0.0_f64, @b_weight : Float64 = 0.0_f64)
    end

    def randomize
      @a_weight = rand(-1_f64..1_f64)
      @b_weight = rand(-1_f64..1_f64)
    end

    def mutate(mutation_rate : Float64)
      @a_weight += rand(-mutation_rate..mutation_rate)
      @b_weight += rand(-mutation_rate..mutation_rate)
    end

    def punctuate(pos : Int32)
      @a_weight = @a_weight.round(pos)
      @b_weight = @b_weight.round(pos)
    end
  end
end
