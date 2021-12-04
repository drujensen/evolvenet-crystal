# evolvenet

This project is a testbed to attempt using an evolutionary strategy for machine learning.  The examples are fairly simple networks but the solution seems to work quite well and removes all the complexity around back propogation and gradient descent. This also leverages the CPU cores by spawning and distributing the network evaluation.  In theory, this could be distributed horizontally on a cluster of servers and use a federated approach.

The network uses a simple evolutionary process:
1. create a sample network
2. generate a population and randomize the weights and biases
3. for several generations:
  - evaluate the error rate and sort
  - destroy the bottom 25%
  - clone the top 25%
  - punctuate the top 20%
  - keep the best model
  - randomize the worst
  - mutate the population
4. return the top evolved network

## Installation

add to your shards.yml
```yaml
dependencies:
  evolvenet:
    github: drujensen/evolvenet
```

## Usage

xor example
```
data = [
  [[0, 0], [0]],
  [[0, 1], [1]],
  [[1, 0], [1]],
  [[1, 1], [0]],
]

network = EvolveNet::Network.new
network.add_layer(:input, 2)
network.add_layer(:hidden, 2)
network.add_layer(:output, 1)
network.fully_connect

organism = EvolveNet::Organism.new(network)
network = organism.evolve(data)

puts network.run([0, 0])
```

See the specs for other examples.

## Development

To run specs with threads:
```
CRYSTAL_WORKERS=16 crystal spec --release -Dpreview_mt
```

## Contributing

1. Fork it (<https://github.com/drujensen/evolvenet/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dru Jensen](https://github.com/drujensen) - creator and maintainer
