# LWHUD


## graphify Knowledge Graph

- Interactive graph: https://luowei.github.io/LWHUD/
- Report: https://luowei.github.io/LWHUD/GRAPH_REPORT.md
- Graph data: https://luowei.github.io/LWHUD/graph.json

[![CI Status](https://img.shields.io/travis/luowei/LWHUD.svg?style=flat)](https://travis-ci.org/luowei/LWHUD)
[![Version](https://img.shields.io/cocoapods/v/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)
[![License](https://img.shields.io/cocoapods/l/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)
[![Platform](https://img.shields.io/cocoapods/p/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)

[English](./README.md) | [中文版](./README_ZH.md) | [Swift Version](./README_SWIFT_VERSION.md)

## Overview

LWHUD is a modern, feature-rich iOS HUD (Heads-Up Display) library that provides a clean and customizable way to display loading indicators, progress views, and status messages to your users. Based on MBProgressHUD with custom enhancements, LWHUD is specifically designed for SDK integration to avoid dependency conflicts.

## Quick Start

Get started with LWHUD in just a few lines of code:

```objective-c
// Show loading indicator
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.label.text = @"Loading...";

// Hide when done
[hud hideAnimated:YES];
```

```swift
// Swift
let hud = LWHUD.showAdded(to: view, animated: true)
hud.label.text = "Loading..."
hud.hide(animated: true)
```

**Want more?** Check out the [Usage Examples](#usage-examples) section for detailed examples.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Why LWHUD?](#why-lwhud)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Carthage](#carthage)
  - [Manual Installation](#manual-installation)
- [Display Modes Overview](#display-modes-overview)
- [Usage Examples](#usage-examples)
  - [Basic Usage](#basic-usage)
  - [Progress Indicators](#progress-indicators)
  - [Custom Views](#custom-views)
  - [Advanced Usage](#advanced-usage)
- [Swift Usage](#swift-usage)
- [Customization Options](#customization-options)
- [API Reference](#api-reference)
- [Threading](#threading)
- [Best Practices](#best-practices)
- [Common Use Cases](#common-use-cases)
- [Troubleshooting](#troubleshooting)
- [Quick Reference](#quick-reference)
- [Author](#author)
- [Contributing](#contributing)
- [License](#license)
- [Credits](#credits)
- [Support](#support)
- [Links](#links)

## Why LWHUD?

LWHUD stands out as the ideal HUD solution for iOS development, especially for SDK integration:

- **SDK-Friendly**: Renamed classes prevent conflicts with MBProgressHUD in host applications
- **Zero Dependencies**: Self-contained, no external dependencies required
- **Battle-Tested**: Based on the proven MBProgressHUD architecture with thousands of production apps
- **Highly Customizable**: Full control over appearance and behavior
- **Thread-Safe**: Works seamlessly with GCD and operation queues
- **Modern iOS Support**: Optimized for iOS 9.0+ with blur effects and modern APIs
- **Active Maintenance**: Regular updates and bug fixes
- **Easy Integration**: Multiple installation options - CocoaPods, Carthage, and manual
- **Swift & Objective-C**: Full support for both languages with natural APIs

## Features

- **Multiple Display Modes**
  - **Indeterminate** - UIActivityIndicatorView spinner for ongoing operations
  - **Determinate** - Circular pie chart style progress (0-100%)
  - **Horizontal Bar** - Linear progress bar for file operations
  - **Annular Determinate** - Ring-shaped progress indicator
  - **Custom View** - Display your own UIView (icons, images, etc.)
  - **Text Only** - Toast-style text messages without indicators

- **Flexible Animations**
  - **Fade** - Smooth opacity transitions
  - **Zoom** - Scale + opacity animation (auto-direction)
  - **Zoom In** - Expand from center when appearing
  - **Zoom Out** - Collapse to center when disappearing
  - Customizable animation duration

- **Customization Options**
  - **Colors** - Customize content, background, and bezel colors
  - **Background Styles** - Solid color or iOS blur effects (light/dark)
  - **Positioning** - Adjustable offsets from center, edge positioning
  - **Sizing** - Custom margins, minimum sizes, square or dynamic dimensions
  - **Effects** - Built-in parallax motion effects
  - **Typography** - Full control over label fonts and colors

- **Advanced Features**
  - **Grace Time** - Delay before showing (prevents flashing on quick operations)
  - **Minimum Show Time** - Ensure HUD displays long enough to be readable
  - **NSProgress Integration** - Automatic progress updates from NSProgress objects
  - **Delegate Pattern** - Callback when HUD is hidden
  - **Completion Blocks** - Execute code after HUD disappears
  - **Auto-Hide** - Automatically hide after specified delay
  - **Button Support** - Add interactive buttons (e.g., Cancel)
  - **Thread-Safe** - Works with GCD and operation queues

## Display Modes Overview

LWHUD supports six distinct display modes, each optimized for specific use cases:

### 1. Indeterminate Mode (`LWHUDModeIndeterminate`)

**Default mode** - Displays a standard iOS activity indicator (spinner).

| Aspect | Description |
|--------|-------------|
| **Best for** | Unknown duration tasks, network requests, background processing |
| **Visual** | Animated spinning wheel |
| **Progress** | Not applicable |

**Common use cases:**
- Loading data from server
- Processing without known duration
- Waiting for API response

---

### 2. Determinate Mode (`LWHUDModeDeterminate`)

Displays a circular pie chart that fills clockwise as progress increases.

| Aspect | Description |
|--------|-------------|
| **Best for** | Tasks with trackable progress (0.0 - 1.0) |
| **Visual** | Circular pie chart filling from center |
| **Progress** | 0.0 to 1.0 (0% to 100%) |

**Common use cases:**
- File downloads with progress tracking
- Multi-step operations
- Data processing with percentage

---

### 3. Horizontal Bar Mode (`LWHUDModeDeterminateHorizontalBar`)

Shows a horizontal progress bar similar to Safari's page loading indicator.

| Aspect | Description |
|--------|-------------|
| **Best for** | Linear progress visualization |
| **Visual** | Horizontal bar filling left to right |
| **Progress** | 0.0 to 1.0 (0% to 100%) |

**Common use cases:**
- File uploads/downloads
- Batch processing operations
- Sequential task completion

---

### 4. Annular Determinate Mode (`LWHUDModeAnnularDeterminate`)

Displays a ring-shaped progress indicator that fills along the perimeter.

| Aspect | Description |
|--------|-------------|
| **Best for** | Modern, clean progress indication |
| **Visual** | Ring outline filling clockwise |
| **Progress** | 0.0 to 1.0 (0% to 100%) |

**Common use cases:**
- Upload/download progress
- Task completion percentage
- Time-based countdowns

---

### 5. Custom View Mode (`LWHUDModeCustomView`)

Allows you to display any custom UIView (typically icons or images).

| Aspect | Description |
|--------|-------------|
| **Best for** | Success/error states, custom branding |
| **Visual** | Your custom view (recommended: ~37x37 points) |
| **Progress** | Not applicable |

**Common use cases:**
- Success checkmark icon
- Error/warning icons
- Custom branded graphics
- Animated custom views

---

### 6. Text Only Mode (`LWHUDModeText`)

Shows only text labels without any indicator - perfect for toast messages.

| Aspect | Description |
|--------|-------------|
| **Best for** | Quick status messages, notifications |
| **Visual** | Text in a bezel (no spinner or progress) |
| **Progress** | Not applicable |

**Common use cases:**
- "Saved successfully" messages
- Brief status updates
- User feedback notifications
- Error/warning messages

## Usage Examples

### Basic Usage

#### 1. Simple Loading Indicator

```objective-c
// Show loading indicator
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Hide when done
[hud hideAnimated:YES];
```

#### 2. Loading with Text Message

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.label.text = @"Loading...";
hud.removeFromSuperViewOnHide = YES;
```

#### 3. Text-Only Message (Toast)

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeText;
hud.label.text = @"Success!";
hud.removeFromSuperViewOnHide = YES;
[hud hideAnimated:YES afterDelay:2.0];
```

#### 4. Detailed Message

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeText;
hud.label.text = @"Completed";
hud.detailsLabel.text = @"Your operation was successful";
hud.removeFromSuperViewOnHide = YES;
[hud hideAnimated:YES afterDelay:2.0];
```

### Progress Indicators

#### 1. Determinate Progress (Pie Chart)

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeDeterminate;
hud.label.text = @"Downloading...";

// Update progress
hud.progress = 0.5; // 50%
```

#### 2. Annular Progress (Ring)

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeAnnularDeterminate;
hud.label.text = @"Processing...";
hud.progress = 0.75; // 75%
```

#### 3. Horizontal Progress Bar

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeDeterminateHorizontalBar;
hud.label.text = @"Uploading...";
hud.progress = 0.3; // 30%
```

#### 4. Using NSProgress

```objective-c
NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeAnnularDeterminate;
hud.progressObject = progress;

// Update progress elsewhere
progress.completedUnitCount = 50; // 50%
```

### Custom Views

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeCustomView;

// Add a custom image view
UIImage *image = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
hud.customView = [[UIImageView alloc] initWithImage:image];
hud.label.text = @"Done";

hud.removeFromSuperViewOnHide = YES;
[hud hideAnimated:YES afterDelay:2.0];
```

### Advanced Usage

#### With Completion Block

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.label.text = @"Processing...";
hud.removeFromSuperViewOnHide = YES;

hud.completionBlock = ^{
    NSLog(@"HUD was hidden");
};

[hud hideAnimated:YES afterDelay:2.0];
```

#### With Delegate

```objective-c
@interface MyViewController () <LWHUDDelegate>
@end

@implementation MyViewController

- (void)showHUD {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.label.text = @"Loading...";
}

- (void)hudWasHidden:(LWHUD *)hud {
    NSLog(@"HUD was hidden");
}

@end
```

#### Grace Time and Minimum Show Time

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.label.text = @"Loading...";

// Delay showing HUD by 1 second (won't show for quick operations)
hud.graceTime = 1.0;

// Ensure HUD shows for at least 2 seconds (prevents flickering)
hud.minShowTime = 2.0;

hud.removeFromSuperViewOnHide = YES;
```

#### Helper Methods Example

```objective-c
// Show simple message
+ (void)showHUDWithMessage:(NSString *)message {
    if (!message || message.length == 0) {
        return;
    }
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = message;
    hud.mode = LWHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

// Show detailed message
+ (void)showHUDWithDetailMessage:(NSString *)message {
    if (!message || message.length == 0) {
        return;
    }
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabel.text = message;
    hud.mode = LWHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

// Show loading indicator
+ (void)showHUDLoading {
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = LWHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
}

// Hide loading
+ (void)hideHUDLoading {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [LWHUD hideHUDForView:keyWindow animated:YES];
}
```

## Customization Options

### Appearance Customization

#### Colors

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Content color (labels and indicators)
hud.contentColor = [UIColor whiteColor];

// Bezel background color
hud.bezelView.backgroundColor = [UIColor blackColor];
hud.bezelView.alpha = 0.8;

// Background view color
hud.backgroundView.color = [UIColor colorWithWhite:0.0 alpha:0.5];
```

#### Background Styles

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Solid color background
hud.bezelView.style = LWHUDBackgroundStyleSolidColor;
hud.bezelView.backgroundColor = [UIColor blackColor];

// Blur effect background
hud.bezelView.style = LWHUDBackgroundStyleBlur;
hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark; // or UIBlurEffectStyleLight
```

#### Animation Types

LWHUD provides four animation styles to customize how the HUD appears and disappears:

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Fade animation (default)
// Smoothly transitions opacity from 0 to 1 when appearing, and 1 to 0 when disappearing
hud.animationType = LWHUDAnimationFade;

// Zoom animation (bidirectional)
// Zooms in when appearing (scale 0.5 to 1.0 + opacity)
// Zooms out when disappearing (scale 1.0 to 1.3 + opacity)
hud.animationType = LWHUDAnimationZoom;

// Zoom In animation
// Always zooms in (scale 0.5 to 1.0 + opacity)
// Used for both appearing and disappearing
hud.animationType = LWHUDAnimationZoomIn;

// Zoom Out animation
// Always zooms out (scale 1.0 to 1.3 + opacity)
// Used for both appearing and disappearing
hud.animationType = LWHUDAnimationZoomOut;
```

**Animation Characteristics:**
- **Fade**: Subtle, non-distracting, best for frequent updates
- **Zoom**: Draws attention, natural feel (zoom in when showing, out when hiding)
- **Zoom In**: Emphasizes appearance, good for important messages
- **Zoom Out**: Dramatic exit, good for completion states

#### Position and Size

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Offset from center
hud.offset = CGPointMake(0, -50); // Move up by 50 points

// Move to bottom edge
hud.offset = CGPointMake(0, LWProgressMaxOffset);

// Margins (space between HUD edge and content)
hud.margin = 20.0;

// Minimum size
hud.minSize = CGSizeMake(150, 100);

// Force square dimensions
hud.square = YES;
```

#### Label Customization

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Main label
hud.label.text = @"Loading...";
hud.label.font = [UIFont boldSystemFontOfSize:16];
hud.label.textColor = [UIColor whiteColor];

// Details label
hud.detailsLabel.text = @"Please wait";
hud.detailsLabel.font = [UIFont systemFontOfSize:12];
hud.detailsLabel.textColor = [UIColor lightGrayColor];
```

#### Button

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.label.text = @"Loading...";

// Add a cancel button
[hud.button setTitle:@"Cancel" forState:UIControlStateNormal];
[hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
```

#### Motion Effects

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Enable/disable motion effects (parallax)
hud.defaultMotionEffectsEnabled = YES; // Default is YES
```

### Progress View Customization

#### Round Progress View (Determinate & Annular)

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];

// Pie chart style (fills from center)
hud.mode = LWHUDModeDeterminate;
hud.progress = 0.5; // 50%

// OR Ring style (fills along perimeter)
hud.mode = LWHUDModeAnnularDeterminate;
hud.progress = 0.75; // 75%

// The progress view is automatically created and styled
// Colors are inherited from contentColor by default
// But you can customize individual views if needed by accessing the indicator view
```

#### Bar Progress View

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeDeterminateHorizontalBar;
hud.label.text = @"Uploading...";

// Update progress (0.0 to 1.0)
hud.progress = 0.33; // 33%

// The bar automatically inherits contentColor
// Bar dimensions adjust based on available space
```

#### Progress Value Management

```objective-c
// Set initial progress
hud.progress = 0.0;

// Update progress (always on main thread)
dispatch_async(dispatch_get_main_queue(), ^{
    hud.progress = 0.5; // 50%
});

// Progress value is clamped between 0.0 and 1.0
hud.progress = 1.5; // Will be set to 1.0
hud.progress = -0.5; // Will be set to 0.0
```

## API Reference

### Class Methods

#### Creating and Managing HUDs

```objective-c
/**
 * Creates a new HUD, adds it to the provided view and shows it
 * @param view The view to add the HUD to
 * @param animated Whether to animate the HUD appearance
 * @return A reference to the created HUD
 */
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 * Finds and hides the top-most HUD in the view
 * @param view The view to search for HUD
 * @param animated Whether to animate the HUD disappearance
 * @return YES if a HUD was found and hidden, NO otherwise
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 * Finds and returns the top-most HUD in the view
 * @param view The view to search
 * @return A reference to the HUD, or nil if not found
 */
+ (nullable LWHUD *)HUDForView:(UIView *)view;
```

### Instance Methods

#### Initialization

```objective-c
/**
 * Initializes a HUD with the view's bounds
 * @param view The view that provides the bounds
 */
- (instancetype)initWithView:(UIView *)view;

/**
 * Initializes a HUD with a specific frame
 * @param frame The frame for the HUD
 */
- (instancetype)initWithFrame:(CGRect)frame;
```

#### Showing and Hiding

```objective-c
/**
 * Shows the HUD
 * @param animated Whether to animate the appearance
 */
- (void)showAnimated:(BOOL)animated;

/**
 * Hides the HUD
 * @param animated Whether to animate the disappearance
 */
- (void)hideAnimated:(BOOL)animated;

/**
 * Hides the HUD after a delay
 * @param animated Whether to animate the disappearance
 * @param delay Delay in seconds before hiding
 */
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
```

### Properties

#### Display Mode

```objective-c
@property (assign, nonatomic) LWHUDMode mode;
```

**Available Modes:**
- `LWHUDModeIndeterminate` - UIActivityIndicatorView (default)
- `LWHUDModeDeterminate` - Pie chart style progress
- `LWHUDModeDeterminateHorizontalBar` - Horizontal progress bar
- `LWHUDModeAnnularDeterminate` - Ring-shaped progress
- `LWHUDModeCustomView` - Custom view
- `LWHUDModeText` - Text only

#### Progress

```objective-c
// Progress value (0.0 to 1.0)
@property (assign, nonatomic) float progress;

// NSProgress object for automatic progress updates
@property (strong, nonatomic, nullable) NSProgress *progressObject;
```

#### Appearance

```objective-c
// Content color (labels and indicators)
@property (strong, nonatomic, nullable) UIColor *contentColor;

// Animation type
@property (assign, nonatomic) LWHUDAnimation animationType;

// Position offset from center
@property (assign, nonatomic) CGPoint offset;

// Margin around content
@property (assign, nonatomic) CGFloat margin;

// Minimum bezel size
@property (assign, nonatomic) CGSize minSize;

// Force square dimensions
@property (assign, nonatomic, getter = isSquare) BOOL square;

// Enable motion effects
@property (assign, nonatomic, getter=areDefaultMotionEffectsEnabled) BOOL defaultMotionEffectsEnabled;
```

#### Views

```objective-c
// Bezel view (contains labels and indicator)
@property (strong, nonatomic, readonly) LWBackgroundView *bezelView;

// Background view (covers entire HUD area)
@property (strong, nonatomic, readonly) LWBackgroundView *backgroundView;

// Custom view (when mode is LWHUDModeCustomView)
@property (strong, nonatomic, nullable) UIView *customView;

// Main label
@property (strong, nonatomic, readonly) UILabel *label;

// Details label
@property (strong, nonatomic, readonly) UILabel *detailsLabel;

// Button
@property (strong, nonatomic, readonly) UIButton *button;
```

#### Behavior

```objective-c
// Remove from superview when hidden
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;

// Grace period before showing (prevents showing for quick operations)
@property (assign, nonatomic) NSTimeInterval graceTime;

// Minimum show time (prevents flickering)
@property (assign, nonatomic) NSTimeInterval minShowTime;

// Delegate for callbacks
@property (weak, nonatomic) id<LWHUDDelegate> delegate;

// Completion block called when HUD is hidden
@property (copy, nullable) LWHUDCompletionBlock completionBlock;
```

### Delegate Protocol

```objective-c
@protocol LWHUDDelegate <NSObject>

@optional

/**
 * Called after the HUD was fully hidden from the screen
 * @param hud The HUD that was hidden
 */
- (void)hudWasHidden:(LWHUD *)hud;

@end
```

### Enumerations

#### LWHUDMode

```objective-c
typedef NS_ENUM(NSInteger, LWHUDMode) {
    LWHUDModeIndeterminate,              // UIActivityIndicatorView
    LWHUDModeDeterminate,                // Pie chart progress
    LWHUDModeDeterminateHorizontalBar,   // Horizontal bar
    LWHUDModeAnnularDeterminate,         // Ring-shaped progress
    LWHUDModeCustomView,                 // Custom view
    LWHUDModeText                        // Text only
};
```

#### LWHUDAnimation

```objective-c
typedef NS_ENUM(NSInteger, LWHUDAnimation) {
    LWHUDAnimationFade,      // Fade in/out
    LWHUDAnimationZoom,      // Zoom in when appearing, out when disappearing
    LWHUDAnimationZoomOut,   // Zoom out style
    LWHUDAnimationZoomIn     // Zoom in style
};
```

#### LWHUDBackgroundStyle

```objective-c
typedef NS_ENUM(NSInteger, LWHUDBackgroundStyle) {
    LWHUDBackgroundStyleSolidColor,  // Solid color
    LWHUDBackgroundStyleBlur         // Blur effect
};
```

### Type Definitions

```objective-c
// Completion block
typedef void (^LWHUDCompletionBlock)(void);

// Maximum offset constant
extern CGFloat const LWProgressMaxOffset;
```

## Requirements

| Component | Minimum Version |
|-----------|----------------|
| iOS | 9.0+ |
| Xcode | 8.0+ |
| Language | Objective-C / Swift |

## Installation

LWHUD can be integrated into your project using several methods:

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. To install LWHUD via CocoaPods:

1. Add the following line to your `Podfile`:

```ruby
pod 'LWHUD'
```

2. Run the installation command:

```bash
pod install
```

3. Import in your code:

```objective-c
#import <LWHUD/LWHUD.h>
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager. To integrate LWHUD:

1. Add to your `Cartfile`:

```ruby
github "luowei/LWHUD"
```

2. Run:

```bash
carthage update --platform iOS
```

3. Drag the built framework from `Carthage/Build/iOS/LWHUD.framework` into your Xcode project

### Manual Installation

For manual integration:

1. Download or clone the repository
2. Add all files from the `LWHUD/Classes` folder to your Xcode project
3. Import the header file where needed:

```objective-c
#import "LWHUD.h"
```

## Swift Usage

LWHUD works seamlessly with Swift. Here are some examples:

### Basic Usage in Swift

```swift
import LWHUD

// Show loading indicator
let hud = LWHUD.showAdded(to: self.view, animated: true)

// Hide when done
hud.hide(animated: true)
```

### Text Message in Swift

```swift
let hud = LWHUD.showAdded(to: self.view, animated: true)
hud.mode = .text
hud.label.text = "Success!"
hud.hide(animated: true, afterDelay: 2.0)
```

### Progress in Swift

```swift
let hud = LWHUD.showAdded(to: self.view, animated: true)
hud.mode = .annularDeterminate
hud.label.text = "Loading..."
hud.progress = 0.5
```

### Customization in Swift

```swift
let hud = LWHUD.showAdded(to: self.view, animated: true)
hud.contentColor = .white
hud.bezelView.style = .solidColor
hud.bezelView.backgroundColor = .black
hud.bezelView.alpha = 0.8
hud.label.text = "Processing..."
```

### Helper Extension (Swift)

```swift
extension LWHUD {
    static func showToast(message: String, in view: UIView, duration: TimeInterval = 2.0) {
        let hud = LWHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: duration)
    }

    static func showLoading(in view: UIView, message: String? = nil) -> LWHUD {
        let hud = LWHUD.showAdded(to: view, animated: true)
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        return hud
    }
}

// Usage
LWHUD.showToast(message: "Operation successful!", in: self.view)

let hud = LWHUD.showLoading(in: self.view, message: "Please wait...")
// Later...
hud.hide(animated: true)
```

## Threading

LWHUD is a UI class and should only be accessed on the main thread. When performing long-running tasks, make sure to update the HUD on the main thread:

```objective-c
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // Long running task here

    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
});
```

In Swift:
```swift
DispatchQueue.global(qos: .default).async {
    // Long running task here

    DispatchQueue.main.async {
        hud.hide(animated: true)
    }
}
```

## Best Practices

Follow these best practices to get the most out of LWHUD:

### Memory Management

**Always set `removeFromSuperViewOnHide = YES`** for temporary HUDs:

```objective-c
hud.removeFromSuperViewOnHide = YES;
```

This ensures the HUD is removed from the view hierarchy and deallocated when hidden, preventing memory leaks.

### Timing Optimization

**Use grace time** to prevent flickering on quick operations:

```objective-c
hud.graceTime = 0.5; // Only show if task takes longer than 0.5 seconds
```

**Use minimum show time** to ensure readability:

```objective-c
hud.minShowTime = 1.0; // Always show for at least 1 second
```

### HUD Management

**Store references** when you need to update or hide programmatically:

```objective-c
@property (strong, nonatomic) LWHUD *progressHUD;

// Show
self.progressHUD = [LWHUD showHUDAddedTo:self.view animated:YES];

// Update progress
self.progressHUD.progress = 0.5;

// Hide
[self.progressHUD hideAnimated:YES];
```

**Avoid multiple HUDs** on the same view:

```objective-c
// Check for existing HUD
LWHUD *existingHUD = [LWHUD HUDForView:self.view];
if (!existingHUD) {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    // Configure HUD...
}
```

### Mode Selection

**Choose the right mode** for each scenario:

| Scenario | Recommended Mode |
|----------|------------------|
| Unknown duration | `LWHUDModeIndeterminate` |
| Trackable progress | `LWHUDModeAnnularDeterminate` or `LWHUDModeDeterminate` |
| Quick messages | `LWHUDModeText` |
| Success/Error feedback | `LWHUDModeCustomView` with icon |

### Threading

**Always update UI on the main thread:**

```objective-c
dispatch_async(dispatch_get_main_queue(), ^{
    hud.progress = newProgress;
    // or
    [hud hideAnimated:YES];
});
```

### Accessibility

**Provide meaningful labels** for better accessibility:

```objective-c
hud.label.text = @"Loading data...";
hud.detailsLabel.text = @"Please wait";
```

## Common Use Cases

### Network Request with Progress

```objective-c
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeAnnularDeterminate;
hud.label.text = @"Downloading...";

NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url
    progressBlock:^(NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress.fractionCompleted;
        });
    }
    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
```

### Quick Success/Error Messages

```objective-c
- (void)showSuccess:(NSString *)message {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = LWHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

- (void)showError:(NSString *)message {
    LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = LWHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}
```

## Troubleshooting

### HUD not showing
- Make sure you're calling the methods on the main thread
- Verify the view is added to the view hierarchy
- Check if the view has a valid frame
- Check if `graceTime` is set and task completes before grace period

### HUD not disappearing
- Ensure you call `hideAnimated:` or set a delay with `hideAnimated:afterDelay:`
- Check if you have multiple HUDs added to the same view
- Verify you're not blocking the main thread
- Check if `minShowTime` is set and hasn't elapsed yet

### Progress not updating
- Make sure you update the `progress` property on the main thread
- Verify the mode is set to a progress mode (Determinate, DeterminateHorizontalBar, or AnnularDeterminate)
- Ensure progress value is between 0.0 and 1.0
- Check if NSProgress object is properly connected

### Custom view not displaying
- Verify the custom view implements `intrinsicContentSize`
- Ensure the view has a non-zero size
- Check that mode is set to `LWHUDModeCustomView`

## Quick Reference

### Common Patterns

```objective-c
// Quick toast message
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeText;
hud.label.text = @"Saved!";
hud.removeFromSuperViewOnHide = YES;
[hud hideAnimated:YES afterDelay:2.0];

// Loading with grace time
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.graceTime = 0.5; // Only show if task takes longer than 0.5s
hud.minShowTime = 1.0; // Show for at least 1 second
hud.removeFromSuperViewOnHide = YES;

// Progress with NSProgress
NSProgress *progress = [NSProgress progressWithTotalUnitCount:100];
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeAnnularDeterminate;
hud.progressObject = progress; // Auto-updates
hud.removeFromSuperViewOnHide = YES;

// Success with custom icon
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.mode = LWHUDModeCustomView;
UIImage *image = [[UIImage imageNamed:@"checkmark"]
                  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
hud.customView = [[UIImageView alloc] initWithImage:image];
hud.label.text = @"Complete!";
hud.removeFromSuperViewOnHide = YES;
[hud hideAnimated:YES afterDelay:2.0];

// Dark themed HUD
LWHUD *hud = [LWHUD showHUDAddedTo:self.view animated:YES];
hud.contentColor = [UIColor whiteColor];
hud.bezelView.style = LWHUDBackgroundStyleSolidColor;
hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

// Window-level HUD (covers entire app)
UIWindow *window = [UIApplication sharedApplication].keyWindow;
LWHUD *hud = [LWHUD showHUDAddedTo:window animated:YES];
hud.removeFromSuperViewOnHide = YES;
```

### Mode Quick Reference

| Mode | Constant | Best For | Progress |
|------|----------|----------|----------|
| Spinner | `LWHUDModeIndeterminate` | Unknown duration | No |
| Pie Chart | `LWHUDModeDeterminate` | Circular progress | Yes (0.0-1.0) |
| Bar | `LWHUDModeDeterminateHorizontalBar` | Linear progress | Yes (0.0-1.0) |
| Ring | `LWHUDModeAnnularDeterminate` | Modern progress | Yes (0.0-1.0) |
| Custom | `LWHUDModeCustomView` | Icons/Images | No |
| Text | `LWHUDModeText` | Toast messages | No |

### Animation Quick Reference

| Animation | Constant | Behavior |
|-----------|----------|----------|
| Fade | `LWHUDAnimationFade` | Smooth opacity transition |
| Zoom | `LWHUDAnimationZoom` | Zoom in on show, out on hide |
| Zoom In | `LWHUDAnimationZoomIn` | Always zoom in |
| Zoom Out | `LWHUDAnimationZoomOut` | Always zoom out |

### Property Quick Reference

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `mode` | `LWHUDMode` | `Indeterminate` | Display mode |
| `progress` | `float` | `0.0` | Progress value (0.0-1.0) |
| `animationType` | `LWHUDAnimation` | `Fade` | Animation style |
| `graceTime` | `NSTimeInterval` | `0.0` | Delay before showing |
| `minShowTime` | `NSTimeInterval` | `0.0` | Minimum display time |
| `removeFromSuperViewOnHide` | `BOOL` | `NO` | Auto-remove when hidden |
| `offset` | `CGPoint` | `(0,0)` | Position offset from center |
| `margin` | `CGFloat` | `20.0` | Content padding |
| `square` | `BOOL` | `NO` | Force square dimensions |
| `defaultMotionEffectsEnabled` | `BOOL` | `YES` | Enable parallax |

## Author

**luowei**
- Email: luowei@wodedata.com
- GitHub: [@luowei](https://github.com/luowei)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

LWHUD is available under the MIT License. This means you can use it freely in your projects, both personal and commercial.

```
MIT License

Copyright (c) 2024 luowei

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

See the [LICENSE](LICENSE) file for the complete license text.

## Credits

LWHUD is based on the excellent [MBProgressHUD](https://github.com/jdg/MBProgressHUD) library by Matej Bukovinski, with custom modifications and enhancements for SDK integration.

### Acknowledgments

- **MBProgressHUD** - Original library that inspired LWHUD
- **Matej Bukovinski** - Creator of MBProgressHUD
- All contributors and users who have provided feedback and improvements

## Support

If you encounter any issues or have questions:

- Check the [Troubleshooting](#troubleshooting) section
- Browse [existing issues](https://github.com/luowei/LWHUD/issues)
- Open a [new issue](https://github.com/luowei/LWHUD/issues/new) if needed

## Links

- [GitHub Repository](https://github.com/luowei/LWHUD)
- [CocoaPods Page](https://cocoapods.org/pods/LWHUD)
- [Issue Tracker](https://github.com/luowei/LWHUD/issues)
- [中文文档](./README_ZH.md)

---

Made with ❤️ by the iOS community
