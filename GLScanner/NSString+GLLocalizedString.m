//
//  NSString+GLLocalizedString.m
//  GLScannerDemo
//
//  Created by Gavin on 2017/7/5.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#import "NSString+GLLocalizedString.h"

@implementation NSString (GLLocalizedString)

- (NSString *)customLocalizedString {
    NSString *text = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString getUserSettingLanguageCode] ofType:@"lproj"]] localizedStringForKey:(self) value:nil table:@"ScannerLocalizable"];
    return text;
}

#pragma mark - 设置语言 获取与写入
#pragma mark 写入用户设置语言
+ (void )setUserLanguageCode:(NSString *)languageCode {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:languageCode forKey:@"GLScannerLanguageSetting"];
    [userDefaults synchronize];
}

#pragma mark 获取用户设置语言
+ (NSString *)getUserSettingLanguageCode {
    NSString *language =  [[NSUserDefaults standardUserDefaults] objectForKey:@"GLScannerLanguageSetting"];
    if (language.length == 0) {
        language = [NSString getCurrentLanguage];
        [NSString setUserLanguageCode:language];
    }
    return language;
}

#pragma mark  获取系统的语言
+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    // [[NSLocale currentLocale] localeIdentifier];
    if ([currentLanguage isEqualToString:@"zh-Hant"] || [currentLanguage isEqualToString:@"zh-HK"]) {
        //繁体中文
        return @"zh-Hant";
    }
    
    if ([currentLanguage hasPrefix:@"zh-"]) {
        //简体中文
        return @"zh-Hans";
    }
    
//    if ([currentLanguage isEqualToString:@"ru"]) {
//        //俄语
//        return @"ru";
//    }
//    
//    if ([currentLanguage hasPrefix:@"fr"]){
//        //法语
//        return @"fr";
//    }
//
//    if ([currentLanguage hasPrefix:@"de"]){
//        //German 德语
//        return @"de";
//    }
//    
//    if([currentLanguage hasPrefix:@"it"]){
//        //italian 意大利
//        return @"it";
//    }
//    
//    if([currentLanguage hasPrefix:@"es"]){
//        //Spanish 西班牙语
//        return @"es";
//    }
//    
//    if ([currentLanguage isEqualToString:@"ja"]){
//        //日语
//        return @"ja";
//    }
//    
//    if ([currentLanguage isEqualToString:@"ko"]) {
//        //韩语
//        return @"ko";
//    }
//    
//    if ([[currentLanguage substringToIndex:2] isEqualToString:@"pt"]) {
//        //葡萄牙-pt （巴西）  pt-PT （葡萄牙）
//        return @"pt";
//    }
    
    //英语 - 默认
    return @"en";
}

@end
