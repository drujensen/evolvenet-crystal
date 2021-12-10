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
      @layers << Layer.new(type, width, height, depth, function)
    end

    def fully_connect
      @layers.each_with_index do |layer, index|
        prev_layer = @layers[index - 1]
        window = 1
        stride = 1
        padding = 0

        if layer.type == :conv
          window = 3
          stride = 1
          padding = 1
        end

        if layer.type == :pool
          window = 2
          stride = 2
          padding = 0
        end

        if layer.type == :conv || layer.type == :pool || layer.type == :filter
          (0...layer.depth).each do |depth|
            (0...layer.height).each do |height|
              (0...layer.width).each do |width|
                pxl = (height * layer.width) + width
                idx = (depth * layer.width * layer.height) + pxl
                (0...prev_layer.depth).each do |z|
                  d = (z * prev_layer.width * prev_layer.height)
                  window.times do |y|
                    row = y - padding
                    window.times do |x|
                      col = x - padding
                      pos = (pxl * stride) + (d + (row * prev_layer.width) + col)
                      start = d
                      stop = d + (prev_layer.width * prev_layer.height)
                      next if pos < start || pos >= stop
                      layer.neurons[idx].synapses << Synapse.new(pos)
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
