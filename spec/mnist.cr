require "./spec_helper"

network = EvolveNet::NeuralNetwork.new
network.add_layer(:input, 28, 28, 1, :none)
network.add_layer(:pool3, 9, 9, 9, :relu)
network.add_layer(:output, 10, :sigmoid)
network.fully_connect

data = EvolveNet::Data.new_with_csv_input_target("#{File.dirname(__FILE__)}/../spec/test_data/mnist.csv", 1..785, 0)
training, testing = data.split(0.001)
organism = EvolveNet::Organism.new(network)
network = organism.evolve(training.raw_data, 10000, 0.01)

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
