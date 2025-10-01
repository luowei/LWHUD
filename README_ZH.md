# LWHUD

[![CI Status](https://img.shields.io/travis/luowei/LWHUD.svg?style=flat)](https://travis-ci.org/luowei/LWHUD)
[![Version](https://img.shields.io/cocoapods/v/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)
[![License](https://img.shields.io/cocoapods/l/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)
[![Platform](https://img.shields.io/cocoapods/p/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)

## 简介

LWHUD 是一个轻量级的 iOS HUD（Heads-Up Display）提示组件，基于 MBProgressHUD 改造而来。它特别适用于在 SDK 中使用，可以有效避免 SDK 与 App 的依赖冲突问题。

## 特性

- 多种显示模式：加载指示器、进度条、环形进度、文本提示等
- 灵活的自定义选项：颜色、字体、动画、位置等
- 支持优雅的动画效果（淡入淡出、缩放）
- 模糊和纯色背景样式
- 支持 NSProgress 对象
- 轻量级设计，易于集成
- 避免依赖冲突，适合 SDK 开发
- 完善的 API 设计，简单易用

## 系统要求

- iOS 8.0 或更高版本
- Xcode 11.0 或更高版本
- Objective-C

## 安装

### CocoaPods

LWHUD 支持通过 [CocoaPods](https://cocoapods.org) 安装。在你的 `Podfile` 中添加：

```ruby
pod 'LWHUD'
```

然后执行：

```bash
pod install
```

### Carthage

也支持通过 Carthage 安装，在 `Cartfile` 中添加：

```ruby
github "luowei/LWHUD"
```

## 使用方法

### 基础用法

#### 1. 显示简单的文本提示

```objective-c
+ (void)showHUDWithMessage:(NSString *)message {
    if(!message || message.length == 0){
        return;
    }
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = message;
    hud.mode = LWHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}
```

#### 2. 显示详细文本提示

```objective-c
+ (void)showHUDWithDetailMessage:(NSString *)message {
    if(!message || message.length == 0){
        return;
    }
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabel.text = message;
    hud.mode = LWHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}
```

#### 3. 显示加载指示器

```objective-c
+ (void)showHUDLoading {
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = LWHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
}
```

#### 4. 隐藏加载指示器

```objective-c
+ (void)hideHUDLoading {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    for(UIView *view in keywindow.subviews){
        if([view isKindOfClass:[LWHUD class]]){
            [(LWHUD *)view hideAnimated:NO];
            [view removeFromSuperview];
        }
    }
}
```

### 高级用法

#### 1. 自定义样式的加载提示

```objective-c
- (void)showLoading {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.loadingHUD = [LWHUD showHUDAddedTo:window animated:YES];
    self.loadingHUD.bezelView.alpha = 0.6;
    self.loadingHUD.contentColor = [UIColor whiteColor];
    self.loadingHUD.bezelView.style = LWHUDBackgroundStyleSolidColor;
    self.loadingHUD.bezelView.backgroundColor = [UIColor blackColor];
    self.loadingHUD.removeFromSuperViewOnHide = YES;
    self.loadingHUD.mode = LWHUDModeIndeterminate;
}
```

#### 2. 显示进度条

```objective-c
- (void)showLoadingWithProgress:(float)progress {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.loadingHUD = [LWHUD showHUDAddedTo:window animated:YES];
    self.loadingHUD.bezelView.alpha = 0.6;
    self.loadingHUD.removeFromSuperViewOnHide = YES;
    self.loadingHUD.mode = LWHUDModeAnnularDeterminate;
    self.loadingHUD.progress = progress;
}
```

#### 3. Toast 样式的文本提示

```objective-c
+ (void)showToastText:(NSString *)toastText duration:(NSTimeInterval)duration {
    UIView *v = [UIApplication sharedApplication].keyWindow;
    LWHUD *hud = [LWHUD showHUDAddedTo:v animated:YES];
    hud.bezelView.alpha = 0.6;
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = LWHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.mode = LWHUDModeText;
    hud.detailsLabel.text = toastText;
    [hud hideAnimated:YES afterDelay:duration];
}
```

#### 4. 使用自定义视图

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeCustomView;
UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
hud.customView = imageView;
hud.label.text = @"完成";
[hud hideAnimated:YES afterDelay:2];
```

## API 文档

### 显示模式 (LWHUDMode)

LWHUD 支持多种显示模式：

- `LWHUDModeIndeterminate` - UIActivityIndicatorView 活动指示器（默认）
- `LWHUDModeDeterminate` - 圆形饼图样式的进度视图
- `LWHUDModeDeterminateHorizontalBar` - 水平进度条
- `LWHUDModeAnnularDeterminate` - 环形进度视图
- `LWHUDModeCustomView` - 显示自定义视图
- `LWHUDModeText` - 仅显示文本

### 动画类型 (LWHUDAnimation)

- `LWHUDAnimationFade` - 透明度动画（默认）
- `LWHUDAnimationZoom` - 透明度 + 缩放动画（自动选择方向）
- `LWHUDAnimationZoomOut` - 透明度 + 缩放动画（缩小样式）
- `LWHUDAnimationZoomIn` - 透明度 + 缩放动画（放大样式）

### 背景样式 (LWHUDBackgroundStyle)

- `LWHUDBackgroundStyleSolidColor` - 纯色背景
- `LWHUDBackgroundStyleBlur` - 模糊效果背景（iOS 7+）

### 类方法

#### 显示 HUD

```objective-c
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
```
创建并显示一个 HUD，添加到指定视图上。

#### 隐藏 HUD

```objective-c
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
```
查找并隐藏指定视图上的 HUD。

#### 查找 HUD

```objective-c
+ (nullable LWHUD *)HUDForView:(UIView *)view;
```
返回指定视图上最顶层的 HUD。

### 实例方法

#### 显示/隐藏

```objective-c
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
```

### 主要属性

#### 代理和回调

```objective-c
@property (weak, nonatomic) id<LWHUDDelegate> delegate;
@property (copy, nullable) LWHUDCompletionBlock completionBlock;
```

#### 显示时间控制

```objective-c
@property (assign, nonatomic) NSTimeInterval graceTime;        // 延迟显示时间（默认 0）
@property (assign, nonatomic) NSTimeInterval minShowTime;      // 最小显示时间（默认 0）
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;  // 隐藏时是否移除（默认 NO）
```

#### 外观属性

```objective-c
@property (assign, nonatomic) LWHUDMode mode;                      // 显示模式
@property (strong, nonatomic, nullable) UIColor *contentColor;     // 内容颜色
@property (assign, nonatomic) LWHUDAnimation animationType;        // 动画类型
@property (assign, nonatomic) CGPoint offset;                      // 位置偏移
@property (assign, nonatomic) CGFloat margin;                      // 内边距（默认 20）
@property (assign, nonatomic) CGSize minSize;                      // 最小尺寸
@property (assign, nonatomic, getter = isSquare) BOOL square;      // 是否为正方形
```

#### 进度相关

```objective-c
@property (assign, nonatomic) float progress;                      // 进度值（0.0 到 1.0）
@property (strong, nonatomic, nullable) NSProgress *progressObject;// NSProgress 对象
```

#### UI 组件

```objective-c
@property (strong, nonatomic, readonly) LWBackgroundView *bezelView;    // 主容器视图
@property (strong, nonatomic, readonly) LWBackgroundView *backgroundView;// 背景视图
@property (strong, nonatomic, nullable) UIView *customView;              // 自定义视图
@property (strong, nonatomic, readonly) UILabel *label;                  // 主标签
@property (strong, nonatomic, readonly) UILabel *detailsLabel;           // 详细文本标签
@property (strong, nonatomic, readonly) UIButton *button;                // 按钮
```

## 代理方法

### LWHUDDelegate

```objective-c
@protocol LWHUDDelegate <NSObject>
@optional
- (void)hudWasHidden:(LWHUD *)hud;  // HUD 完全隐藏后调用
@end
```

## 使用场景

### 1. 网络请求加载

```objective-c
- (void)loadData {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中...";

    [self.networkClient fetchDataWithCompletion:^(id data, NSError *error) {
        [hud hideAnimated:YES];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
        }
    }];
}
```

### 2. 文件上传进度

```objective-c
- (void)uploadFile {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = LWHUDModeDeterminate;
    hud.label.text = @"上传中...";

    NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
    hud.progressObject = progress;

    // 上传文件并更新进度
    [self.uploader uploadWithProgress:progress completion:^{
        [hud hideAnimated:YES];
    }];
}
```

### 3. 操作成功提示

```objective-c
- (void)showSuccessMessage {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = LWHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = @"操作成功";
    [hud hideAnimated:YES afterDelay:1.5];
}
```

### 4. 延迟显示

```objective-c
- (void)performTask {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.graceTime = 0.5;  // 任务如果在 0.5 秒内完成，则不显示 HUD
    hud.minShowTime = 1.0; // HUD 至少显示 1 秒

    [self performLongTask:^{
        [hud hideAnimated:YES];
    }];
}
```

## 注意事项

1. **线程安全**：LWHUD 必须在主线程上访问和操作。

2. **内存管理**：设置 `removeFromSuperViewOnHide = YES` 可以在 HUD 隐藏时自动从父视图中移除。

3. **避免重复**：使用 `[LWHUD HUDForView:]` 方法可以检查视图上是否已存在 HUD。

4. **自定义视图**：自定义视图应该实现 `intrinsicContentSize` 以获得正确的尺寸，推荐尺寸约为 37x37 像素。

5. **SDK 集成**：LWHUD 特别适合在 SDK 中使用，因为它避免了与宿主应用的依赖冲突。

6. **iOS 版本兼容**：某些特性（如模糊效果）在 iOS 7 及以下版本会有不同的实现。

## 性能优化建议

- 对于短时间任务，使用 `graceTime` 避免 HUD 闪烁
- 使用 `minShowTime` 确保用户能看清 HUD 内容
- 在不需要时及时隐藏 HUD
- 避免同时显示多个 HUD
- 使用 `LWHUDModeText` 模式显示纯文本时性能最佳

## 示例项目

要运行示例项目，请克隆仓库，然后在 Example 目录中运行 `pod install`。

```bash
git clone https://github.com/luowei/LWHUD.git
cd LWHUD/Example
pod install
open LWHUD.xcworkspace
```

## 常见问题

**Q: HUD 没有显示？**
A: 确保在主线程调用，并且添加到了正确的视图上。检查视图的 `hidden` 属性和 alpha 值。

**Q: 如何自定义 HUD 的颜色？**
A: 使用 `contentColor` 属性统一设置所有内容颜色，或单独设置 `label`、`detailsLabel` 等的颜色。

**Q: 如何让 HUD 不阻塞用户交互？**
A: 设置 `hud.userInteractionEnabled = NO`。

**Q: 如何在 SDK 中使用？**
A: LWHUD 专门设计用于 SDK 集成，直接引入即可，不会与宿主应用的 MBProgressHUD 产生冲突。

## 版本历史

### 1.0.0
- 初始发布版本
- 支持多种显示模式
- 支持自定义样式
- 支持 iOS 8.0+

## 作者

luowei - luowei@wodedata.com

## 协议

LWHUD 基于 MIT 协议开源。详见 [LICENSE](LICENSE) 文件。

原始代码版权归 Matej Bukovinski 所有（2009-2016），基于 MBProgressHUD 改造。

## 致谢

- 感谢 [MBProgressHUD](https://github.com/jdg/MBProgressHUD) 项目提供的优秀基础代码
- 感谢所有贡献者和使用者的反馈

## 相关链接

- [GitHub 仓库](https://github.com/luowei/LWHUD)
- [CocoaPods](https://cocoapods.org/pods/LWHUD)
- [问题反馈](https://github.com/luowei/LWHUD/issues)
