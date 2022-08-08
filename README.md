# LWHUD

[![CI Status](https://img.shields.io/travis/luowei/LWHUD.svg?style=flat)](https://travis-ci.org/luowei/LWHUD)
[![Version](https://img.shields.io/cocoapods/v/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)
[![License](https://img.shields.io/cocoapods/l/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)
[![Platform](https://img.shields.io/cocoapods/p/LWHUD.svg?style=flat)](https://cocoapods.org/pods/LWHUD)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C
+(void)showHUDWithMessage:(NSString *)message{
    if(!message || message.length == 0){
        return;
    }
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = message;
    hud.mode = LWHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}
+(void)showHUDWithDetailMessage:(NSString *)message {
    if(!message || message.length == 0){
        return;
    }
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabel.text = message;
    hud.mode = LWHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+(LWHUD *)showHUDWithMessage:(NSString *)message mode:(LWHUDMode)mode {
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = message;
    hud.mode = mode;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showHUDLoading {
    LWHUD *hud = [LWHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = LWHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
}

+(void)hideHUDLoading {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    for(UIView *view in keywindow.subviews){
        if([view isKindOfClass:[LWHUD class]]){
            [(LWHUD *)view hideAnimated:NO];
            [view removeFromSuperview];
        }
    }
}

```

## Requirements

## Installation

LWHUD is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWHUD'
```

**Carthage**
```ruby
github "luowei/LWHUD"
```


## Author

luowei, luowei@wodedata.com

## License

LWHUD is available under the MIT license. See the LICENSE file for more info.
