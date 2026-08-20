# FeatureKit iOS SDK

[English](README.md)

FeatureKit 帮助 iOS 应用快速接入用户反馈、功能建议、投票和产品需求收集能力，并提供可直接展示的完整反馈 UI。

- 官网：https://feedback.nicolaigame.top
- iOS：15.0+
- Swift：5.9+
- UI：SwiftUI / UIKit
- 集成方式：Swift Package Manager / CocoaPods / 手动 XCFramework

## 申请使用与获取 API Key

FeatureKit 目前处于邀请制阶段。

请访问 https://feedback.nicolaigame.top 申请使用。如果账号尚未开通，可以在官网留下邮箱，我们会在开放名额或完成邀请后联系你。

账号开通后：

1. 登录 FeatureKit Dashboard。
2. 为你的 iOS App 创建一个 Project。
3. 填写 App 的 Bundle ID，例如 `com.company.myapp`。
4. 为该 Project 创建 API Key。
5. 在 App 中使用该 API Key 初始化 FeatureKit SDK。

每个 Project API Key 会与该 Project 配置的 Bundle ID 对应。SDK 会自动获取当前宿主 App 的 Bundle ID，并由 FeatureKit 服务端进行校验。

## 集成方式

### Swift Package Manager

在 Xcode 中：

1. 打开 **File > Add Package Dependencies...**
2. 输入：

   `https://github.com/NicolasNC/FeatureKit-iOS`

3. 选择需要使用的版本。
4. 将 `FeatureKit` Product 添加到你的 App Target。

然后：

```swift
import FeatureKit
```

### CocoaPods

在 FeatureKit 正式发布到 CocoaPods Trunk 前，可以直接从 GitHub 集成：

```ruby
platform :ios, '15.0'

target 'YourApp' do
  pod 'FeatureKit', :git => 'https://github.com/NicolasNC/FeatureKit-iOS.git', :branch => 'main'
end
```

然后执行：

```bash
pod install
```

FeatureKit 发布到 CocoaPods Trunk 后，可以使用：

```ruby
pod 'FeatureKit', '~> 1.0'
```

打开生成的 `.xcworkspace` 后，在代码中：

```swift
import FeatureKit
```

### 手动集成 XCFramework

1. 从对应版本的 FeatureKit Release 下载 `FeatureKit.xcframework.zip`。
2. 解压得到 `FeatureKit.xcframework`。
3. 将其拖入 Xcode 工程。
4. 在 App Target 的 **Frameworks, Libraries, and Embedded Content** 中添加。
5. 在代码中：

```swift
import FeatureKit
```

## 初始化 FeatureKit

FeatureKit 需要一个 Project API Key。

```swift
import FeatureKit

let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY",
    baseURL: URL(string: "https://feedback.nicolaigame.top/api/v1")!
)

await FeatureKit.configure(configuration)
```

SDK 会通过 `Bundle.main.bundleIdentifier` 自动获取当前宿主 App 的 Bundle ID，集成方不需要手动传入 Bundle ID。

建议在 App 启动流程中完成 FeatureKit 配置，并在展示 FeatureKit UI 之前完成初始化。

## 用户身份初始化

FeatureKit 支持匿名用户，也支持和你自己的登录用户体系关联。

### 匿名用户

```swift
let identity = try await FeatureKitClient.shared.initialize()
```

FeatureKit 会为当前 App 安装维护稳定的安装身份。

### 已登录用户

如果你的 App 已经有用户账号体系，可以传入一个稳定的内部用户 ID：

```swift
let identity = try await FeatureKitClient.shared.identify(
    userID: "YOUR_USER_ID",
    name: "Optional Name",
    email: "optional@example.com"
)
```

建议使用稳定的用户 ID，不要使用临时 Session ID。

### 用户退出登录

如果用户退出登录，希望 FeatureKit 回到匿名身份：

```swift
let identity = try await FeatureKitClient.shared.resetIdentity()
```

调用 `resetIdentity()` 前，应先完成 `initialize()` 或 `identify(...)`。

## 展示 FeatureKit 反馈页面

`FeatureKitView` 提供完整的反馈体验，包括：

