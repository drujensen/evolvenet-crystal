require "./spec_helper"

network = EvolveNet::NeuralNetwork.new
network.add_layer(:input, 28, 28, 1, :none)
network.add_layer(:conv, 28, 28, 3, :relu)
network.add_layer(:pool, 14, 14, 3, :max)
network.add_layer(:output, 10, :sigmoid)
network.fully_connect

training = EvolveNet::Data.new_with_csv_input_target("#{File.dirname(__FILE__)}/../spec/test_data/mnist.csv", 1..785, 0)
organism = EvolveNet::Organism.new(network)
network = organism.evolve(training.raw_data, 10000, 0.01)

training.raw_confusion_matrix(network)
