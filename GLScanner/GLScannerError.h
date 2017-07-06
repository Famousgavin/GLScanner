//
//  GLScannerError.h
//  GLScanner
//
//  Created by Gavin on 2017/6/29.
//  Copyright © 2017年 Gavin. All rights reserved.
//

#ifndef GLScannerError_H
#define GLScannerError_H

#import <UIKit/UIKit.h>


UIKIT_EXTERN NSString *const GLSimpleScannerErrorDomain;

typedef NS_ENUM(NSInteger, GLSimpleScannerErrorCode) {
    /**   相机权限  */
    GLSimpleScannerErrorCodeCameraPermission     = 0x10,
    /**   相机不可用  */
    GLSimpleScannerErrorCodeCameraNotAvailable   = 0x11,
    
    /**   相册权限  */
    GLSimpleScannerErrorCodePhotoPermission      = 0x20,
    /**   相册不可用  */
    GLSimpleScannerErrorCodePhotoNotAvailable    = 0x21,
};



#endif /* GLScannerError_H */

