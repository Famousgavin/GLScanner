//
//  GLScannerController.m
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import "GLScannerConfig.h"
#import "GLScannerViewController.h"
#import "GLScannerController.h"

@interface GLScannerController ()


@end

@implementation GLScannerController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        
        [self initUI];
        [self initBlock];
        
        if (self.viewControllers.count == 0) {
            //控制器初始化
            GLScannerViewController *scannerViewController = [GLScannerViewController scannerViewWithCompletion:nil];
            [self pushViewController:scannerViewController animated:false];
        }
    }
    return self;
}

+ (instancetype)scannerWithInitRootViewBlock:(void (^)(GLScannerViewController *rootScannerView))rootViewBlock completion:(void (^)(NSString *stringValue))completion {
    
    //控制器初始化
    GLScannerViewController *scannerViewController = [GLScannerViewController scannerViewWithCompletion:completion];
    //导航控制器初始化
    GLScannerController *scannerController = [[GLScannerController alloc] initWithRootViewController:scannerViewController];
    
    [scannerController initUI];
    [scannerController initBlock];
    
    if (rootViewBlock) {
        rootViewBlock(scannerViewController);
    }
    
    return scannerController;
}


- (void)initUI {
    [self setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
}

- (void)initBlock {

//    if ([self.viewControllers.firstObject isKindOfClass:[GLScannerViewController class]]) {
//        GLScannerViewController *rootScannerViewController = (GLScannerViewController *)self.viewControllers.firstObject;
//        
//        //失败回调
//        rootScannerViewController.onError = ^(NSError *error) {
//            if (self.onError) {
//                self.onError(error);
//            }
//        };
//        
//        //完成回调
//        rootScannerViewController.completion = ^(id value) {
//            if (self.completion) {
//                self.completion(value);
//            }
//        };
//    }

}

- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor {
    
//    if ([self.viewControllers.firstObject isKindOfClass:[GLScannerViewController class]]) {
//        GLScannerViewController *rootScannerViewController = (GLScannerViewController *)self.viewControllers.firstObject;
//    }
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor}];
    self.navigationBar.tintColor = tintColor;
}

#pragma mark - 重写
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
