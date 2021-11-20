require "./spec_helper"

describe EvolveNet do
  it "works with xor" do
    network = EvolveNet::Network.new
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

    organism = EvolveNet::Organism.new(network, 1, 0)
    network = organism.evolve(data, 10000)

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
    network.add_layer(:input, 4)
    network.add_layer(:hidden, 5)
    network.add_layer(:output, 3)
    network.fully_connect

    data = EvolveNet::Data.new_with_csv_input_target("spec/test_data/iris.csv", 0..3, 4)

    organism = EvolveNet::Organism.new(network, 10, 0.1)
    network = organism.evolve(data.data, 20000)

    correct = 0
    data.data.each do |data_point|
      result = network.run(data_point[0])
      expected = data_point[1]
      error_sum = 0.0
      result.size.times do |i|
        error_sum += (result[i] - expected[i]).abs
      end
      correct += 1 if error_sum < 0.1
    end
    accuracy = (correct.to_f64 / data.size)
    puts "iris: #{correct} / #{data.size}, Accuracy: #{(accuracy*100).round(3)}%"
  end
end
