describe EvolveNet::QuadradicNetwork do
  it "guesses your number squared" do
    input = Array(Array(Float64)).new
    output = Array(Array(Float64)).new
    (-10..10).each do |i|
      input << [i.to_f64]
      output << [(i**2).to_f64]
    end

    training = EvolveNet::Data.new(input, output)

    network = EvolveNet::QuadradicNetwork.new
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
