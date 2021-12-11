require "json"

module EvolveNet
  class Synapse
    include JSON::Serializable

    @[JSON::Field(key: "i")]
    property neuron_index : Int32
    @[JSON::Field(key: "w")]
    property weight : Float64

    def initialize(@neuron_index : Int32, @weight : Float64 = 0.0_f64)
    end

    def clone
      Synapse.new(@neuron_index, @weight)
    end

    def randomize
      @weight = rand(-1_f64..1_f64)
    end

    def mutate(mutation_rate : Float64)
      @weight += rand(-mutation_rate..mutation_rate)
    end

    def punctuate(pos : Int32)
      @weight = @weight.round(pos)
    end
  end
end
