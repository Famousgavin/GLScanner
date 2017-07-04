//
//  GLScannerViewController.h
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLScannerViewController : UIViewController

/**
 实例化扫描控制器

 @param completion 完成回调
 @return 扫描控制器
 */
+ (instancetype)scannerViewWithCompletion:(void (^)(NSString *stringValue))completion;

/**  完成回调 可能存在相册识别多个二维码  */
@property (nonatomic, copy) void (^completion)(id value);
/**  错误回调  */
@property (nonatomic, copy) void (^onError)(NSError *error);

@property (nonatomic, strong) UIColor *barTintColor;

@property (nonatomic, strong) NSString *titleString;

/**  leftBarButtonItem 自定义返回/或者修改button属性  */
@property (nonatomic, copy) UIButton *(^leftBarButtonItem)(UIButton *leftButton);

@property (nonatomic, strong) NSString *leftButtonTitle;

/**  rightBarButtonItem 自定义返回/或者修改button属性/默认相册  */
@property (nonatomic, copy) UIButton *(^rightBarButtonItem)(UIButton *rightButton);

@property (nonatomic, strong) NSString *rightButtonTitle;
/**  是否隐藏右侧Item  */
@property (nonatomic, assign, getter=isHiddenRightBarButtonItem) BOOL hiddenRightBarButtonItem;

@property (nonatomic, assign) CGFloat navigationItemFontSize;


@end
