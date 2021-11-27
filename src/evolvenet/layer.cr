module EvolveNet
  class Layer
    property :type, :neurons, :size, :function

    def initialize(@type : Symbol, size : Int32 = 0, @function : Symbol = :none)
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
      neuron_mutation_rate = Math.min(0.01, mutation_rate / @neurons.size)
      @neurons.each { |n| n.mutate(neuron_mutation_rate) }
    end

    def punctuate(pos : Int32)
      @neurons.each { |n| n.punctuate(pos) }
    end

    def activate(data : Array(Number))
      @neurons.each_with_index do |neuron, idx|
        if @type == :input
          neuron.activate(data[idx])
        else
          neuron.activate
        end
      end
    end
  end
end
