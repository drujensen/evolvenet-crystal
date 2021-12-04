module EvolveNet
  class NeuralNetwork < Network
    property :layers
    property error : Float64

    def initialize
      @error = 1_f64
      @layers = Array(Layer).new
    end

    def add_layer(type : Symbol, size : Int32, function : Symbol = :sigmoid)
      @layers << Layer.new(type, size, function)
    end

    def add_layer(type : Symbol, width : Int32, height : Int32, depth : Int32, function : Symbol = :relu)
      if type == :conv && @layers.last.width != width + 2 && @layers.last.height != height + 2
        raise "padding not supported yet. width and height need to be 2 smaller than previous layer"
      end
      @layers << Layer.new(type, width, height, depth, function)
    end

    def fully_connect
      @layers.each_with_index do |layer, index|
        prev_layer = @layers[index - 1]

        if layer.type == :conv
          layer.width.times do |width|
            layer.height.times do |height|
              layer.depth.times do |depth|
                pos = width * height * depth
                3.times.each do |x|
                  3.times.each do |y|
                    prev_layer.depth.times do |d|
                      neuron_index = (width + x) * (height + y) * d
                      layer.neurons[pos].synapses << Synapse.new(neuron_index)
                    end
                  end
                end
              end
            end
          end
        end

        if layer.type == :hidden || layer.type == :output
          layer.neurons.each do |neuron|
            prev_layer.neurons.size.times do |idx|
              neuron.synapses << Synapse.new(idx)
            end
          end
        end
      end
    end

    def clone
      network = NeuralNetwork.new
      @layers.each do |layer|
        network.layers << layer.clone
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
      @layers.each_with_index do |layer, index|
        if index == 0
          layer.activate(data)
        else
          layer.activate(@layers[index - 1])
        end
      end
      @layers.last.neurons.map { |n| n.activation }
    end

    def evaluate(data : Array(Array(Array(Number))))
      sum = 0_f64
      data.each do |row|
        actual = run(row[0])
        expected = row[1]
        expected.each_with_index do |exp, idx|
          act = actual[idx]
          sum += (exp - act)**2
        end
      end
      @error = sum / (2 * data.size)
    end
  end
end
