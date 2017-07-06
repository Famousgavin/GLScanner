//
//  GLScannerController.m
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import "GLScannerViewController.h"
#import "GLScannerController.h"

@interface GLScannerController ()


@end

@implementation GLScannerController

+ (instancetype)scannerWithInitRootView:(void (^)(GLScannerViewController *rootScannerView))rootView completion:(void (^)(NSString *value, BOOL *dismissAnimation))completion error:(void (^)(GLScannerViewController *rootScannerView, NSError *error))error {
    //控制器初始化
    GLScannerViewController *scannerViewController = [GLScannerViewController scannerViewWithCompletion:completion error:error];
    //导航控制器初始化
    GLScannerController *scannerController = [[GLScannerController alloc] initWithRootViewController:scannerViewController];
    if (rootView) {
        rootView(scannerViewController);
    }
    
    return scannerController;
}

#pragma mark - 重写
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
