require "./spec_helper"

describe EvolveNet do
  it "works with xor" do
    network = EvolveNet::Network.new
    network.add_layer(:input, 2, :sigmoid)
    network.add_layer(:hidden, 2, :sigmoid)
    network.add_layer(:output, 1, :sigmoid)
    network.fully_connect

    data = [
      [[0, 0], [0]],
      [[0, 1], [1]],
      [[1, 0], [1]],
      [[1, 1], [0]],
    ]
    training = EvolveNet::Data.new(data)
    training.normalize_min_max

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.normalized_data)

    puts "works with xor"
    training.confusion_matrix(network)
  end

  it "works with iris" do
    network = EvolveNet::Network.new
    network.add_layer(:input, 4, :sigmoid)
    network.add_layer(:hidden, 5, :sigmoid)
    network.add_layer(:output, 3, :sigmoid)
    network.fully_connect

    training = EvolveNet::Data.new_with_csv_input_target("#{File.dirname(__FILE__)}/../spec/test_data/iris.csv", 0..3, 4)

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.normalized_data, 50000, 0.0000001, 100)

    puts "works with iris"
    training.confusion_matrix(network)
  end
end
