# FeatureKit iOS SDK

FeatureKit is a precompiled iOS SDK distributed as an `XCFramework`.

This public repository contains package metadata, integration documentation, and the compiled SDK distribution. The private Swift implementation source code is not published here.

## Requirements

- iOS 15.0+
- Xcode with Swift 5.9+ support

## Installation

### Swift Package Manager

In Xcode:

1. Open **File > Add Package Dependencies...**
2. Enter:

   `https://github.com/NicolasNC/FeatureKit-iOS`

3. Add the `FeatureKit` product to your application target.

Then import the SDK:

```swift
import FeatureKit
```

### CocoaPods

If you are testing directly from this repository before the pod is published to CocoaPods Trunk, add:

```ruby
pod 'FeatureKit', :git => 'https://github.com/NicolasNC/FeatureKit-iOS.git', :branch => 'main'
```

Then run:

```bash
pod install
```

After `FeatureKit` is published to CocoaPods Trunk, customers can use:

```ruby
pod 'FeatureKit', '~> 1.0'
```

Open the generated `.xcworkspace` and import:

```swift
import FeatureKit
```

### Manual XCFramework

Download `FeatureKit.xcframework.zip`, unzip it, then drag `FeatureKit.xcframework` into the Xcode project. Add it to the application target under **Frameworks, Libraries, and Embedded Content**.

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

## Distribution and source visibility

FeatureKit is distributed as a precompiled `XCFramework`. Customers receive the public API surface and compiled binary required for integration. The private Swift implementation source is kept in the private development repository and is not included in this public repository.

As with any binary SDK, compiled binaries can still be inspected or reverse engineered to some extent; binary distribution prevents normal source access but is not equivalent to cryptographic source protection.

## Versioning

FeatureKit follows semantic versioning:

- Patch (`1.0.x`) — backward-compatible fixes
- Minor (`1.x.0`) — backward-compatible features
- Major (`x.0.0`) — potentially breaking API changes

## Support

For integration questions, API keys, endpoint configuration, and product support, use the support channel provided with your FeatureKit account.
