module EvolveNet
  class Layer
    property :type, :neurons

    def initialize(@type : Symbol, size : Int32 = 0)
      @neurons = Array(Neuron).new(size) { Neuron.new }
    end

    def clone(prev_layer : Layer? = nil)
      layer = Layer.new(@type)
      @neurons.each do |neuron|
        layer.neurons << neuron.clone(prev_layer)
      end
      layer
    end

    def randomize
      @neurons.each { |n| n.randomize }
    end

    def evolve
      @neurons.each { |n| n.evolve }
    end
  end
end
