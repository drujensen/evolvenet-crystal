require "./spec_helper"

describe EvolveNet::NeuralNetwork do
  it "works with cats and dogs" do
    network = EvolveNet::NeuralNetwork.new
    network.add_layer(:input, 48, 48, 3)
    network.add_layer(:conv, 46, 46, 6)
    network.add_layer(:output, 2)
    network.fully_connect

    outcome = {
      "cat" => [1.0, 0.0],
      "dog" => [0.0, 1.0],
    }

    input = Array(Array(Float64)).new
    output = Array(Array(Float64)).new

    ["cat", "dog"].each do |type|
      files = Dir["/Users/drujensen/workspace/crystal/deeplearning/cats_dogs/train/#{type}.*.png"]
      limit = 0
      files.each do |file_name|
        limit += 1
        break if limit > 25

        image = Image.new(file_name)
        pixels = Array(Float64).new
        3.times do |c|
          image.height.times do |y|
            image.width.times do |x|
              pixels << image.data(x, y)[c]
            end
          end
        end

        input << pixels
        output << outcome[type]
      end
    end

    training = EvolveNet::Data.new(input, output)

    organism = EvolveNet::Organism.new(network)
    network = organism.evolve(training.raw_data, 5000, 0.02, 1)

    input = Array(Array(Float64)).new
    output = Array(Array(Float64)).new

    ["cat", "dog"].each do |type|
      files = Dir["/Users/drujensen/workspace/crystal/deeplearning/cats_dogs/test/#{type}.*.png"]
      limit = 0
      files.each do |file_name|
        limit += 1
        break if limit > 100

        image = Image.new(file_name)
        pixels = Array(Float64).new
        3.times do |c|
          image.height.times do |y|
            image.width.times do |x|
              pixels << image.data(x, y)[c]
            end
          end
        end

        input << pixels
        output << outcome[type]
      end
    end

    tn = tp = fn = fp = 0

    input.each_with_index do |test, idx|
      results = network.run(test)
      if results[0] < 0.5
        if output[idx][0] == 0.0
          tn += 1
        else
          fn += 1
        end
      else
        if output[idx][0] == 0.0
          fp += 1
        else
          tp += 1
        end
      end
    end

    puts "Training size: #{input.size}"
    puts "----------------------"
    puts "TN: #{tn} | FP: #{fp}"
    puts "----------------------"
    puts "FN: #{fn} | TP: #{tp}"
    puts "----------------------"
    puts "Accuracy: #{(tn + tp) / input.size.to_f}"
  end
end
