module EvolveNet
  class Organism
    property :networks
    @pct : Int32

    def initialize(network : Network, size : Int32 = 10, pct : Float32 = 0.2)
      @networks = Array(Network).new(size) { network.clone.randomize }
      @pct = (size * pct).to_i
    end

    def evolve(data : Array(Array(Array(Number))),
               generations : Int32 = 10000)
      mutation_rate = 1_f64
      average_error = 1_f64
      (1..generations).each do |gen|
        @networks.each do |network|
          network.evaluate(data)
        end
        @networks.sort! { |a, b| a.error <=> b.error }

        # kill bottom 10%
        @networks = @networks[..@pct]

        # clone top 10%
        @networks[0..@pct].each { |n| @networks << n.clone }

        # mutate
        @networks.each { |n| n.mutate(mutation_rate) }

        # update mutation rate based on error rate
        average_error = @networks.sum { |n| n.error } / @networks.size
        mutation_rate = average_error * 2

        # break if below 0.001
        if average_error < 0.001
          puts "generation: #{gen} average error: #{average_error.round(6)} below 0.001. breaking."
          break
        end

        if gen % 100 == 0
          puts "generation: #{gen} average error: #{average_error.round(6)}"
        end
      end

      @networks.sort! { |a, b| a.error <=> b.error }
      @networks.first
    end
  end
end
