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

- iOS 10.0+ / macOS 10.12+ / tvOS 11.0+
- Xcode 10.2+
- Swift 5.0+

## Migration Guides

- [DropmarkSDK 3.0 Migration Guide](https://github.com/dropmark/Swift-SDK/blob/master/Documentation/DropmarkSDK%203.0%20Migration%20Guide.md)
- [DropmarkSDK 2.0 Migration Guide](https://github.com/dropmark/Swift-SDK/blob/master/Documentation/DropmarkSDK%202.0%20Migration%20Guide.md)
- [DropmarkSDK 1.0 Migration Guide](https://github.com/dropmark/Swift-SDK/blob/master/Documentation/DropmarkSDK%201.0%20Migration%20Guide.md)

## Example

Included are demo projects for iOS, tvOS, and macOS. To run the example projects:

1. Clone the repo
2. Run `pod install` from the `/Example` directory
3. In the `/Example` directory, copy the `keys-example.plist` file, rename the new file `keys.plist`, then add your Dropmark token to the file.

Be sure to open the examples using the `DropmarkSDK.workspace` file.

## Installation

Install the library in your app through [**CocoaPods**](http://cocoapods.org). Add the following line to your *Podfile*, then run `pod install`.

```ruby
pod 'DropmarkSDK', '~> 3.0'
```

Be sure to import the library when needed.

```swift
import DropmarkSDK
```

## Security Disclosure

If you believe you have identified a security vulnerability with **DropmarkSDK** or the [**Dropmark API**](https://www.dropmark.com/api/topics/introduction/), you should report it as soon as possible via email to support@dropmark.com. Please do not post it to a public issue tracker.

## Credits

Created by [Oak](https://oak.is) for [Dropmark](https://www.dropmark.com).

**DropmarkSDK** relies on the following open source libraries:

- [`Alamofire`](https://github.com/Alamofire/Alamofire)
- [`PromiseKit`](https://github.com/mxcl/PromiseKit)
- [`CancellablePromiseKit`](https://github.com/johannesd/CancellablePromiseKit)
- [`UTIKit`](https://github.com/cockscomb/UTIKit)

## License

The MIT License (MIT)

Copyright (c) 2020 Oak, LLC [https://oak.is](https://oak.is)