- 功能建议 / 用户反馈列表
- 反馈详情页
- 产品状态展示
- 点赞 / 取消点赞
- 提交反馈
- 可选邮箱输入
- 官方回复展示
- Loading / Empty / Error / Success 等状态页

### SwiftUI

可以直接在 SwiftUI 中展示：

```swift
import FeatureKit
import SwiftUI

struct SettingsView: View {
    @State private var showsFeatureKit = false

    var body: some View {
        Button("意见反馈与功能建议") {
            showsFeatureKit = true
        }
        .sheet(isPresented: $showsFeatureKit) {
            FeatureKitView()
        }
    }
}
```

如果你需要自己处理关闭动作：

```swift
FeatureKitView(
    onClose: {
        // 根据你的页面结构执行 dismiss
    }
)
```

### UIKit

FeatureKit 提供 UIKit Bridge：

```swift
import FeatureKit

let viewController = FeatureKitView.makeViewController()
let navigationController = UINavigationController(
    rootViewController: viewController
)

present(navigationController, animated: true)
```

也可以根据现有导航结构，直接以 Sheet、Full Screen 或其他方式展示 `makeViewController()` 返回的页面。

## 自定义界面

FeatureKit 提供默认样式，同时支持客户端覆盖主题和页面文案。

### 自定义主题

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

### 自定义页面文案

```swift
let copy = FeatureKitCopy(
    title: "功能建议",
    emptyTitle: "暂时还没有建议",
    emptyMessage: "欢迎提交第一个产品建议。",
    submitTitle: "提交建议",
    submitButton: "提交",
    cancelButton: "关闭",
    feedbackTitle: "反馈详情",
    officialResponseTitle: "官方回复",
    successTitle: "感谢反馈",
    successMessage: "你的反馈已经提交。"
)

let view = FeatureKitView(copy: copy)
```

### 隐藏邮箱输入框

```swift
FeatureKitView(showsEmailField: false)
```

最终是否显示邮箱输入框，也可能受到 FeatureKit Dashboard 中 Project 配置的影响。

## 推荐接入流程

```text
创建 FeatureKit Project
        ↓
填写 App Bundle ID
        ↓
创建 API Key
        ↓
集成 FeatureKit SDK
        ↓
FeatureKit.configure(...)
        ↓
initialize() / identify(...)
        ↓
在 App 中展示 FeatureKitView
        ↓
用户提交反馈 / 功能建议 / 投票
        ↓
在 FeatureKit Dashboard 中查看和处理反馈
```

## Bundle ID 与 API Key 校验

每个 Project API Key 与 Project 配置的 Bundle ID 对应。

SDK 运行时自动获取宿主 App 的 Bundle ID，并随 SDK 请求发送给 FeatureKit 服务端。服务端会验证当前 Bundle ID 是否与 API Key 对应的 Project 一致。

如果正式版、测试版、Beta 版或白标 App 使用不同 Bundle ID，建议分别创建不同的 FeatureKit Project 和 API Key，除非你的 FeatureKit 账号另有配置。

## 错误处理

FeatureKit API 使用 Swift Error，可以使用正常的 `do/catch`：

```swift
do {
    let identity = try await FeatureKitClient.shared.initialize()
    print(identity)
} catch {
    print("FeatureKit error: \(error)")
}
```

生产环境中建议不要因为 FeatureKit 暂时不可用而阻塞 App 的核心功能。反馈模块通常可以作为独立能力进行降级处理。

## 版本规则

FeatureKit 使用 Semantic Versioning：

- Patch（`1.0.x`）：向后兼容的 Bug Fix
- Minor（`1.x.0`）：向后兼容的新功能
- Major（`x.0.0`）：可能包含 Breaking Changes

正式版本发布后，生产项目建议固定使用版本规则，而不是长期跟随 `main` 分支。

## 技术支持与申请使用

FeatureKit 当前为邀请制。

请访问 https://feedback.nicolaigame.top 申请使用、留下邮箱，并在账号开通后创建 Project 和 API Key。

集成问题、账号问题和产品支持，请通过 FeatureKit 官网或 Dashboard 中提供的联系方式与我们联系。
