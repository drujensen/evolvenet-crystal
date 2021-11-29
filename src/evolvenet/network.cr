module EvolveNet
  abstract class Network
    abstract def clone
    abstract def randomize
    abstract def mutate
    abstract def punctuate(pos : Int32)
    abstract def evaluate(data : Array(Array(Array(Number))))
    abstract def run(data : Array(Number))
    abstract def error : Float64
  end
end
