# NeuralNet
This is the NeuralNet module for the Swift AI project. Full details on the project can be found in the [main repo](https://github.com/Swift-AI/Swift-AI).

The `NeuralNet` class contains a fully connected, 3-layer feed-forward artificial neural network. This neural net uses a standard backpropagation training algorithm, and is designed for flexibility and use in performance-critical applications.

## Importing

### Swift Package Manager
SPM makes it easy to import the package into your own project. Just add this line to `package.swift`:
```swift
.Package(url: "https://github.com/Swift-AI/NeuralNet.git", majorVersion: 0, minor: 1)
```

### Manually
Since iOS and Cocoa applications aren't supported by SPM yet, you may need to import the package manually. To do this, simply drag and drop the files from `Sources` into your project.

This isn't as elegant as using a package manager, but we anticipate SPM support for these platforms soon. For this reason we've decided not to use alternatives like CocoaPods.

## Initialization
`NeuralNet` relies on 2 helper classes for setting up the neural network: `Structure` and `Configuration`. As their names imply, these classes define the overall structure of the network and some basic settings for inference and training:

 - **Structure:** This one is fairly straightforward. You simply pass in the number of inputs, hidden nodes, and outputs for your neural network.
 
```swift
let structure = try NeuralNet.Structure(inputs: 784, hidden: 420, outputs: 10)
```

 - **Configuration:** These parameters are behavioral:
     - `activation`: An activation function to use during inference. Several defaults are provided; you may also provide a custom function. Note that custom functions must be differentiable, and you must also provide the derivative function (accepting a `y` value). If this is all new to you, start with `.sigmoid`.
     - `learningRate`: A learning rate to apply during backpropagation.
     - `momentum`: Another constant applied during backpropagation.

```swift
let config = try NeuralNet.Configuration(activation: .sigmoid, learningRate: 0.5, momentum: 0.3)
```

Once you've perfomed these steps, you're ready to create your `NeuralNet`:

```swift
let nn = try NeuralNet(structure: structure, config: config)
```

#### From Storage
A trained `NeuralNet` can also be persisted to disk for later use:

```swift
let url = URL(fileURLWithPath: "/path/to/file")
try nn.save(to: url)
```

And can likewise be initialized from a `URL`:

```swift
let nn = try NeuralNet(url: url)
```

## Inference
You perform inference using the `infer` method, which accepts an array of `Float` as input:

```swift
let input: [Float] = [1, 5.2, 46.7, 12.0] // ...
let output = try nn.infer(input)
```

This is the primary usage for `NeuralNet`. Note that `input.count` must always equal the number of inputs defined in your network's `Structure`, or an error will be thrown.

## Training
What good is a neural network that hasn't been trained? You have two options for training your net:

### Automatically
Your net comes with a `train` method that attempts to perform all training steps automatically. This method is recommended for simple applications and newcomers, but might be too limited for advanced users.

In order to train automatically you must first create a `Dataset`, which is a simple container for all training and validation data. It accepts 5 parameters:
 - `trainInputs`: A 2D `Float` array containing all sets of training inputs. Each set must be equal in size to your network's `inputs`.
 - `trainLabels`: A 2D `Float` array containing all labels corresponding to each input set. Each set must be equal in size to your network's `outputs`, and there must be an equal number of sets as `trainInputs`.
 - `validationInputs`: Same as `trainInputs`, but a unique set of data used for network validation.
 - `validationLabels`: Same as `trainLabels`, but a unique validation set corressponding to `validationInputs`.
 
Note: The validation data will NOT be used to train the network, but will be used to test the network's progress periodically. Once the desired error threshold on the validation data has been reached, the training will stop. Ideally, the validation sets should be randomly selected and representative of the entire search space.

### Manually

(Full documentation coming soon)

