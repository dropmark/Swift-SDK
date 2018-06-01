Dropmark Swift SDK (beta)
=======================

[![Version](https://img.shields.io/cocoapods/v/DropmarkSDK.svg?style=flat)](https://cocoapods.org/pods/DropmarkSDK)
[![License](https://img.shields.io/cocoapods/l/DropmarkSDK.svg?style=flat)](https://cocoapods.org/pods/DropmarkSDK)
[![Platform](https://img.shields.io/cocoapods/p/DropmarkSDK.svg?style=flat)](https://cocoapods.org/pods/DropmarkSDK)
[![Twitter](https://img.shields.io/badge/twitter-%40oakstudios-blue.svg)](http://twitter.com/oakstudios)

## Introduction
`DropmarkSDK` provides the common model and network controllers for Dropmark's iOS, macOS, and tvOS products.

## Example

To run the example project:

1. Clone the repo
2. Run `pod install` from the `/example` directory
3. In the `/example` directory, copy the `keys-example.plist` file, rename the new file `keys.plist`, hten add your Dropmark token to the file. 

Be sure to open the examples using the .workspace file.

## Installation

Install the library in your app through [CocoaPods](http://cocoapods.org). Add the following line to your *Podfile*, then run `pod install`.

```ruby
pod 'DropmarkSDK', '~> 0.1'
```

Be sure to import the library when needed.

```swift
import DropmarkSDK
```

To include the library as a dependency in another CocoaPod, reference the following line in your *podspec*.

```ruby
s.dependency 'DropmarkSDK', '~> 0.1'
```

## Types

Dropmark supports the following item types:

1. Image
2. Video
3. Audio
4. Link
5. Text
6. Color
7. Stack
8. Other

Image, Video, Audio, and Other contain files, and are convertible from Apple UTIs. Link, Text, and Color types contain their data in a string. Stack items are special, and behave as a parent to other items.

## Migration

### Version 0.1

`DropmarkSDK` supports iOS 10.0, macOS 10.10, tvOS 11.0, Swift 4, and Xcode 9.0.

## Credits

Created by [Alex Givens](http://alexgivens.com) for [Oak](https://oak.is).

`DromparkSDK` relies on the following 3rd party libraries:

•  [`UTIKit`](https://github.com/cockscomb/UTIKit)
•  [`Alamofire`](https://github.com/Alamofire/Alamofire)
•  [`PromiseKit`](https://github.com/mxcl/PromiseKit)
•  [`KeychainSwift`](https://github.com/evgenyneu/keychain-swift)

## License

The MIT License (MIT)

Copyright (c) 2018 Oak, LLC [https://oak.is](https://oak.is)
