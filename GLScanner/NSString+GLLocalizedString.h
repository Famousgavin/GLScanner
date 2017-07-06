//
//  NSString+GLLocalizedString.h
//  GLScannerDemo
//
//  Created by Gavin on 2017/7/5.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GLLocalizedString)

/**
 *  根据用户设置的语言 通过键读取值
 *
 *  @return 文本
 */
- (NSString *)customLocalizedString;

/**
 *  写入用户设置语言
 *
 *  @param languageCode 用户设置语言
 */
+ (void )setUserLanguageCode:(NSString *)languageCode;

/**
 *  获取用户设置语言
 *
 *  @return self
 */
+ (NSString * )getUserSettingLanguageCode;


@end
