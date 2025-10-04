# LWHUD Swift版本使用指南

## 概述

LWHUD_swift 是 LWHUD 的 Swift 实现版本，提供了轻量级的 HUD 组件，支持 UIKit 和 SwiftUI 两种使用方式。

## 安装

### CocoaPods

在你的 Podfile 中添加：

```ruby
pod 'LWHUD_swift'
```

然后运行：

```bash
pod install
```

## 系统要求

- iOS 13.0+
- Swift 5.0+

## 主要功能

### 1. UIKit 中使用

基础用法：

```swift
import LWHUD_swift

// 显示简单文本
LWHUD.show(text: "加载中...")

// 显示成功提示
LWHUD.showSuccess(text: "操作成功")

// 显示错误提示
LWHUD.showError(text: "操作失败")

// 显示进度
LWHUD.showProgress(0.5, text: "下载中...")

// 隐藏 HUD
LWHUD.hide()
```

在特定视图中显示：

```swift
import LWHUD_swift

// 在指定视图中显示
LWHUD.show(text: "加载中...", in: self.view)

// 自动隐藏
LWHUD.show(text: "消息已发送", duration: 2.0)
```

### 2. SwiftUI 中使用

使用 ViewModifier：

```swift
import SwiftUI
import LWHUD_swift

struct ContentView: View {
    @State private var isLoading = false

    var body: some View {
        VStack {
            Button("开始加载") {
                isLoading = true
                // 模拟网络请求
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }
        .showHUD(isPresented: $isLoading, text: "加载中...")
    }
}
```

使用自定义 HUD 视图：

```swift
import SwiftUI
import LWHUD_swift

struct ContentView: View {
    @State private var showHUD = false

    var body: some View {
        ZStack {
            VStack {
                Button("显示 HUD") {
                    showHUD = true
                }
            }

            if showHUD {
                LWHUDView(text: "加载中...")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showHUD = false
                        }
                    }
            }
        }
    }
}
```

### 3. 自定义样式

```swift
import LWHUD_swift

// 自定义背景颜色
LWHUD.show(text: "自定义样式") { hud in
    hud.backgroundColor = .black.withAlphaComponent(0.8)
    hud.contentColor = .white
}

// 自定义进度视图
LWHUD.showProgress(0.5, text: "下载中...") { hud in
    hud.progressViewStyle = .circular
}
```

### 4. 进度视图

LWHUD_swift 提供了多种进度视图样式：

```swift
import LWHUD_swift

// 圆形进度
let progressView = LWCircularProgressView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
progressView.progress = 0.75

// 线性进度
let linearProgress = LWLinearProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 4))
linearProgress.progress = 0.5
```

### 5. 背景视图

自定义背景效果：

```swift
import LWHUD_swift

let backgroundView = LWBackgroundView(frame: UIScreen.main.bounds)
backgroundView.style = .blur(.dark)
backgroundView.isUserInteractionEnabled = true
```

## 高级功能

### 扩展方法

LWHUD 提供了便捷的扩展方法：

```swift
import LWHUD_swift

// UIViewController 扩展
self.showHUD(text: "加载中...")
self.hideHUD()

// UIView 扩展
view.showHUD(text: "处理中...")
view.hideHUD()
```

### 链式调用

```swift
import LWHUD_swift

LWHUD.show(text: "加载中...")
    .setBackgroundColor(.black.withAlphaComponent(0.7))
    .setContentColor(.white)
    .setCornerRadius(10)
    .hide(afterDelay: 2.0)
```

## 迁移指南

如果你正在从 Objective-C 版本迁移到 Swift 版本，请参考 `MIGRATION_GUIDE.swift` 文件获取详细的迁移步骤和示例。

## 示例代码

更多使用示例请参考 `LWHUDExample.swift` 文件，其中包含了各种使用场景的完整示例。

## 注意事项

1. **线程安全**：所有 UI 操作都会自动在主线程执行
2. **自动隐藏**：默认情况下，HUD 不会自动隐藏，需要手动调用 `hide()` 或设置自动隐藏时间
3. **SwiftUI 支持**：需要 iOS 13.0 及以上版本才能使用 SwiftUI 相关功能
4. **性能优化**：HUD 使用了高效的渲染机制，适合频繁显示和隐藏

## Objective-C 版本

如果你的项目使用 Objective-C，请使用原版 LWHUD：

```ruby
pod 'LWHUD'
```

## 许可证

LWHUD_swift 使用 MIT 许可证。详见 LICENSE 文件。
