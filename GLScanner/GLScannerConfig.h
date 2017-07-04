//
//  GLScannerConfig.h
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//



/**  日志输入  */
#define GLLog(...)\
{\
NSString *string = [NSString stringWithFormat:__VA_ARGS__];\
NSLog(@"\n===========================\n===========================\n=== GLCodeScanner Log ===\n提示信息:%@\n所在方法:%s\n所在行数:%d\n===========================\n===========================", string, __func__, __LINE__);\
}
