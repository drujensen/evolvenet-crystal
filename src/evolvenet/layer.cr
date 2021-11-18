module EvolveNet
  class Layer
    property :type, :neurons, :size, :function

    def initialize(@type : Symbol, size : Int32 = 0, @function : Symbol = :sigmoid)
      @neurons = Array(Neuron).new(size) { Neuron.new(@function) }
    end

    def clone(prev_layer : Layer? = nil)
      layer = Layer.new(@type, 0, @function)
      @neurons.each do |neuron|
        layer.neurons << neuron.clone(prev_layer)
      end
      layer
    end

    def randomize
      @neurons.each { |n| n.randomize }
    end

    def mutate(mutation_rate : Float64)
      @neurons.each { |n| n.mutate(mutation_rate) }
    end
  end
end
