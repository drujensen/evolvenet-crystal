require "./spec_helper"

describe EvolveNet::NeuralNetwork do
  it "works with xor" do
    network = EvolveNet::NeuralNetwork.new
    network.add_layer(:input, 2)
    network.add_layer(:hidden, 2)
    network.add_layer(:output, 1)
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

    training.confusion_matrix(network)
  end

  it "works with iris" do
    network = EvolveNet::NeuralNetwork.new
    network.add_layer(:input, 4)
    network.add_layer(:hidden, 5)
    network.add_layer(:output, 3)
    network.fully_connect

    training = EvolveNet::Data.new_with_csv_input_target("#{File.dirname(__FILE__)}/../spec/test_data/iris.csv", 0..3, 4)

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.normalized_data, 10000, 0.01)

    training.confusion_matrix(network)
  end
end
