require "./spec_helper"

describe EvolveNet do
  it "xor" do
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

    organism = EvolveNet::Organism.new(network, 100)
    organism.evolve(training_data, 1000, 0.05)
    network = organism.evolved_network

    puts network.run([0, 0])
    puts network.run([0, 1])
    puts network.run([1, 0])
    puts network.run([1, 1])
  end
end
