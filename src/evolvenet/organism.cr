module EvolveNet
  class Organism
    property :networks
    @ten_pct : Int32

    def initialize(network : Network, size : Int32 = 10, pct : Int32 = 10)
      @networks = Array(Network).new(size) { network.clone.randomize }
      @ten_pct = (size * (pct/100)).to_i
    end

    def evolve(data : Array(Array(Array(Number))),
               generations : Int32,
               mutation_rate : Float64 = 0.01)
      (1..generations).each do
        @networks.each do |network|
          network.evaluate(data)
        end
        @networks.sort! { |a, b| a.error <=> b.error }

        # kill bottom 10%
        @networks = @networks[..@ten_pct]

        # clone top 10%
        @networks[0..@ten_pct].each { |n| @networks << n.clone }

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
