module EvolveNet
  class Organism
    property :networks, :rate
    @rate : Int32

    def initialize(network : Network, size : Int32 = 10)
      @networks = Array(Network).new(size) { network.clone.randomize }
      @rate = (size * 0.1).to_i
    end

    def evolve(data : Array(Array(Array(Number))))
      (0..1000).each do
        @networks.each do |network|
          network.evaluate(data)
        end
        @networks.sort! { |a, b| b.mse <=> a.mse }

        # kill bottom 10%
        @networks = @networks[..@rate]
        # clone top 10%
        @networks[0..@rate].each { |n| @networks << n.clone }

        @networks.each { |n| n.evolve }
      end
    end

    def evolved_network
      @networks.first
    end
  end
end
