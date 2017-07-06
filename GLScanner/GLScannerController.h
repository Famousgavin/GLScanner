//
//  GLScannerController.h
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//


#import "GLScannerViewController.h"
#import <UIKit/UIKit.h>

@interface GLScannerController : UINavigationController

/**
 实例化扫描导航控制器

 @param rootView 扫描控制器初始化配置
 @param completion 完成回调
 @param error 错误回调
 @return 扫描导航控制器
 */
+ (instancetype)scannerWithInitRootView:(void (^)(GLScannerViewController *rootScannerView))rootView completion:(void (^)(NSString *value, BOOL *dismissAnimation))completion error:(void (^)(GLScannerViewController *rootScannerView, NSError *error))error;


@end
