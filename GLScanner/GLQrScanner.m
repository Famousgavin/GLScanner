//
//  GLQrScanner.m
//  Pods
//
//  Created by Gavin on 2017/7/4.
//
//

#import "GLQrScanner.h"
#import "GLScannerConfig.h"
#import "GLScannerViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface GLQrScanner() <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

/**  设备  */
@property (nonatomic, strong) AVCaptureDevice *device;
/**  拍摄会话  */
@property (nonatomic, strong) AVCaptureSession *session;
/**  图像捕捉输出  */
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
/**  输入  */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/**  输出  */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
/**  预览图层  */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

/**  父视图弱引用  */
@property (nonatomic, weak) UIView *inView;
/**  扫描范围  */
@property (nonatomic) CGRect scanFrame;
/**  完成回调  */
@property (nonatomic, copy) void (^completionCallBack)(NSString *);

@property (nonatomic, copy) void (^brightBlock)(NSInteger bright);


/**  当前检测计数  */
@property (nonatomic, assign) NSInteger currentDetectedCount;

@end

@implementation GLQrScanner
    
    
#pragma mark - 构造函数
+ (instancetype)scanerWithInView:(UIView *)inView scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *))completion {
    return [[self alloc] initWithInView:inView scanFrame:scanFrame completion:completion];
}
    
- (instancetype)initWithInView:(UIView *)inView scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *))completion {
    
    if ([super init]) {
        self.inView = inView;
        self.scanFrame = scanFrame;
        self.completionCallBack = completion;
        
        [self initSession];
    }
    return self;
}
    
#pragma mark 初始化扫描会话
- (void)initSession {
    
    //1.输入设备
    if (self.device == nil) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [self.device lockForConfiguration:nil];
        self.device.activeVideoMinFrameDuration = CMTimeMake(1, 5);
        [self.device unlockForConfiguration];
    }
    
    if (self.input == nil) {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    
    if (self.input == nil) {
        GLLog(@"创建输入设备失败");
        return;
    }
    
    //2.数据输出
    if (self.output == nil) {
        self.output = [[AVCaptureMetadataOutput alloc] init];
    }
    
    //3.拍摄会话 - 判断能够添加设备
    if (self.session == nil) {
        self.session = [[AVCaptureSession alloc] init];
        if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        }
    }
    
    if (![self.session canAddInput:self.input]) {
        GLLog(@"无法添加输出设备");
        self.session = nil;
        return;
    }
    
    if (![self.session canAddOutput:self.output]) {
        GLLog(@"无法添加输入设备");
        self.session = nil;
        
        return;
    }
    
    //4.添加输入／输出设备
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //5.设置扫描类型
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //6、设置扫描的区域
//    self.output.rectOfInterest = self.scanFrame;
    
    //7.设置预览图层会话
    [self setupLayers];
    
}
    
#pragma mark 设置绘制图层和预览图层
- (void)setupLayers {
    
    if (self.inView == nil) {
        GLLog(@"父视图不存在");
        return;
    }
    
    if (self.session == nil) {
        GLLog(@"拍摄会话不存在");
        return;
    }
    
    // 预览图层
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.inView.bounds;
        [self.inView.layer insertSublayer:self.previewLayer atIndex:0];
    }
    
}
    
    
#pragma mark - Methods
#pragma mark  生成二维码 icon默认大小
+ (void)qrImageWithString:(NSString *)string icon:(UIImage *)icon completion:(void (^)(UIImage *))completion {
    [self qrImageWithString:string icon:icon scale:0.20 completion:completion];
}
    
#pragma mark  生成二维码 icon自定义大小
+ (void)qrImageWithString:(NSString *)string icon:(UIImage *)icon scale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
    //参数处理
    NSAssert(string.length != 0, @"必须传入二维码的字符串！");
    
    if (icon == nil) {
        GLLog(@"生成二维码没有传入icon图片。");
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        [qrFilter setDefaults];
        [qrFilter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
        
        CIImage *ciImage = qrFilter.outputImage;
        
        CGAffineTransform transform = CGAffineTransformMakeScale(10.0, 10.0);
        CIImage *transformedImage = [ciImage imageByApplyingTransform:transform];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:transformedImage fromRect:transformedImage.extent];
        UIImage *qrImage = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        
        qrImage = [self qrcodeImage:qrImage icon:icon scale:scale];
        
        dispatch_async(dispatch_get_main_queue(), ^{ completion(qrImage); });
    });
}
    
    
#pragma mark  扫描图像方法
+ (void)scaneImage:(UIImage *)image completion:(void (^)(NSArray *values))completion {
    
    if (image == nil) {
        GLLog(@"没有传出需要扫描的图像二维码！");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        
        NSArray *features = [detector featuresInImage:ciImage];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:features.count];
        for (CIQRCodeFeature *feature in features) {
            [arrayM addObject:feature.messageString];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(arrayM.copy);
            }
            
        });
    });
}

