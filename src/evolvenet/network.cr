module EvolveNet
  class Network
    property :layers, :error

    def initialize
      @error = 0_f64
      @layers = Array(Layer).new
    end

    def add_layer(type : Symbol, size : Int32)
      @layers << Layer.new(type, size)
    end

    def fully_connect
      @layers.each_with_index do |layer, index|
        if layer.type != :input
          prev_layer = @layers[index - 1]
          layer.neurons.each do |neuron|
            prev_layer.neurons.each do |prev_neuron|
              neuron.synapses << Synapse.new(prev_neuron)
            end
          end
        end
      end
    end

    def clone
      network = Network.new
      @layers.each_with_index do |layer, index|
        if index == 0
          network.layers << layer.clone
        else
          network.layers << layer.clone(network.layers[index - 1])
        end
      end
      network
    end

    def evaluate(data : Array(Array(Array(Number))))
      sum = 0_f64
      data.each do |row|
        test_data = row[0]
        expected = row[1]
        actual = run(test_data)
        expected.each_with_index do |exp, idx|
          act = actual[idx]
          sum += (exp - act)**2
        end
      end
      @error = sum / data.size
    end

    def randomize
      @layers.each { |l| l.randomize }
      self
    end

    def mutate(mutation_rate : Float64)
      @layers.each { |l| l.mutate(mutation_rate) }
      self
    end

    def run(data : Array(Number))
      @layers.each do |layer|
        layer.neurons.each_with_index do |neuron, idx|
          if layer.type == :input
            neuron.activate(data[idx])
          else
            neuron.activate
          end
        end
      end
      @layers.last.neurons.map { |n| n.activation }
    end
  end
end
