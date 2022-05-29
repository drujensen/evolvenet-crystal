require "json"

module EvolveNet
  class Synapse
    include JSON::Serializable

    @[JSON::Field(key: "i")]
    property index : Int32
    @[JSON::Field(key: "w")]
    property weight : Float64

    def initialize(@index : Int32, @weight : Float64 = 0.0_f64)
    end

    def clone
      Synapse.new(@index, @weight)
    end

    def randomize
      @weight = rand(-1_f64..1_f64)
    end

    def mutate(rate : Float64)
      @weight += rand(-rate..rate)
    end

    def punctuate(pos : Int32)
      @weight = @weight.round(pos)
    end
  end

  class Neuron
    include JSON::Serializable

    @[JSON::Field(key: "s")]
    property synapses : Array(Synapse)
    @[JSON::Field(key: "f")]
    property function : String
    @[JSON::Field(ignore: true)]
    property activation : Number = 0_f64
    @[JSON::Field(key: "b")]
    property bias : Float64

    def initialize(@function : String)
      @activation = 0_f64
      @bias = 0_f64
      @synapses = Array(Synapse).new
    end

    def clone
      neuron = Neuron.new(@function)
      neuron.activation = @activation
      neuron.bias = @bias
      @synapses.each do |synapse|
        neuron.synapses << synapse.clone
      end
      neuron
    end

    def randomize
      @bias = rand(-1_f64..1_f64)
      @synapses.each { |s| s.randomize }
    end

    def mutate(rate : Float64)
      @bias += rand(-rate..rate)
      synapse_rate = rate / @synapses.size
      @synapses.each { |s| s.mutate(synapse_rate) }
    end

    def punctuate(pos : Int32)
      @bias = @bias.round(pos)
      @synapses.each { |s| s.punctuate(pos) }
    end

    def activate(value : Number)
      @activation = value
    end

    def activate(parent : Layer)
      if @function == "min"
        min = parent.neurons[@synapses[0].index].activation
        @synapses.each { |s| min = (min > parent.neurons[s.index].activation ? parent.neurons[s.index].activation : min) }
        @activation = none(min)
      elsif @function == "avg"
        sum = @synapses.sum { |s| parent.neurons[s.index].activation }
        @activation = none(sum / @synapses.size)
      elsif @function == "max"
        max = 0_f64
        @synapses.each { |s| max = (max < parent.neurons[s.index].activation ? parent.neurons[s.index].activation : max) }
        @activation = none(max)
      else
        sum = @synapses.sum { |s| s.weight * parent.neurons[s.index].activation }
        if @function == "none"
          @activation = none(sum + @bias)
        elsif @function == "relu"
          @activation = relu(sum + @bias)
        elsif @function == "sigmoid"
          @activation = sigmoid(sum + @bias)
        elsif @function == "tanh"
          @activation = tanh(sum + @bias)
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
  end

  class Layer
    include JSON::Serializable

    @[JSON::Field(key: "t")]
    property type : String
    @[JSON::Field(key: "n")]
    property neurons : Array(Neuron)
    @[JSON::Field(key: "s")]
    property size : Int32
    @[JSON::Field(key: "w")]
    property width : Int32
    @[JSON::Field(key: "h")]
    property height : Int32
    @[JSON::Field(key: "d")]
    property depth : Int32
    @[JSON::Field(key: "f")]
    property function : String

    def initialize(@type : String, @size : Int32 = 0, @function : String = "signoid")
      @width = 0
      @height = 0
      @depth = 0
      @neurons = Array(Neuron).new(size) { Neuron.new(@function) }
    end

    def initialize(@type : String, @width : Int32, @height : Int32, @depth : Int32, @function : String = "relu")
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

    def mutate(rate : Float64)
      neuron_rate = rate / @neurons.size
      @neurons.each { |n| n.mutate(neuron_rate) }
    end

    def punctuate(pos : Int32)
      @neurons.each { |n| n.punctuate(pos) }
    end

    def activate(parent : Layer)
      @neurons.each do |neuron|
        neuron.activate(parent)
      end
    end

    def activate(data : Array(Number))
      @neurons.each_with_index do |neuron, idx|
        neuron.activate(data[idx])
      end
    end
  end

  class NeuralNetwork < Network
    include JSON::Serializable

    @[JSON::Field(key: "l")]
    property layers : Array(Layer)

    @[JSON::Field(key: "e")]
    property error : Float64

    def initialize
      @error = 1_f64
      @layers = Array(Layer).new
    end

    def add_layer(type : Symbol, size : Int32, function : Symbol = :sigmoid)
      @layers << Layer.new(type.to_s, size, function.to_s)
    end

    def add_layer(type : Symbol, width : Int32, height : Int32, depth : Int32, function : Symbol = :relu)
      @layers << Layer.new(type.to_s, width, height, depth, function.to_s)
    end

    def fully_connect
      @layers.each_with_index do |layer, index|
        parent = @layers[index - 1]
        window = 1
        stride = 1
        padding = 0

        if layer.type == "conv"
          window = 3
          stride = 1
          padding = 1
        end

        if layer.type == "pool"
          window = 2
          stride = 2
          padding = 0
        end

        if layer.type == "pool3"
          window = 3
          stride = 3
          padding = 0
        end

        if layer.type == "pool4"
          window = 4
          stride = 4
          padding = 0
        end

        if layer.type == "hidden" || layer.type == "output"
          layer.neurons.each do |neuron|
            parent.neurons.size.times do |idx|
              neuron.synapses << Synapse.new(idx)
            end
          end
        else
          (0...layer.depth).each do |depth|
            (0...layer.height).each do |height|
              (0...layer.width).each do |width|
                pxl = (height * layer.width) + width
                idx = (depth * layer.width * layer.height) + pxl
                (0...parent.depth).each do |z|
                  d = (z * parent.width * parent.height)
                  window.times do |y|
                    row = y - padding
                    window.times do |x|
                      col = x - padding
                      pos = (pxl * stride) + (d + (row * parent.width) + col)
                      start = d
                      stop = d + (parent.width * parent.height)
                      next if pos < start || pos >= stop
                      layer.neurons[idx].synapses << Synapse.new(pos)
                    end
                  end
                end
              end
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
