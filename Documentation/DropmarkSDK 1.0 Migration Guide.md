# DropmarkSDK 1.0 Migration Guide

## Version 1.5.0
`DKSession` was added to store a user object and token separately, so object updates are compartmentalized.

## Version 1.4.0
For `DKItem` make `reactionsTotalCount`, `tags`, `reactions`, `comments`, and `user` variables non-optional. For `DKCollection` make `itemsTotalCount`, `usersTotalCount`, and `user` variables non-optional.

## Version 1.3.0
Further support for Swift 4.2, particularly with `KeychainSwift`

## Version 1.2.0
Update to Xcode 10 and Swift 4.2 compatibility

## Version 1.1.0
Extensions in `DataRequest+PromiseKit` make use of `CancellablePromiseKit` now. `DKPaginationGenerator` also reflects cancellability.

## Version 1.0.0
All errors are now consolidated as `DKError`.  Search results are serialized by the `DKResponseListAny` struct.
