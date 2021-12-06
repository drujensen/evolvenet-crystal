module EvolveNet
  class Neuron
    property :activation, :bias, :synapses, :function
    property drop_rate : Float64

    def initialize(@function : Symbol)
      @activation = 0_f64
      @bias = 0_f64
      @synapses = Array(Synapse).new
      @drop_rate = rand(0.0..1.0)
    end

    def clone
      neuron = Neuron.new(@function)
      neuron.activation = @activation
      neuron.bias = @bias
      neuron.drop_rate = @drop_rate
      @synapses.each do |synapse|
        neuron.synapses << synapse.clone
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

    def punctuate(pos : Int32)
      @bias = @bias.round(pos)
      @synapses.each { |s| s.punctuate(pos) }
    end

    def activate(value : Number)
      @activation = value
    end

    def activate(prev_layer : Layer)
      if @function == :min
        min = prev_layer.neurons[@synapses[0].neuron_index].activation
        @synapses.each { |s| min = (min > prev_layer.neurons[s.neuron_index].activation ? prev_layer.neurons[s.neuron_index].activation : min) }
        @activation = none(min)
      elsif @function == :avg
        sum = @synapses.sum { |s| prev_layer.neurons[s.neuron_index].activation }
        @activation = none(sum / @synapses.size)
      elsif @function == :max
        max = 0_f64
        @synapses.each { |s| max = (max < prev_layer.neurons[s.neuron_index].activation ? prev_layer.neurons[s.neuron_index].activation : max) }
        @activation = none(max)
      else
        sum = @synapses.sum { |s| s.weight * prev_layer.neurons[s.neuron_index].activation }
        if @function == :none
          @activation = none(sum + @bias)
        elsif @function == :relu
          @activation = relu(sum + @bias)
        elsif @function == :sigmoid
          @activation = sigmoid(sum + @bias)
        elsif @function == :tanh
          @activation = tanh(sum + @bias)
        elsif @function == :drop
          @activation = drop(sum + @bias)
        else
          raise "activation function #{@function} is not supported"
        end
      end
    end

    def none(value : Number) : Float64
      value.to_f64
    end

    def relu(value : Number) : Float64
      value < 0 ? 0.to_f64 : value.to_f64
    end

    def sigmoid(value : Number) : Float64
      (1.0/(1.0 + Math::E**(-value))).to_f64
    end

    def tanh(value : Number) : Float64
      ((Math::E**(value) - Math::E**(-value))/(Math::E**(value) + Math::E**(-value))).to_f64
    end

    def drop(value : Number) : Float64
      @drop_rate < 0.3 ? 0.to_f64 : value.to_f64
    end
  end
end
