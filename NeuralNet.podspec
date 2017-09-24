Pod::Spec.new do |s|
  s.name             = 'NeuralNet'
  s.version          = '0.3.0'
  s.summary          = 'An artificial neural network written in Swift'
  s.description      = <<-DESC
  This is the NeuralNet module for the Swift AI project. Full details on the project can be found in the [main repo](https://github.com/Swift-AI/Swift-AI).

  The NeuralNet class contains a fully connected, feed-forward artificial neural network. This neural net offers support for deep learning, and is designed for flexibility and use in performance-critical applications.
                       DESC

  s.homepage         = 'https://github.com/Swift-AI/NeuralNet'
  s.screenshots      = 'https://github.com/Swift-AI/Swift-AI/blob/master/SiteAssets/banner.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Swift-AI'
  s.source           = { :git => 'https://github.com/robnadin/NeuralNet.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.macos.deployment_target = '10.10'

  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation', 'Accelerate'
end
