# evolvenet

This project is a testbed to attempt using Evolutionary Strategies for machine learning.  The examples are fairly simple networks but the solution seems to work quite well and removes all the complexity around back propogation and gradient descent.

The network uses a simple evolutionary process:
1. create a sample network
2. generate a population and randomize the weights and biases
3. for several generations:
  - evaluate the error rate and sort
  - kill the bottom 10%
  - clone the top 10%
  - mutate the population
4. return the top evolved network

## Installation

add to your shards.yml
```

```

## Usage


## Development


## Contributing

1. Fork it (<https://github.com/drujensen/evolvenet/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dru Jensen](https://github.com/drujensen) - creator and maintainer
