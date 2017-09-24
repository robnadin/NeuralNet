//
//  Storage.swift
//  Swift-AI
//
//  Created by Collin Hundley on 4/4/17.
//
//

import Foundation

// Utilities for persisting/retrieving a NeuralNet from disk.

extension NeuralNet: Codable {
    
    // -------------------
    // NOTE: Our storage protocol writes data to JSON file in plaintext,
    // rather than adopting a standard storage protocol like NSCoding.
    // This will allow Swift AI components to be written/read across platforms without compatibility issues.
    // -------------------
    
    // MARK: JSON keys
    
    enum CodingKeys: String, CodingKey {
        case layerNodeCounts
        case momentum
        case learningRate
        case batchSize
        case hiddenActivation
        case outputActivation
        case weights
    }
    
    /// Attempts to initialize a `NeuralNet` from a file stored at the given URL.
    public convenience init(url: URL) throws {
        // Read data
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(NeuralNet.self, from: data)
        
        // Recreate Structure object
        let structure = try Structure(nodes: decoded.layerNodeCounts,
                                      hiddenActivation: decoded.hiddenActivation,
                                      outputActivation: decoded.outputActivation,
                                      batchSize: decoded.batchSize,
                                      learningRate: decoded.learningRate,
                                      momentum: decoded.momentumFactor)
        
        try self.init(structure: structure, weights: decoded.allWeights())
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Read all required values from JSON
        let layerNodeCounts = try container.decode([Int].self, forKey: .layerNodeCounts)
        let learningRate = try container.decode(Float.self, forKey: .learningRate)
        let momentum = try container.decode(Float.self, forKey: .momentum)
        let batchSize = try container.decode(Int.self, forKey: .batchSize)
        let hiddenActivationStr = try container.decode(String.self, forKey: .hiddenActivation)
        let outputActivationStr = try container.decode(String.self, forKey: .outputActivation)
        let weights = try container.decode([[Float]].self, forKey: .weights)
        
        // Convert hidden activation function to enum
        var hiddenActivation: ActivationFunction.Hidden
        // Check for custom activation function
        if hiddenActivationStr == "custom" {
            // Note: Here we simply warn the user and set the activation to defualt (sigmoid)
            // The user should reset the activation to the original custom function manually
            print("NeuralNet warning: custom hidden layer activation function detected in stored network. Defaulting to sigmoid activation. It is your responsibility to reset the network's hidden layer activation to the original function, or it is unlikely to perform correctly.")
            hiddenActivation = ActivationFunction.Hidden.sigmoid
        } else {
            guard let function = ActivationFunction.Hidden.from(hiddenActivationStr) else {
                throw Error.initialization("Unrecognized hidden layer activation function in file: \(hiddenActivationStr)")
            }
            hiddenActivation = function
        }
        
        // Convert output activation function to enum
        var outputActivation: ActivationFunction.Output
        // Check for custom activation function
        if outputActivationStr == "custom" {
            // Note: Here we simply warn the user and set the activation to defualt (sigmoid)
            // The user should reset the activation to the original custom function manually
            print("NeuralNet warning: custom output activation function detected in stored network. Defaulting to sigmoid activation. It is your responsibility to reset the network's output activation to the original function, or it is unlikely to perform correctly.")
            outputActivation = ActivationFunction.Output.sigmoid
        } else {
            guard let function = ActivationFunction.Output.from(outputActivationStr) else {
                throw Error.initialization("Unrecognized output activation function in file: \(outputActivationStr)")
            }
            outputActivation = function
        }
        
        // Recreate Structure object
        let structure = try Structure(nodes: layerNodeCounts,
                                      hiddenActivation: hiddenActivation, outputActivation: outputActivation,
                                      batchSize: batchSize, learningRate: learningRate, momentum: momentum)
        
        // Initialize neural network
        try self.init(structure: structure, weights: weights)
    }
    
    /// Persists the `NeuralNet` to a file at the given URL.
    public func save(to url: URL) throws {
        // Serialize array into JSON data
        let data = try JSONEncoder().encode(self)
        
        // Write data to file
        try data.write(to: url)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(layerNodeCounts, forKey: .layerNodeCounts)
        try container.encode(momentumFactor, forKey: .momentum)
        try container.encode(learningRate, forKey: .learningRate)
        try container.encode(batchSize, forKey: .batchSize)
        try container.encode(hiddenActivation.stringValue(), forKey: .hiddenActivation)
        try container.encode(outputActivation.stringValue(), forKey: .outputActivation)
        try container.encode(allWeights(), forKey: .weights)
    }
    
}
