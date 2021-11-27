module EvolveNet
  class Network
    property :layers, :error

    def initialize
      @error = 1_f64
      @layers = Array(Layer).new
    end

    def add_layer(type : Symbol, size : Int32, function : Symbol = :sigmoid)
      @layers << Layer.new(type, size, function)
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

    def randomize
      @error = 1_f64
      @layers.each { |l| l.randomize }
      self
    end

    def mutate
      @layers.each { |l| l.mutate(@error) }
      self
    end

    def punctuate(pos : Int32)
      @layers.each { |l| l.punctuate(pos) }
      self
    end

    def run(data : Array(Number))
      @layers.each { |l| l.activate(data) }
      @layers.last.neurons.map { |n| n.activation }
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
  end
end
