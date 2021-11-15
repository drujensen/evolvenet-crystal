module EvolveNet
  class Organism
    property :networks, :rate
    @rate : Int32

    def initialize(network : Network, size : Int32 = 10)
      @networks = Array(Network).new(size) { network.clone.randomize }
      @ten_pct = (size * 0.1).to_i
    end

    def evolve(data : Array(Array(Array(Number))),
               generations : Int32,
               mutation_rate : Float64 = 0.01)
      (1..generations).each do
        @networks.each do |network|
          network.evaluate(data)
        end
        @networks.sort! { |a, b| a.mse <=> b.mse }

        # kill bottom 10%
        @networks = @networks[..@ten_pct]

        # clone top 10%
        @networks[0..@ten_pct].each { |n| @networks << n.clone }

        # mutate
        @networks.each { |n| n.mutate(mutation_rate) }
      end
    end

    def evolved_network
      @networks.sort! { |a, b| a.mse <=> b.mse }
      @networks.first
    end
  end
end
