require "./spec_helper"

def sigmoid(value : Float64) : Float64
  (1.0/(1.0 + Math::E**(-value))).to_f64
end

describe EvolveNet do
  it "works" do
    network = EvolveNet::Network.new
    network.add_layer(:input, 2)
    network.add_layer(:hidden, 2)
    network.add_layer(:output, 1)
    network.connect_layers

    training_data = [
      [[0, 0], [0]],
      [[0, 1], [1]],
      [[1, 0], [1]],
      [[1, 1], [0]],
    ]

    organism = EvolveNet::Organism.new(network)
    organism.evolve(training_data)
    network = organism.evolved_network

    puts network.run([0, 0])
    puts network.run([0, 1])
    puts network.run([1, 0])
    puts network.run([1, 1])
  end
end
