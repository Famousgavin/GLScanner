//
//  GLScannerError.h
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/29.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#ifndef GLScannerError_H
#define GLScannerError_H

#import <UIKit/UIKit.h>


UIKIT_EXTERN NSString *const GLSimpleScannerErrorDomain;

typedef NS_ENUM(NSInteger, GLSimpleScannerErrorCode) {
    LLSimpleCameraErrorCodeCameraPermission = 10,
    LLSimpleCameraErrorCodeMicrophonePermission = 11,
    LLSimpleCameraErrorCodeSession = 12,
    LLSimpleCameraErrorCodeVideoNotEnabled = 13
};



#endif /* GLScannerError_H */

