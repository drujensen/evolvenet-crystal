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

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(data)
    network.punctuate(1)

    correct = 0
    data.each do |data_point|
      result = network.run(data_point[0])
      expected = data_point[1]
      error_sum = 0.0
      result.size.times do |i|
        error_sum += (result[i] - expected[i]).abs
      end
      correct += 1 if error_sum < 0.1
    end
    accuracy = (correct.to_f64 / data.size)
    puts "xor: #{correct} / #{data.size}, Accuracy: #{(accuracy*100).round(3)}%"
  end

  it "works with iris" do
    network = EvolveNet::Network.new
    network.add_layer(:input, 4, :sigmoid)
    network.add_layer(:hidden, 5, :sigmoid)
    network.add_layer(:output, 3, :sigmoid)
    network.fully_connect

    data = EvolveNet::Data.new_with_csv_input_target("#{File.dirname(__FILE__)}/../spec/test_data/iris.csv", 0..3, 4)

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(data.normalized_data, 50000)

    data.confusion_matrix(network)
  end
end
