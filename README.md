<p align="center" >
    <img src="https://raw.githubusercontent.com/dropmark/Swift-SDK/master/DropmarkSwiftSDK.png" alt="Dropmark Swift SDK" title="Dropmark Swift SDK" width="506" height="192"
</p>

[![Version](https://img.shields.io/cocoapods/v/DropmarkSDK.svg?style=flat)](https://cocoapods.org/pods/DropmarkSDK)
[![License](https://img.shields.io/cocoapods/l/DropmarkSDK.svg?style=flat)](https://cocoapods.org/pods/DropmarkSDK)
[![Platform](https://img.shields.io/cocoapods/p/DropmarkSDK.svg?style=flat)](https://cocoapods.org/pods/DropmarkSDK)
[![Twitter](https://img.shields.io/badge/twitter-%40oakstudios-blue.svg)](http://twitter.com/oakstudios)

**DropmarkSDK** is a Swift interface for the [**Dropmark API**](https://www.dropmark.com/api/topics/introduction/). 

## Features

- [x] Full networking suite for API endpoints, built around [**Alamofire**](https://github.com/Alamofire/Alamofire)
- [x] Model classes for all API objects
- [x] Serializers to translate response data into model objects
- [x] Chainable promises, built around [**PromiseKit**](https://github.com/mxcl/PromiseKit)
- [x] Authentication and secure credential storage
- [x] Pagination utilities, with utilities for infinite scrolling in list views
- [x] Example for iOS
- [x] Example for tvOS
- [x] Example for macOS
- [ ] Comprehensive Unit and Integration Test Coverage
- [x] [Complete Documentation](https://dropmark.github.io/Swift-SDK)

## Requirements

- iOS 10.0+ / macOS 10.10+ / tvOS 11.0+
- Xcode 10.0+
- Swift 4.2+

## Example

Included are demo projects for iOS, tvOS, and macOS. To run the example projects:

1. Clone the repo
2. Run `pod install` from the `/Example` directory
3. In the `/Example` directory, copy the `keys-example.plist` file, rename the new file `keys.plist`, then add your Dropmark token to the file. 

Be sure to open the examples using the `DropmarkSDK.workspace` file.

## Installation

Install the library in your app through [**CocoaPods**](http://cocoapods.org). Add the following line to your *Podfile*, then run `pod install`.

```ruby
pod 'DropmarkSDK', '~> 1.5'
```

Be sure to import the library when needed.

```swift
import DropmarkSDK
```

## Migration

### Version 1.4.0
For `DKItem` make `reactionsTotalCount`, `tags`, `reactions`, `comments`, and `user` variables non-optional. For `DKCollection` make `itemsTotalCount`, `usersTotalCount`, and `user` variables non-optional.

### Version 1.3.0
Further support for Swift 4.2, particularly with `KeychainSwift`

### Version 1.2.0
Update to Xcode 10 and Swift 4.2 compatibility

### Version 1.1.0
Extensions in `DataRequest+PromiseKit` make use of `CancellablePromiseKit` now. `DKPaginationGenerator` also reflects cancellability.

### Version 1.0.0
All errors are now consolidated as `DKError`.  Search results are serialized by the `DKResponseListAny` struct.

### Version 0.3.0
Large modifications to `DKRouter` enum, and associated Promise generation.

### Version 0.2.0
A new naming scheme was introduced for object classes, prefixing each class name with "DK".

### Version 0.1.1

**DropmarkSDK** supports iOS 10.0, macOS 10.10, tvOS 11.0, Swift 4, and Xcode 9.0.

## Security Disclosure

If you believe you have identified a security vulnerability with **DropmarkSDK** or the [**Dropmark API**](https://www.dropmark.com/api/topics/introduction/), you should report it as soon as possible via email to support@dropmark.com. Please do not post it to a public issue tracker.

## Credits

Created by [Oak](https://oak.is) for [Dropmark](https://www.dropmark.com).

**DropmarkSDK** relies on the following open source libraries:

- [`KeychainSwift`](https://github.com/evgenyneu/keychain-swift)
- [`Alamofire`](https://github.com/Alamofire/Alamofire)
- [`PromiseKit`](https://github.com/mxcl/PromiseKit)
- [`CancellablePromiseKit`](https://github.com/johannesd/CancellablePromiseKit)
- [`UTIKit`](https://github.com/cockscomb/UTIKit)

## License

The MIT License (MIT)

Copyright (c) 2018 Oak, LLC [https://oak.is](https://oak.is)
