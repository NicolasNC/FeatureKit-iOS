# FeatureKit iOS SDK

[简体中文](README.zh-CN.md)

FeatureKit helps iOS apps collect product feedback, feature requests, votes, and user ideas through a ready-to-use in-app feedback experience.

- Website: https://feedback.nicolaigame.top
- iOS: 15.0+
- Swift: 5.9+
- UI: SwiftUI and UIKit
- Package managers: Swift Package Manager and CocoaPods

## Get access and an API key

FeatureKit is currently available by invitation.

Visit https://feedback.nicolaigame.top to request access. If your account has not been activated yet, leave your email through the website so we can contact you when access is available.

After your account is activated:

1. Sign in to the FeatureKit dashboard.
2. Create a project for your iOS app.
3. Enter the app's Bundle ID, for example `com.company.myapp`.
4. Create an API key for the project.
5. Use that API key when configuring the SDK.

Each project API key is bound to the Bundle ID configured for that project. FeatureKit automatically reads the host app's Bundle ID and validates it against the project on the server.

## Installation

### Swift Package Manager

In Xcode:

1. Open **File > Add Package Dependencies...**
2. Enter:

   `https://github.com/NicolasNC/FeatureKit-iOS`

3. Select the version you want to use.
4. Add the `FeatureKit` product to your application target.

Then:

```swift
import FeatureKit
```

### CocoaPods

Before FeatureKit is published to CocoaPods Trunk, install it directly from GitHub:

```ruby
platform :ios, '15.0'

target 'YourApp' do
  pod 'FeatureKit', :git => 'https://github.com/NicolasNC/FeatureKit-iOS.git', :branch => 'main'
end
```

Then run:

```bash
pod install
```

After the pod is available on CocoaPods Trunk, use:

```ruby
pod 'FeatureKit', '~> 1.0'
```

Open the generated `.xcworkspace` and import `FeatureKit`.

### Manual XCFramework

1. Download `FeatureKit.xcframework.zip` from the corresponding FeatureKit release.
2. Unzip it.
3. Drag `FeatureKit.xcframework` into your Xcode project.
4. Add it to your application target under **Frameworks, Libraries, and Embedded Content**.
5. Import the SDK:

```swift
import FeatureKit
```

## Configure FeatureKit

FeatureKit requires a project API key.

```swift
import FeatureKit

let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY",
    baseURL: URL(string: "https://feedback.nicolaigame.top/api/v1")!
)

await FeatureKit.configure(configuration)
```

The SDK automatically reads the host application's Bundle ID from `Bundle.main.bundleIdentifier`. You do not pass the Bundle ID manually.

A good place to configure FeatureKit is during application startup, before presenting FeatureKit UI.

## Initialize the user identity

FeatureKit supports both anonymous and signed-in users.

### Anonymous users

```swift
let identity = try await FeatureKitClient.shared.initialize()
```

FeatureKit maintains a stable installation identity for the app installation.

### Signed-in users

If your app already has a logged-in user, associate your own stable user ID:

```swift
let identity = try await FeatureKitClient.shared.identify(
    userID: "YOUR_USER_ID",
    name: "Optional Name",
    email: "optional@example.com"
)
```

Use a stable internal user identifier rather than a temporary session ID.

### Sign out / reset identity

When the user signs out and your app should return to an anonymous FeatureKit identity:

```swift
let identity = try await FeatureKitClient.shared.resetIdentity()
```

Call `initialize()` or `identify(...)` before `resetIdentity()`.

## Present the FeatureKit feedback experience

`FeatureKitView` provides the complete feedback experience, including:

- feedback and feature-request list
- feedback detail page
- product status display
- vote / unvote actions
- submit-feedback flow
- optional email field
- official response display
- loading, empty, error, and success states

### SwiftUI

Present FeatureKit directly from SwiftUI:

```swift
import FeatureKit
import SwiftUI

struct SettingsView: View {
    @State private var showsFeatureKit = false

    var body: some View {
        Button("Feedback & Feature Requests") {
            showsFeatureKit = true
        }
        .sheet(isPresented: $showsFeatureKit) {
            FeatureKitView()
        }
    }
}
```

You can also provide an explicit close action:

```swift
FeatureKitView(
    onClose: {
        // Dismiss your container if needed.
    }
)
```

### UIKit

FeatureKit includes a UIKit bridge:

```swift
import FeatureKit

let viewController = FeatureKitView.makeViewController()
let navigationController = UINavigationController(
    rootViewController: viewController
)

present(navigationController, animated: true)
```

You can also present the returned view controller directly as a sheet or full-screen controller according to your app's navigation structure.

## Customize the UI

FeatureKit includes a default theme and copy, and supports client-side customization.

### Theme

```swift
import FeatureKit
import SwiftUI

let theme = FeatureKitTheme(
    accent: .blue,
    success: .green,
    warning: .orange,
    info: .blue,
    error: .red
)

let view = FeatureKitView(theme: theme)
```

### Text and labels

```swift
let copy = FeatureKitCopy(
    title: "Ideas",
    emptyTitle: "No ideas yet",
    emptyMessage: "Share the first idea with us.",
    submitTitle: "Share an idea",
    submitButton: "Submit",
    cancelButton: "Close",
    feedbackTitle: "Feedback",
    officialResponseTitle: "Team response",
    successTitle: "Thank you",
    successMessage: "Your feedback has been submitted."
)

let view = FeatureKitView(copy: copy)
```

### Email field

To hide the email field in the submit screen:

```swift
FeatureKitView(showsEmailField: false)
```

The final visibility may also be controlled by the FeatureKit project configuration from the dashboard.

## Typical integration flow

```text
Create FeatureKit project
        ↓
Configure Bundle ID
        ↓
Create API key
        ↓
Install FeatureKit SDK
        ↓
FeatureKit.configure(...)
        ↓
initialize() or identify(...)
        ↓
Present FeatureKitView
        ↓
Users submit feedback / vote
        ↓
Review and manage feedback in FeatureKit dashboard
```

## Bundle ID authorization

A project API key is associated with the Bundle ID configured for that project.

At runtime FeatureKit automatically detects the host app's Bundle ID and sends it with SDK requests. The FeatureKit service validates the detected Bundle ID against the project associated with the API key.

If your production, staging, beta, or white-label apps use different Bundle IDs, create separate FeatureKit projects / API keys unless your FeatureKit account has been configured otherwise.

## Error handling

SDK calls use Swift errors and can be handled with normal `do/catch` blocks:

```swift
do {
    let identity = try await FeatureKitClient.shared.initialize()
    print(identity)
} catch {
    print("FeatureKit error: \(error)")
}
```

For production apps, avoid blocking your main app experience if FeatureKit is temporarily unavailable. Feedback functionality can generally be treated as an independent feature.

## Versioning

FeatureKit follows semantic versioning:

- Patch (`1.0.x`) — backward-compatible fixes
- Minor (`1.x.0`) — backward-compatible features
- Major (`x.0.0`) — potentially breaking API changes

For production apps, prefer a versioned dependency rather than tracking `main` once stable releases are available.

## Support and access

FeatureKit is currently invitation-only.

Visit https://feedback.nicolaigame.top to request access, leave your email, create projects after activation, and obtain project API keys.

For integration questions or account support, use the contact/support options provided on the FeatureKit website or dashboard.
