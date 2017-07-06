//
//  GLScannerViewController.h
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLScannerViewController : UIViewController


/**
 实例化扫描控制器

 @param completion 完成回到
 @param error 错误回调
 @return 扫描控制器
 */
+ (instancetype)scannerViewWithCompletion:(void (^)(NSString *value, BOOL *dismissAnimation))completion error:(void (^)(GLScannerViewController *rootScannerView, NSError *error))error;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *barBackgroundTintColor;

@property (nonatomic, strong) UIImage *barBackgroundImage;
/**  bar透明度 0.0~1.0  */
@property (nonatomic, assign) CGFloat barAlphe;
/**  控制器view背景颜色  */
@property (nonatomic, strong) UIColor *viewBackgroundColor;
/**  扫描框外遮挡颜色  */
@property (nonatomic, strong) UIColor *coverColor;

/**  leftBarButtonItem 自定义返回/或者修改button属性  */
@property (nonatomic, copy) UIButton *(^leftBarButtonItem)(UIButton *leftButton);

/**  rightBarButtonItem 自定义返回/或者修改button属性/默认相册  */
@property (nonatomic, copy) UIButton *(^rightBarButtonItem)(UIButton *rightButton);

/**  是否隐藏右侧Item  */
@property (nonatomic, assign, getter=isHiddenRightBarButtonItem) BOOL hiddenRightBarButtonItem;
/**  是否隐藏提示label  */
@property (nonatomic, assign, getter=isHiddenTipLabel) BOOL hiddenTipLabel;
/**  设置item 字体大小  */
@property (nonatomic, assign) CGFloat barFontSize;

/**  文本和提示内容  */
@property (nonatomic, strong) NSMutableDictionary *textStringDic;
@property (nonatomic, strong) NSString *languageCode;


@end
