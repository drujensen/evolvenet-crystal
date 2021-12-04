module EvolveNet
  class Organism
    property :networks
    @one_forth : Int32 = 1
    @two_forth : Int32 = 1
    @three_forth : Int32 = 1

    def initialize(network : Network, size : Int32 = 16)
      raise "size needs to be greater than 16" if size < 16
      @networks = Array(Network).new(size) { network.clone.randomize }
      @one_forth = (size * 0.25).to_i
      @two_forth = (@one_forth * 2).to_i
      @three_forth = (@one_forth * 3).to_i
    end

    def evolve(data : Array(Array(Array(Number))),
               generations : Int32 = 10000,
               error_threshold : Float64 = 0.0,
               log_each : Int32 = 1000)
      channel = Channel(Float64).new

      generations.times do |gen|
        @networks.each do |n|
          spawn do
            n.evaluate(data)
            channel.send(n.error)
          end
        end
        @networks.size.times { channel.receive }
        @networks.sort! { |a, b| a.error <=> b.error }

        error : Float64 = @networks[0].error
        if error <= error_threshold
          puts "generation: #{gen} error: #{error}. below threshold. breaking."
          break
        elsif gen % log_each == 0
          puts "generation: #{gen} error: #{error}"
        end

        # randomize 3rd quarter
        @networks[@two_forth...@three_forth].each { |n| n.randomize }

        # kill bottom quarter
        @networks = @networks[..@one_forth]

        # clone top quarter
        @networks[0..@one_forth].each { |n| @networks << n.clone }

        # punctuate all but top in order
        @networks[1..3].each_with_index do |n, i|
          n.punctuate(i - 1)
        end

        # mutate all but the best and punctuated networks
        (4...@networks.size).each { |n| @networks[n].mutate }
      end

      @networks.sort! { |a, b| a.error <=> b.error }
      @networks.first
    end
  end
end
