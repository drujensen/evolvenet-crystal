require "./spec_helper"

describe EvolveNet::NeuralNetwork do
  it "works with mnist" do
    network = EvolveNet::NeuralNetwork.new
    network.add_layer(:input, 28, 28, 1, :none)
    network.add_layer(:pool3, 9, 9, 10, :relu)
    network.add_layer(:pool3, 3, 3, 20, :relu)
    network.add_layer(:output, 10, :sigmoid)
    network.fully_connect

    data = EvolveNet::Data.new_with_csv_input_target("#{File.dirname(__FILE__)}/test_data/mnist.csv", 1..785, 0)
    training, testing = data.split(0.1)
    organism = EvolveNet::Organism.new(network, 64)
    network = organism.evolve(training.raw_data, 5000, 0.01, 1)

    tp = 0
    training.raw_data.each do |data|
      result = network.run(data[0])
      if (result.index(result.max) == data[1].index(data[1].max))
        tp += 1
      end
    end
    puts "Accuracy: #{tp / training.size.to_f} Correct: #{tp} Size: #{training.size}"

    tp = 0
    testing.raw_data.each do |data|
      result = network.run(data[0])
      if (result.index(result.max) == data[1].index(data[1].max))
        tp += 1
      end
    end
    puts "Accuracy: #{tp / testing.size.to_f} Correct: #{tp} Size: #{testing.size}"
  end
end
