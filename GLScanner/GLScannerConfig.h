//
//  GLScannerConfig.h
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//


/**  日志输出  */
#ifdef DEBUG
#define GLLog(...){\
NSString *string = [NSString stringWithFormat:__VA_ARGS__];\
NSLog(@"\n===========================\n===========================\n=== GLCodeScanner Log ===\n提示信息:%@\n所在方法:%s\n所在行数:%d\n===========================\n===========================", string, __func__, __LINE__);\
}
#else
#define GLLog(...)
#endif

/**  过期提醒  */
#define GLScannerDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)


/**  构建错误  */
#define GLScannerBuildError(error, msg) \
if (error) *error = [NSError errorWithDomain:msg code:250 userInfo:nil]

/**  回调主线程  */
#define GLScannerMain(parameter)  dispatch_async(dispatch_get_main_queue(), parameter)
/**  多少秒钟后调用  */
#define GLScannerAfter(TIME_S, BLOCK)   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIME_S * NSEC_PER_SEC)), dispatch_get_main_queue(), BLOCK)

/**  RGB颜色  */
#define GLScannerColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/**  默认title颜色  */
#define GLScannerDefaultTitleColor [UIColor whiteColor]
/**  默认Tint颜色  */
#define GLScannerDefaultTintColor [UIColor greenColor]
/**  默认View背景颜色  */
#define GLScannerDefaultViewBackgroundColor [UIColor darkGrayColor]
/**  默认Bar tint背景颜色  */
#define GLScannerDefaultBarBackgroundTintColor [UIColor colorWithWhite:0.1 alpha:1.0]
/**  默认扫描框遮挡背景颜色  */
#define GLScannerDefaultCoverColor [UIColor colorWithWhite:0.0 alpha:0.6];;



#import <UIKit/UIKit.h>

/**  支持的多语言  */
/**  英语  */
UIKIT_EXTERN NSString *const GLScannerLocalizedStringEn;
/**  繁体中文  */
UIKIT_EXTERN NSString *const GLScannerLocalizedStringZh_Hant;
/**  简体中文  */
UIKIT_EXTERN NSString *const GLScannerLocalizedStringZh_Hans;


/**  文本key  */
UIKIT_EXTERN NSString *const GLScannerBarTitle;
UIKIT_EXTERN NSString *const GLScannerBarLeftTitle;
UIKIT_EXTERN NSString *const GLScannerBarRightTitle;

UIKIT_EXTERN NSString *const GLScannerDefaultTipContent;

UIKIT_EXTERN NSString *const GLScannerTipCameraNotPermission;
UIKIT_EXTERN NSString *const GLScannerTipCameraNotAvailable;

UIKIT_EXTERN NSString *const GLScannerTipPhotoNotPermission;
UIKIT_EXTERN NSString *const GLScannerTipPhotoNotAvailable;

UIKIT_EXTERN NSString *const GLScannerTipImageNotFoundQrCode;





