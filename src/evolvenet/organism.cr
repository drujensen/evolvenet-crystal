module EvolveNet
  class Organism
    property :networks
    @pct : Int32

    def initialize(network : Network, size : Int32 = 100, pct : Int32 = 20)
      @networks = Array(Network).new(size) { network.clone.randomize }
      @pct = (size * (pct/100)).to_i
    end

    def evolve(data : Array(Array(Array(Number))),
               generations : Int32 = 10000,
               mutation_rate : Float64 = 0.01)
      (1..generations).each do
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
      end
    end

    def evolved_network
      @networks.sort! { |a, b| a.error <=> b.error }
      @networks.first
    end
  end
end
