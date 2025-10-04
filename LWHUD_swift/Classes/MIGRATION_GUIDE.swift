//
//  MIGRATION_GUIDE.swift
//  LWHUD
//
//  Migration guide from Objective-C to Swift
//

/*

# LWHUD Swift Migration Guide

## Overview

This guide helps you migrate from the Objective-C version of LWHUD to the new Swift/SwiftUI version.
The Swift version maintains API compatibility while providing modern Swift features and SwiftUI support.

## Basic API Changes

### Class Methods

#### Objective-C:
```objc
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
[LWHUD hideHUDForView:self.view animated:YES];
LWHUD *hud = [LWHUD HUDForView:self.view];
```

#### Swift:
```swift
let hud = LWHUD.showHUD(addedTo: view, animated: true)
LWHUD.hideHUD(for: view, animated: true)
let hud = LWHUD.hud(for: view)
```

### Instance Methods

#### Objective-C:
```objc
LWHUD *hud = [[LWHUD alloc] initWithView:self.view];
[hud showAnimated:YES];
[hud hideAnimated:YES];
[hud hideAnimated:YES afterDelay:2.0];
```

#### Swift:
```swift
let hud = LWHUD(view: view)
hud.show(animated: true)
hud.hide(animated: true)
hud.hide(animated: true, afterDelay: 2.0)
```

### Properties

#### Objective-C:
```objc
hud.mode = LWHUDModeIndeterminate;
hud.animationType = LWHUDAnimationFade;
hud.label.text = @"Loading...";
hud.detailsLabel.text = @"Please wait";
hud.progress = 0.5f;
hud.contentColor = [UIColor whiteColor];
```

#### Swift:
```swift
hud.mode = .indeterminate
hud.animationType = .fade
hud.label.text = "Loading..."
hud.detailsLabel.text = "Please wait"
hud.progress = 0.5
hud.contentColor = .white
```

### Enums

#### Objective-C:
```objc
typedef NS_ENUM(NSInteger, LWHUDMode) {
    LWHUDModeIndeterminate,
    LWHUDModeDeterminate,
    LWHUDModeDeterminateHorizontalBar,
    LWHUDModeAnnularDeterminate,
    LWHUDModeCustomView,
    LWHUDModeText
};
```

#### Swift:
```swift
enum LWHUDMode {
    case indeterminate
    case determinate
    case determinateHorizontalBar
    case annularDeterminate
    case customView
    case text
}
```

### Delegate

#### Objective-C:
```objc
@protocol LWHUDDelegate <NSObject>
@optional
- (void)hudWasHidden:(LWHUD *)hud;
@end

// Usage
hud.delegate = self;

// Implementation
- (void)hudWasHidden:(LWHUD *)hud {
    NSLog(@"HUD was hidden");
}
```

#### Swift:
```swift
protocol LWHUDDelegate: AnyObject {
    func hudWasHidden(_ hud: LWHUD)
}

// Usage
hud.delegate = self

// Implementation
func hudWasHidden(_ hud: LWHUD) {
    print("HUD was hidden")
}
```

### Completion Blocks

#### Objective-C:
```objc
hud.completionBlock = ^{
    NSLog(@"HUD completed");
};
```

#### Swift:
```swift
hud.completionBlock = {
    print("HUD completed")
}
```

## New Swift-Only Features

### 1. Convenience Extensions

```swift
// UIViewController extensions
class MyViewController: UIViewController {
    func loadData() {
        showActivity(text: "Loading...")

        // Perform async work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSuccess("Data loaded!")
        }
    }
}
```

### 2. Global Functions

```swift
// Show on key window
showActivity(text: "Processing...")
showSuccess("Done!")
showError("Failed!")
```

### 3. Convenience Methods

```swift
// Show activity with text
LWHUD.showActivity(in: view, text: "Loading...")

// Show success with auto-hide
LWHUD.showSuccess("Operation completed!", in: view, hideAfter: 2.0)

// Show error with auto-hide
LWHUD.showError("Something went wrong", in: view, hideAfter: 2.0)

// Show text only
LWHUD.showText("Hello!", in: view, detailText: "Detail message", hideAfter: 2.0)

// Show progress
let hud = LWHUD.showProgress(0.5, text: "50%", in: view)
hud.updateProgress(0.75, text: "75%")
```

### 4. SwiftUI Integration

```swift
import SwiftUI

struct ContentView: View {
    @State private var showHUD = false

    var body: some View {
        Button("Load Data") {
            showHUD = true
            loadData()
        }
        .lwHUD(isPresented: $showHUD,
               mode: .indeterminate,
               text: "Loading...",
               detailText: "Please wait")
    }

    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showHUD = false
        }
    }
}
```

### 5. Native SwiftUI HUD View

```swift
struct MyView: View {
    @State private var showHUD = false

    var body: some View {
        ZStack {
            // Your content

            if showHUD {
                LWHUDView(mode: .indeterminate,
                         text: "Loading...",
                         detailText: "Please wait")
            }
        }
    }
}
```

## Progress Examples

### With NSProgress (Both versions)

#### Objective-C:
```objc
NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
hud.progressObject = progress;

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    for (int i = 0; i <= 100; i++) {
        [NSThread sleepForTimeInterval:0.05];
        progress.completedUnitCount = i;
    }
});
```

#### Swift:
```swift
let progress = Progress(totalUnitCount: 100)
hud.progressObject = progress

DispatchQueue.global().async {
    for i in 0...100 {
        Thread.sleep(forTimeInterval: 0.05)
        progress.completedUnitCount = Int64(i)
    }
}
```

### Manual Progress Updates

#### Objective-C:
```objc
__block float progress = 0.0f;
NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer) {
    progress += 0.05f;
    hud.progress = progress;

    if (progress >= 1.0f) {
        [timer invalidate];
        [hud hideAnimated:YES];
    }
}];
```

#### Swift:
```swift
var progress: Float = 0.0
Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
    progress += 0.05
    hud.progress = progress

    if progress >= 1.0 {
        timer.invalidate()
        hud.hide(animated: true)
    }
}
```

## Custom Views

### Objective-C:
```objc
UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
imageView.tintColor = [UIColor whiteColor];
hud.customView = imageView;
hud.mode = LWHUDModeCustomView;
```

### Swift:
```swift
let imageView = UIImageView(image: UIImage(named: "checkmark"))
imageView.tintColor = .white
hud.customView = imageView
hud.mode = .customView
```

## Customization

### Objective-C:
```objc
hud.bezelView.style = LWHUDBackgroundStyleBlur;
hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
hud.offset = CGPointMake(0, -100);
hud.margin = 30.0f;
hud.minSize = CGSizeMake(150, 150);
hud.square = YES;
```

### Swift:
```swift
hud.bezelView.style = .blur
hud.bezelView.blurEffectStyle = .dark
hud.bezelView.color = UIColor.black.withAlphaComponent(0.8)
hud.offset = CGPoint(x: 0, y: -100)
hud.margin = 30.0
hud.minSize = CGSize(width: 150, height: 150)
hud.isSquare = true
```

## Thread Safety

Both versions require main thread access:

#### Objective-C:
```objc
dispatch_async(dispatch_get_main_queue(), ^{
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
});
```

#### Swift:
```swift
DispatchQueue.main.async {
    let hud = LWHUD.showHUD(addedTo: view, animated: true)
}

// Or use @MainActor in Swift 5.5+
@MainActor
func showHUD() {
    let hud = LWHUD.showHUD(addedTo: view, animated: true)
}
```

## Migration Checklist

- [ ] Replace all `[LWHUD showHUDAddedTo:animated:]` with `LWHUD.showHUD(addedTo:animated:)`
- [ ] Replace all `[LWHUD hideHUDForView:animated:]` with `LWHUD.hideHUD(for:animated:)`
- [ ] Update enum cases to Swift style (`.indeterminate` instead of `LWHUDModeIndeterminate`)
- [ ] Replace `@property` syntax with Swift property access
- [ ] Update delegates to conform to Swift protocol syntax
- [ ] Replace blocks with Swift closures
- [ ] Consider using new convenience methods for common use cases
- [ ] Add SwiftUI support where applicable
- [ ] Update NSProgress usage to Swift syntax
- [ ] Review and update custom view implementations

## Best Practices

1. **Use convenience methods**: The Swift version provides many convenience methods that simplify common use cases.

2. **Leverage SwiftUI**: If your app uses SwiftUI, take advantage of the native SwiftUI integration.

3. **Use type inference**: Swift can infer types, so you don't need to specify them everywhere.

4. **Prefer named parameters**: Swift's named parameters make the API more readable.

5. **Use @MainActor**: In Swift 5.5+, use `@MainActor` to ensure main thread execution.

## Breaking Changes

There are no breaking changes in the API. The Swift version maintains compatibility with the Objective-C API,
so you can migrate gradually or mix both versions in the same project.

## Additional Resources

- Example file: LWHUDExample.swift
- SwiftUI examples: LWHUDSwiftUI.swift
- Extension methods: LWHUD+Extensions.swift

*/
