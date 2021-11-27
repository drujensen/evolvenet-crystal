module EvolveNet
  class Organism
    property :networks
    @one_forth : Int32 = 1
    @two_forth : Int32 = 1
    @three_forth : Int32 = 1

    def initialize(network : Network, size : Int32 = 10)
      raise "size needs to be greater than 4" if size < 4
      @networks = Array(Network).new(size) { network.clone.randomize }
      @one_forth = (size * 0.25).to_i
      @two_forth = (@one_forth * 2).to_i
      @three_forth = (@one_forth * 3).to_i
    end

    def evolve(data : Array(Array(Array(Number))),
               generations : Int32 = 500000,
               error_threshold : Float64 = 0.00000001,
               log_each : Int32 = 1000)
      (0...generations).each do |gen|
        @networks.each { |n| n.evaluate(data) }
        @networks.sort! { |a, b| a.error <=> b.error }

        error : Float64 = @networks[0].error
        if error <= error_threshold
          puts "generation: #{gen} error: #{error.round(6)}. below threshold. breaking."
          break
        elsif gen % log_each == 0
          puts "generation: #{gen} error: #{error.round(6)}"
        end

        # randomize 3rd quarter
        @networks[@two_forth...@three_forth].each { |n| n.randomize }

        # kill bottom quarter
        @networks = @networks[..@one_forth]

        # clone top quarter
        @networks[0..@one_forth].each { |n| @networks << n.clone }

        # mutate all but the best network
        (1...@networks.size).each { |n| @networks[n].mutate }
      end

      @networks.sort! { |a, b| a.error <=> b.error }
      @networks.first
    end
  end
end
