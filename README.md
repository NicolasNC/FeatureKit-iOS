# FeatureKit iOS SDK

FeatureKit is a binary iOS SDK distributed through Swift Package Manager.

The public repository contains the SwiftPM manifest and compiled XCFramework distribution. The SDK implementation source code is not included in this repository.

## Requirements

- iOS 15.0+
- Swift Package Manager
- Xcode with Swift 5.9+ support

## Installation

In Xcode:

1. Open **File > Add Package Dependencies...**
2. Enter:

   `https://github.com/NicolasNC/FeatureKit-iOS`

3. Add the `FeatureKit` product to your application target.

Then import the SDK:

```swift
import FeatureKit
```

## Basic configuration

Create a configuration with the API key issued by FeatureKit and your app's bundle identifier:

```swift
import FeatureKit

let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY",
    bundleID: Bundle.main.bundleIdentifier ?? ""
)

await FeatureKit.configure(configuration)
```

If your account uses a custom API endpoint, pass the endpoint explicitly with the `baseURL` parameter supplied for your FeatureKit environment.

## Initialize an end-user identity

After configuration, initialize the SDK identity when appropriate for your application flow:

```swift
let identity = try await FeatureKitClient.shared.initialize()
```

For a signed-in user, you can associate your own user identifier:

```swift
let identity = try await FeatureKitClient.shared.identify(
    userID: "YOUR_USER_ID",
    name: "Optional Name",
    email: "optional@example.com"
)
```

## Distribution

FeatureKit is distributed as a precompiled `XCFramework`. Customers receive the public API surface required for integration, but the private Swift implementation source is not published here.

## Versioning

FeatureKit follows semantic versioning:

- Patch (`1.0.x`) — backward-compatible fixes
- Minor (`1.x.0`) — backward-compatible features
- Major (`x.0.0`) — potentially breaking API changes

## Support

For integration questions, API keys, endpoint configuration, and product support, use the support channel provided with your FeatureKit account.
