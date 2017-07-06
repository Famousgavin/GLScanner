//
//  UIImage+GLAdd.h
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GLAdd)


/**
 指定图片大小和显示类型返回

 @param size 图片需求的大小
 @param contentMode 类型
 @return 完成图片
 */
- (UIImage *)imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

@end