/**  跳转本应用的设置  */
+ (BOOL)openSettingsURLString {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=mail"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
#else
        [[UIApplication sharedApplication] openURL:url];
#endif
        return true;
    }else{
        return false;
    }
}
    
#pragma mark 开始扫描
- (void)startScan {
    if ([self.session isRunning]) {
        return;
    }
    self.currentDetectedCount = 0;
    
    [self.session startRunning];
}
    
#pragma mark 停止扫描
- (void)stopScan {
    if (![self.session isRunning]) {
        return;
    }
    [self.session stopRunning];
}
    
#pragma mark 添加图像捕捉输出
- (void)addCaptureImage:(void(^)(NSInteger bright))brightBlock {
    //是否可用
    if ([self.device hasTorch]) {
        //添加捕捉输出
        if (![self.session canAddOutput:self.videoDataOutput]) {
            return;
        }
        [self.session addOutput:self.videoDataOutput];
        
        self.brightBlock = brightBlock;
    }
}
    
#pragma mark 设置手电筒开关
- (void)setTorch:(BOOL)isOpen {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        if ([self.device hasTorch] && [self.device hasFlash]) {
            [self.device lockForConfiguration:nil];
            if (isOpen) {
                [self.device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [self.device setTorchMode:AVCaptureTorchModeOff];
            }
            [self.device unlockForConfiguration];
        }
    }
}
    
    
#pragma mark - Action
+ (UIImage *)qrcodeImage:(UIImage *)qrImage icon:(UIImage *)icon scale:(CGFloat)scale {
    if (icon) {
        
        //不在范围 使用默认大小
        if (scale > 1.0 || scale <= 0.0) {
            scale = 0.2;
            GLLog(@"icon 所占二维码比例不在需求范围！使用默认值占用比例: 0.2");
        }
        
        CGFloat screenScale = [UIScreen mainScreen].scale;
        CGRect rect = CGRectMake(0, 0, qrImage.size.width * screenScale, qrImage.size.height * screenScale);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, screenScale);
        
        [qrImage drawInRect:rect];
        
        CGSize avatarSize = CGSizeMake(rect.size.width * scale, rect.size.height * scale);
        CGFloat x = (rect.size.width - avatarSize.width) * 0.5;
        CGFloat y = (rect.size.height - avatarSize.height) * 0.5;
        [icon drawInRect:CGRectMake(x, y, avatarSize.width, avatarSize.height)];
        
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return [UIImage imageWithCGImage:result.CGImage scale:screenScale orientation:UIImageOrientationUp];
        
    }
    return qrImage;
}
    
#pragma mark - Protocol
#pragma mark  AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    for (id obj in metadataObjects) {
        // 判断检测到的对象类型
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            return;
        }
        
        // 转换对象坐标
        AVMetadataMachineReadableCodeObject *metadataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        
        // 判断扫描范围
        if (!CGRectContainsRect(self.scanFrame, metadataObject.bounds)) {
            GLLog(@"没有在扫描范围。");
            continue;
        }
        
        if (metadataObject.stringValue.length > 0) {
            //停止扫描
            [self stopScan];
            
            // 完成回调
            if (self.completionCallBack) {
                self.completionCallBack(metadataObject.stringValue);
            }
            [self stopScan];
        }else{
//            if (self.currentDetectedCount++ > self.maxDetectedCount) {
//                //                // 绘制边角
//                //                [self drawCornersShape:metadataObject];
//                
//                //移除
//                [self clearDrawLayer];
//                GLLog(@"识别超过最大次数。");
//            }
        }
    }
}

    
#pragma mark  AVCaptureVideoDataOutputSampleBuffer prptocol
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSInteger bright = [self getBrightWith:sampleBuffer];
    //    NSLog(@"%d",bright);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.brightBlock(bright);
    });
}
    
- (NSInteger)getBrightWith:(CMSampleBufferRef)sampleBuffer {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    unsigned char * baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    NSInteger num = 1;
    NSInteger bright = 0;
    NSInteger r;
    NSInteger g;
    NSInteger b;
    for (NSInteger i = 0; i < 4 * width * height; i++) {
        if (i%4 == 0) {
            num++;
            r = baseAddress[i+1];
            g = baseAddress[i+2];
            b = baseAddress[i+3];
            bright = bright + 0.299 * r + 0.587 * g + 0.114 * b;
        }
    }
    
    bright = (bright / num);
    return bright;
}
    
- (AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        dispatch_queue_t queue = dispatch_queue_create("brightCapture.scanner.queue.com", NULL);
        [_videoDataOutput setSampleBufferDelegate:self queue:queue];
        _videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    }
    return _videoDataOutput;
}
    
- (BOOL)isTorchOpen {
    return self.device.isTorchActive;
}
    
- (NSInteger)maxDetectedCount {
    if (_maxDetectedCount == 0) {
        /**  默认20次  */
        _maxDetectedCount = 20;
    }else if (_maxDetectedCount < 0) {
        _maxDetectedCount = NSIntegerMax;
    }
    
    return _maxDetectedCount;
}

@end
