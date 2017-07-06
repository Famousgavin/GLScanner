//
//  GLScannerBorder.h
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLScannerBorder : UIView

/**  拿取资源包图片  */
+ (UIImage *)imageResourceWithName:(NSString *)imageName;

/**  开始扫描动画  */
- (void)startScannerAnimating;
/**  停止扫描动画  */
- (void)stopScannerAnimating;

@end
