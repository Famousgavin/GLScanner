//
//  GLQrScanner.h
//  Pods
//
//  Created by Gavin on 2017/7/4.
//
//

#import <UIKit/UIKit.h>

@interface GLQrScanner : NSObject
    
    
/**
 使用 string/icon 异步生成二维码图像
 
 @param string 二维码图像的字符串
 @param icon   图像/默认比例 0.2
 @param completion 完成回调
 */
+ (void)qrImageWithString:(NSString *)string icon:(UIImage *)icon completion:(void (^)(UIImage *image))completion;
    
    
/**  使用 string/头像 异步生成二维码图像，并且指定头像占二维码图像的比例
 *
 *   @param string     二维码图像的字符串
 *   @param icon       图像
 *   @param scale      icon占二维码图像的比例 0.0~1.0
 *   @param completion 完成回调
 */
+ (void)qrImageWithString:(NSString *)string icon:(UIImage *)icon scale:(CGFloat)scale completion:(void (^)(UIImage *))completion;
    
    
    
/**
 实例化扫描器，扫描预览窗口会添加到指定视图中
 
 @param inView 指定的视图
 @param scanFrame 扫描范围
 @param completion 完成回调
 @return 扫描器
 */
+ (instancetype)scanerWithInView:(UIView *)inView scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *stringValue))completion;
    
    
/**
 扫描图像
 
 @param image 包含二维码的图像
 @remark 目前只支持 64 位的 iOS 设备
 @param completion 完成回调
 */
+ (void)scaneImage:(UIImage *)image completion:(void (^)(NSArray *values))completion;
    
/**  扫描错误回调  */
@property (nonatomic, copy) void (^onError)(NSError *error);

/**  跳转本应用的设置  */
+ (BOOL)openSettingsURLString;
    
/**  开始扫描  */
- (void)startScan;
/**  停止扫描  */
- (void)stopScan;
    
/**  捕捉亮度值  */
- (void)addCaptureImage:(void(^)(NSInteger bright))brightBlock;
/**  设置手电筒开关  */
- (void)setTorch:(BOOL)isOpen;
    
/**  手电筒状态  */
@property (nonatomic, assign, readonly) BOOL isTorchOpen;
/**  最大检测次数 (默认20次/传小于0无限次数)  */
@property (nonatomic, assign) NSInteger maxDetectedCount;

    


@end
