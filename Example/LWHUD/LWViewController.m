//
//  LWViewController.m
//  LWHUD
//
//  Created by luowei on 12/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <LWHUD/LWHUD.h>
#import "LWViewController.h"

@interface LWViewController ()

@property(nonatomic) int hudCount;
@property(nonatomic, strong) LWHUD *loadingHUD;
@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showHUD {
    [self showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), dispatch_get_main_queue(), ^{
        [self hideLoading];

        [LWViewController showToastText:@"开始加载进度" duration:1.5];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.5), dispatch_get_main_queue(), ^{
            [self showLoadingWithProgress:0.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
                [self hideLoading];
                
                [LWViewController showToastText:@"进度加载完毕" duration:1.5];
            });
        });

    });
}


#pragma mark - Loading & HUD

- (void)showLoading {
    if (!self.loadingHUD || self.loadingHUD.hidden) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.loadingHUD = [LWHUD showHUDAddedTo:window animated:YES];
        self.loadingHUD.bezelView.alpha = 0.6;
//        self.loadingHUD.activityIndicatorColor = [UIColor whiteColor];
        self.loadingHUD.contentColor = [UIColor whiteColor];
        self.loadingHUD.bezelView.style = LWHUDBackgroundStyleSolidColor;
        self.loadingHUD.bezelView.backgroundColor = [UIColor blackColor];
        self.hudCount = 1;
    } else {
        self.hudCount++;
    }
    self.loadingHUD.removeFromSuperViewOnHide = YES;
    self.loadingHUD.mode = LWHUDModeIndeterminate;
}

- (void)showLoadingWithProgress:(float)progress {
    if (!self.loadingHUD || self.loadingHUD.hidden) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.loadingHUD = [LWHUD showHUDAddedTo:window animated:YES];
        self.loadingHUD.bezelView.alpha = 0.6;
        self.hudCount = 1;
    } else {
        self.hudCount++;
    }
    self.loadingHUD.removeFromSuperViewOnHide = YES;
    self.loadingHUD.mode = LWHUDModeAnnularDeterminate;
    self.loadingHUD.progress = progress;
}

- (void)hideLoading {
    if (--self.hudCount == 0) {
        [self.loadingHUD hideAnimated:YES];
        [self.loadingHUD removeFromSuperview];
        self.loadingHUD = nil;
//        [self.loadingHUD hideAnimated:YES afterDelay:20];
    }
}

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

@end
