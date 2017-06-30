//
//  GLScannerController.h
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//


#import "GLScannerViewController.h"
#import <UIKit/UIKit.h>

@interface GLScannerController : UINavigationController


/**
 实例化扫描导航控制器

 @param completion 完成回调
 @return 扫描导航控制器
 */
+ (instancetype)scannerWithInitRootViewBlock:(void (^)(GLScannerViewController *rootScannerView))rootViewBlock completion:(void (^)(NSString *stringValue))completion;

- (void)setTitleColor:(UIColor *)titleColor tintColor:(UIColor *)tintColor;



@end
