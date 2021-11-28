require "./spec_helper"

describe EvolveNet do
  it "guesses your number" do
    data = [
      [[0], [0]],
      [[1], [1]],
      [[2], [2]],
      [[3], [3]],
      [[4], [4]],
    ]

    training = EvolveNet::Data.new(data)

    network = EvolveNet::Network.new
    network.add_layer(:input, 1, :none)
    network.add_layer(:output, 1, :none)
    network.fully_connect

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data, 100000)

    puts "guesses your number"
    (1..10).each do |idx|
      puts "#{idx} = #{network.run([idx])[0].round_even.to_i}"
    end

    puts "#{100} = #{network.run([100])[0].round_even.to_i}"
    puts "#{1000} = #{network.run([1000])[0].round_even.to_i}"
    puts "#{10000} = #{network.run([10000])[0].round_even.to_i}"
  end

  it "guesses your number multiplied by 2" do
    data = [
      [[0], [0]],
      [[1], [2]],
      [[2], [4]],
      [[3], [6]],
      [[4], [8]],
    ]

    training = EvolveNet::Data.new(data)

    network = EvolveNet::Network.new
    network.add_layer(:input, 1, :none)
    network.add_layer(:output, 1, :none)
    network.fully_connect

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data, 100000)

    puts "guesses your number multiplied by 2"
    (1..10).each do |idx|
      puts "#{idx} = #{network.run([idx])[0].round_even.to_i}"
    end

    puts "#{100} = #{network.run([100])[0].round_even.to_i}"
    puts "#{1000} = #{network.run([1000])[0].round_even.to_i}"
    puts "#{10000} = #{network.run([10000])[0].round_even.to_i}"
  end

  it "guesses your number multiplied by 2 plus 5" do
    data = [
      [[0], [5]],
      [[1], [7]],
      [[2], [9]],
      [[3], [11]],
      [[4], [13]],
    ]

    training = EvolveNet::Data.new(data)

    network = EvolveNet::Network.new
    network.add_layer(:input, 1, :none)
    network.add_layer(:output, 1, :none)
    network.fully_connect

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data, 100000)

    puts "guesses your number multiplied by 2 plus 5"
    (1..10).each do |idx|
      puts "#{idx} = #{network.run([idx])[0].round_even.to_i}"
    end

    puts "#{100} = #{network.run([100])[0].round_even.to_i}"
    puts "#{1000} = #{network.run([1000])[0].round_even.to_i}"
    puts "#{10000} = #{network.run([10000])[0].round_even.to_i}"
  end

  it "guesses your number squared" do
    input = Array(Array(Float64)).new
    output = Array(Array(Float64)).new
    (-10..10).each do |i|
      input << [i.to_f64]
      output << [(i**2).to_f64]
    end

    training = EvolveNet::Data.new(input, output)

    network = EvolveNet::Network.new
    network.add_layer(:input, 1, :none)
    network.add_layer(:output, 1, :none)
    network.fully_connect

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data, 10000)

    puts "guesses your number squared"
    (1..10).each do |idx|
      puts "#{idx} = #{network.run([idx])[0].round_even.to_i}"
    end

    puts "#{100} = #{network.run([100])[0].round_even.to_i}"
    puts "#{1000} = #{network.run([1000])[0].round_even.to_i}"
    puts "#{10000} = #{network.run([10000])[0].round_even.to_i}"
  end
end
