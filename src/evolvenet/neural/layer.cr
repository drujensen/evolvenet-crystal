require "json"

module EvolveNet
  class Layer
    include JSON::Serializable

    property :type, :neurons, :size, :width, :height, :depth, :function

    def initialize(@type : Symbol, @size : Int32 = 0, @function : Symbol = :signoid)
      @width = 0
      @height = 0
      @depth = 0
      @neurons = Array(Neuron).new(size) { Neuron.new(@function) }
    end

    def initialize(@type : Symbol, @width : Int32, @height : Int32, @depth : Int32, @function : Symbol = :relu)
      @size = @width * @height * @depth
      @neurons = Array(Neuron).new(@size) { Neuron.new(@function) }
    end

    def clone
      layer = Layer.new(@type, 0, @function)
      layer.width = @width
      layer.height = @height
      layer.depth = @depth
      @neurons.each do |neuron|
        layer.neurons << neuron.clone
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
        neuron.activate(data[idx])
      end
    end

    def activate(prev_layer : Layer)
      if @type == :max
        puts "neuron size: #{@neurons.size}"
      end
      @neurons.each do |neuron|
        neuron.activate(prev_layer)
      end
    end
  end
end
