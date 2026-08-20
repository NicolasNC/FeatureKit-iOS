# FeatureKit iOS SDK

[English](README.md)

FeatureKit 是一个以预编译 `XCFramework` 形式分发的 iOS SDK。

本公开仓库只包含包管理配置、集成文档和编译后的 SDK 二进制，不包含 FeatureKit 的私有 Swift 实现源码。

## 系统要求

- iOS 15.0+
- 支持 Swift 5.9+ 的 Xcode

## 集成方式

### Swift Package Manager

在 Xcode 中：

1. 打开 **File > Add Package Dependencies...**
2. 输入 `https://github.com/NicolasNC/FeatureKit-iOS`
3. 将 `FeatureKit` Product 添加到你的 App Target

然后：

```swift
import FeatureKit
```

### CocoaPods

在正式发布到 CocoaPods Trunk 之前，可以直接从 GitHub 仓库集成：

```ruby
pod 'FeatureKit', :git => 'https://github.com/NicolasNC/FeatureKit-iOS.git', :branch => 'main'
```

正式发布到 CocoaPods Trunk 后：

```ruby
pod 'FeatureKit', '~> 1.0'
```

然后执行：

```bash
pod install
```

打开生成的 `.xcworkspace`，在代码中 `import FeatureKit` 即可。

### 手动集成 XCFramework

下载 `FeatureKit.xcframework.zip` 并解压，将 `FeatureKit.xcframework` 添加到 Xcode 工程和 App Target 中。

## 基础配置

客户只需要提供 FeatureKit 项目的 API Key，不再需要手动传 Bundle ID。

SDK 会在内部通过 `Bundle.main.bundleIdentifier` 自动获取当前宿主 App 的 Bundle ID，公开配置 API 不提供 Bundle ID 的自定义入口。

```swift
import FeatureKit

let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY"
)

await FeatureKit.configure(configuration)
```

如果你的 FeatureKit 环境使用自定义 API 地址，可以额外传入 `baseURL`：

```swift
let configuration = try FeatureKitConfiguration(
    apiKey: "YOUR_API_KEY",
    baseURL: URL(string: "https://your-featurekit-endpoint.example/api/v1")!
)
```

## Bundle ID 与 API Key 校验

每个 FeatureKit 项目 API Key 都应与该项目配置的 Bundle ID 对应。

SDK 会自动读取宿主 App 的 Bundle ID 并随请求发送给 FeatureKit 服务端。服务端会校验：

```text
API Key 对应的 Project Bundle ID
              ==
SDK 当前宿主 App 的 Bundle ID
```

匹配时请求正常通过；不匹配时服务端拒绝请求。

这样可以避免客户把同一个 Project API Key 直接复制到多个不同 Bundle ID 的 App 中使用。

如果正式版、测试版、白标版使用不同 Bundle ID，建议分别创建 FeatureKit Project / API Key，除非你的 FeatureKit 账号明确配置了其他授权方案。

> 注意：Bundle ID 是客户端信息，不能作为密码或机密凭证。二进制 SDK 也可能被逆向分析。真正敏感的鉴权和安全规则始终由 FeatureKit 服务端负责。

## 初始化用户身份

匿名用户可以初始化 FeatureKit Identity：

```swift
let identity = try await FeatureKitClient.shared.initialize()
```

如果宿主 App 已经有登录用户，可以关联自己的稳定用户 ID：

```swift
let identity = try await FeatureKitClient.shared.identify(
    userID: "YOUR_USER_ID",
    name: "Optional Name",
    email: "optional@example.com"
)
```

## 源码可见性

FeatureKit 对外分发的是预编译 `XCFramework`。客户可以看到集成所需的公开 API 和编译后的二进制，但本公开仓库不包含私有 Swift 实现源码。

和所有客户端二进制一样，XCFramework 理论上仍可被反汇编或逆向分析，因此服务端密钥和真正需要保密的安全逻辑不能放在 SDK 中。

## 版本规则

FeatureKit 使用 Semantic Versioning：

- Patch（`1.0.x`）：向后兼容的修复
- Minor（`1.x.0`）：向后兼容的新功能
- Major（`x.0.0`）：可能包含不兼容 API 调整

## 技术支持

API Key、接口地址、集成问题和产品支持，请使用 FeatureKit 账号提供的支持渠道。
