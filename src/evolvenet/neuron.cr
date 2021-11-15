module EvolveNet
  class Neuron
    property :activation, :bias, :synapses

    def initialize
      @activation = 0.0_f64
      @bias = 0.0_f64
      @synapses = Array(Synapse).new
    end

    def clone(prev_layer : Layer? = nil)
      neuron = Neuron.new
      neuron.activation = @activation
      neuron.bias = @bias
      if prev_layer
        prev_layer.neurons.each_with_index do |prev_neuron, index|
          neuron.synapses << Synapse.new(prev_neuron, @synapses[index].weight)
        end
      end
      neuron
    end

    def randomize
      @bias = rand(-1_f64..1_f64)
      @synapses.each { |s| s.randomize }
    end

    def mutate(mutation_rate : Float64)
      @bias += rand(-mutation_rate..mutation_rate)
      @synapses.each { |s| s.mutate(mutation_rate) }
    end

    def activate(value : Number)
      @activation = value
    end

    def activate
      sum = @synapses.sum { |s| s.weight * s.neuron.activation }
      @activation = sigmoid(sum + @bias)
    end

    def sigmoid(value : Number) : Float64
      (1.0/(1.0 + Math::E**(-value))).to_f64
    end
  end
end
