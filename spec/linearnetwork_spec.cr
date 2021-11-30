require "./spec_helper"

describe EvolveNet::LinearNetwork do
  it "guesses your number" do
    data = [
      [[0], [0]],
      [[1], [1]],
      [[2], [2]],
      [[3], [3]],
      [[4], [4]],
    ]

    training = EvolveNet::Data.new(data)

    network = EvolveNet::LinearNetwork.new
    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data)

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

    network = EvolveNet::LinearNetwork.new
    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data)

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

    network = EvolveNet::LinearNetwork.new
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
end
