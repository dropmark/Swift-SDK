# DropmarkSDK 3.0 Migration Guide

## New Requirements
macOS 10.12+ is now required

## Credential storage
`DKKeychain` and `DKSession` now only utilize a single `user` variable for network authorization. Instead of the previous `userToken` variable for these classes, instead rely on the `user.token` var.
