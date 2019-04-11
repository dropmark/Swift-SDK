# Be sure to run `pod lib lint DropmarkSDK.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
    
  s.name             = 'DropmarkSDK'
  s.version          = '2.0.2'
  s.summary          = 'Network and model controllers for Dropmark, written in Swift.'

  s.homepage         = 'https://github.com/dropmark/Swift-SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Givens' => 'alex@oakmade.com' }
  s.source           = { :git => 'https://github.com/dropmark/Swift-SDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oakstudios'
  
  s.swift_version           = '5.0'
  
  s.ios.deployment_target   = '10.0'
  s.osx.deployment_target   = '10.11'
  s.tvos.deployment_target  = '11.0'

  s.source_files = 'Source/**/*.swift'
  
  s.dependency 'Alamofire', '~> 4.8'
  s.dependency 'PromiseKit', '~> 6.5'
  s.dependency 'KeychainSwift', '~> 13.0'
  
end
