# FeatureKit iOS SDK

[简体中文](README.zh-CN.md)

FeatureKit is a precompiled iOS SDK distributed as an `XCFramework`.

This public repository contains package metadata, integration documentation, and the compiled SDK distribution. The private Swift implementation source code is not published here.

## Requirements

- iOS 15.0+
- Xcode with Swift 5.9+ support

## Installation

### Swift Package Manager

In Xcode:

1. Open **File > Add Package Dependencies...**
2. Enter `https://github.com/NicolasNC/FeatureKit-iOS`
3. Add the `FeatureKit` product to your application target.

Then import the SDK:

```swift
import FeatureKit
```

### CocoaPods

Before the pod is published to CocoaPods Trunk, you can integrate from this repository:

```ruby
pod 'FeatureKit', :git => 'https://github.com/NicolasNC/FeatureKit-iOS.git', :branch => 'main'
```

After publication to CocoaPods Trunk:

```ruby
pod 'FeatureKit', '~> 1.0'
```

Then run:

```bash
pod install
```

Open the generated `.xcworkspace` and import `FeatureKit`.

### Manual XCFramework

Download `FeatureKit.xcframework.zip`, unzip it, then add `FeatureKit.xcframework` to your Xcode project and application target.

## Basic configuration

FeatureKit only requires your project API key. The SDK automatically reads the host application's Bundle ID from `Bundle.main.bundleIdentifier`; callers do not provide or override the Bundle ID through the public configuration API.

```swift
import FeatureKit

let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY"
)

await FeatureKit.configure(configuration)
```

If your FeatureKit environment uses a custom API endpoint, pass the supplied `baseURL` explicitly:

```swift
let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY",
    baseURL: URL(string: "https://your-featurekit-endpoint.example/api/v1")!
)
```

### Bundle ID authorization

Each FeatureKit project API key is associated with the Bundle ID configured for that project. The SDK sends the host app's detected Bundle ID to the FeatureKit service, and the service rejects requests when the Bundle ID does not match the project bound to that API key.

This prevents accidental reuse of one project key across unrelated iOS applications. If you have separate production, staging, or white-label applications with different Bundle IDs, configure them as separate FeatureKit projects/keys unless your account explicitly supports another arrangement.

## Initialize an end-user identity

After configuration, initialize the SDK identity when appropriate for your application flow:

```swift
let identity = try await FeatureKitClient.shared.initialize()
```

For a signed-in user, associate your own stable user identifier:

```swift
let identity = try await FeatureKitClient.shared.identify(
    userID: "YOUR_USER_ID",
    name: "Optional Name",
    email: "optional@example.com"
)
```

## Distribution and source visibility

FeatureKit is distributed as a precompiled `XCFramework`. Customers receive the public API surface and compiled binary required for integration. The private Swift implementation source is kept in the private development repository and is not included here.

As with any client-side binary SDK, a determined party can still inspect or reverse engineer compiled code. Secrets and security-sensitive authorization remain server-side.

## Versioning

FeatureKit follows semantic versioning:

- Patch (`1.0.x`) — backward-compatible fixes
- Minor (`1.x.0`) — backward-compatible features
- Major (`x.0.0`) — potentially breaking API changes

## Support

For integration questions, API keys, endpoint configuration, and product support, use the support channel provided with your FeatureKit account.
