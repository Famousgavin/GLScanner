     //
//  GLScannerViewController.m
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//


// 控件间距
#define GLScannerControlMargin  42.0
// 相册图片最大尺寸
#define GLScannerImageMaxSize   CGSizeMake(1000, 1000)


#import "NSString+GLLocalizedString.h"
#import <Photos/Photos.h>
#import "GLScannerError.h"
#import <AVFoundation/AVFoundation.h>
#import "GLScannerMaskView.h"
#import "GLScannerConfig.h"
#import "UIImage+GLAdd.h"
#import "GLScannerViewController.h"
#import "GLScannerBorder.h"
#import "GLQrScanner.h"


@interface GLScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CALayerDelegate>

/**  扫描框  */
@property (nonatomic, strong) GLScannerBorder *scannerBorder;
/**  扫描器  */
@property (nonatomic, strong) GLQrScanner *scanner;
/**  提示标签  */
@property (nonatomic, strong) UILabel *tipLabel;
/**  手电筒  */
@property (nonatomic, strong) UIButton *torchButton;

@property (nonatomic, strong) CALayer *maskLayer;

@property (nonatomic, strong) UIButton *rightButton;

/**  完成回调  */
@property (nonatomic, copy) void (^completion)(NSString *value, BOOL *dismissAnimation);

@property (nonatomic, copy) void (^error)(GLScannerViewController *rootScannerView, NSError *error);


@end

@implementation GLScannerViewController


+ (instancetype)scannerViewWithCompletion:(void (^)(NSString *value, BOOL *dismissAnimation))completion error:(void (^)(GLScannerViewController *rootScannerView, NSError *error))error {
    
    GLScannerViewController *scannerViewController = [[GLScannerViewController alloc] init];
    scannerViewController.completion = completion;
    scannerViewController.error = error;

    scannerViewController.barAlphe = 1.0;
    scannerViewController.barFontSize = 16.0;
    
    return scannerViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.scannerBorder startScannerAnimating];
    [self.scanner startScan];
    
    //注册进入活跃通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scannerBorder stopScannerAnimating];
    [self.scanner stopScan];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    // 实例化扫描器
    __weak typeof(self) weakSelf = self;
    if (self.scanner == nil) {
        self.scanner = [GLQrScanner scanerWithInView:self.view scanFrame:self.scannerBorder.frame completion:^(NSString *stringValue) {
            
            // 完成回调
            BOOL isDismissAnimation = true;
            if (weakSelf.completion) {
                weakSelf.completion(stringValue, &isDismissAnimation);
            }
            // 关闭
            [weakSelf dismissViewControllerAnimated:isDismissAnimation completion:nil];
            
        }];
    }
}

#pragma mark 初始化UI
- (void)initUI {
    self.view.backgroundColor = self.viewBackgroundColor;
    
    [self initNavigationBar];
    [self initScanerBorder];
    [self initOtherControls];
    
    [self checkPhoto];
    
}

#pragma mark 初始化导航栏
- (void)initNavigationBar {
    //背景颜色
    self.navigationController.navigationBar.tintColor = self.tintColor;
    if (self.barBackgroundImage) {
        [self.navigationController.navigationBar setBackgroundImage:self.barBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setBarTintColor:self.barBackgroundTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.titleColor}];
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:self.barAlphe];
    self.navigationController.navigationBar.translucent = true;
    
    //标题
    self.title = self.textStringDic[GLScannerBarTitle];
    
    //左右按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0.0, 0.0, 80.0, 40.0);
    [leftButton setTitle:self.textStringDic[GLScannerBarLeftTitle] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:self.barFontSize];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    if (self.leftBarButtonItem) {
        UIButton *backLeftButton = self.leftBarButtonItem(leftButton);
        if (backLeftButton) {
           self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backLeftButton];
        }else{
           self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        }
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    
    if (self.hiddenRightBarButtonItem) {
        
    }else{
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0.0, 0.0, 80.0, 40.0);
        [rightButton setTitle:self.textStringDic[GLScannerBarRightTitle] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:self.barFontSize];
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(clickAlbumButton) forControlEvents:UIControlEventTouchUpInside];
        if (self.rightBarButtonItem) {
            UIButton *backLeftButton = self.rightBarButtonItem(rightButton);
            if (backLeftButton) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backLeftButton];
            }else{
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
            }
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        }
        self.rightButton = rightButton;
    }
}

#pragma mark 初始化扫描框
- (void)initScanerBorder {
    
    if (self.scannerBorder == nil) {
        CGFloat width = self.view.bounds.size.width - 80.0;
        self.scannerBorder = [[GLScannerBorder alloc] initWithFrame:CGRectMake(0.0, 0.0, width, width)];
        self.scannerBorder.center = CGPointMake(self.view.center.x, self.view.center.y-60.0);
        self.scannerBorder.tintColor = self.tintColor;
        [self.view addSubview:self.scannerBorder];
    }
    
    //创建周围的遮罩层
    GLScannerMaskView *maskView = [GLScannerMaskView maskViewWithFrame:self.view.bounds cropRect:self.scannerBorder.frame coverColor:self.coverColor];
    [self.view insertSubview:maskView atIndex:0];
    
//    if (self.maskLayer == nil) {
//        self.maskLayer = [[CALayer alloc] init];
//        self.maskLayer.frame = self.view.bounds;
//        //此时设置的颜色就是中间扫描区域最终的颜色
//        self.maskLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor;
//        self.maskLayer.delegate = self;
//        
//        [self.view.layer insertSublayer:self.maskLayer atIndex:0];
//        
//        //让代理方法调用 将周围的蒙版颜色加深
//        [self.maskLayer setNeedsDisplay];
//    }
}

#pragma mark 初始化提示标签等
- (void)initOtherControls {
    
    // 提示标签
    if (self.tipLabel == nil && !self.isHiddenTipLabel) {
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, self.view.frame.size.width-40.0, 0.0)];
        
        self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
        self.tipLabel.font = [UIFont systemFontOfSize:13.0];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.numberOfLines = 0.0;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.tipLabel sizeToFit];
        self.tipLabel.center = CGPointMake(self.scannerBorder.center.x, CGRectGetMaxY(self.scannerBorder.frame) + GLScannerControlMargin);
        
        [self.view addSubview:self.tipLabel];
    }
    
    //手电筒
    if (self.torchButton == nil) {
        self.torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.torchButton.frame = CGRectMake(0.0, 0.0, self.scannerBorder.bounds.size.width/3, self.scannerBorder.bounds.size.width/3);
        self.torchButton.center = CGPointMake(self.scannerBorder.center.x, CGRectGetMaxY(self.tipLabel.frame) + GLScannerControlMargin);

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"GLScanner" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        NSString *fileNameOff = [NSString stringWithFormat:@"%@@2x", @"QRCodeTorchOff"];
        NSString *pathOff = [imageBundle pathForResource:fileNameOff ofType:@"png"];
        
        NSString *fileNameOn = [NSString stringWithFormat:@"%@@2x", @"QRCodeTorchOn"];
        NSString *pathOn = [imageBundle pathForResource:fileNameOn ofType:@"png"];
        
        [self.torchButton setImage:[UIImage imageWithContentsOfFile:pathOff] forState:UIControlStateNormal];
        [self.torchButton setImage:[UIImage imageWithContentsOfFile:pathOn] forState:UIControlStateSelected];
        self.torchButton.adjustsImageWhenHighlighted = false;
        [self.torchButton addTarget:self action:@selector(clickTorchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.torchButton];
    }
}

- (void)checkPhoto {
    //检查相机是否可用和授权
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        GLLog(@"相机权限拒绝或者在授权中");
        self.tipLabel.text = self.textStringDic[GLScannerTipCameraNotPermission];
        GLScannerAfter(3.0f, ^{
            self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
        });
        if (self.error) {
            NSError *error = [NSError errorWithDomain:GLSimpleScannerErrorDomain code:GLSimpleScannerErrorCodeCameraPermission userInfo:nil];
            self.error(self, error);
            GLLog(@"%@", error.description);
        }
    }
    
    //相机是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        GLLog(@"相机不可用");
        self.tipLabel.text = self.textStringDic[GLScannerTipCameraNotAvailable];
        GLScannerAfter(3.0f, ^{
            self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
        });
        if (self.error) {
            NSError *error = [NSError errorWithDomain:GLSimpleScannerErrorDomain code:GLSimpleScannerErrorCodeCameraNotAvailable userInfo:nil];
            self.error(self, error);
            GLLog(@"%@", error.description);
        }
        
    }
}


#pragma mark - Action
#pragma mark 点击关闭按钮
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark 点击相册按钮
- (void)clickAlbumButton {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied ||
        [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) {
        GLLog(@"相册用户拒绝使用或者在授权中");
        self.tipLabel.text = self.textStringDic[GLScannerTipPhotoNotPermission];
        GLScannerAfter(3.0f, ^{
            self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
        });
        if (self.error) {
            NSError *error = [NSError errorWithDomain:GLSimpleScannerErrorDomain code:GLSimpleScannerErrorCodePhotoPermission userInfo:nil];
            self.error(self, error);
            
            GLLog(@"%@", error.description);
        }
        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.tipLabel.text = self.textStringDic[GLScannerTipPhotoNotAvailable];
        GLScannerAfter(3.0f, ^{
            self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
        });
        GLLog(@"相册无法使用");
        if (self.error) {
            NSError *error = [NSError errorWithDomain:GLSimpleScannerErrorDomain code:GLSimpleScannerErrorCodePhotoNotAvailable userInfo:nil];
            self.error(self, error);
            GLLog(@"%@", error.description);
        }
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    [picker.navigationBar setBarTintColor:self.barBackgroundTintColor];
    picker.navigationBar.tintColor = self.tintColor;
    picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:self.titleColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:self.barFontSize]};
    
    [self presentViewController:picker animated:true completion:nil];
}

#pragma mark 点击手电筒按钮
- (void)clickTorchButton:(UIButton *)sender {
    if (sender.selected) {
        [self.scanner setTorch:false];
    }else {
        [self.scanner setTorch:true];
    }
    sender.selected = !sender.selected;
}

#pragma mark - Peotocol
#pragma mark - UIImagePickerController Protocol
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        // 扫描图像
        image = [image imageByResizeToSize:GLScannerImageMaxSize contentMode:UIViewContentModeScaleAspectFit];
        [GLQrScanner scaneImage:image completion:^(NSArray *values) {
            
            if (values.count > 0) {
                
                // 完成回调
                BOOL isDismissAnimation = true;
                if (self.completion) {
                    self.completion(values.lastObject, &isDismissAnimation);
                }
                
                [picker dismissViewControllerAnimated:isDismissAnimation completion:nil];
            }else{
                self.tipLabel.text = self.textStringDic[GLScannerTipImageNotFoundQrCode];
                GLScannerAfter(3.0f, ^{
                    self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
                });
                [picker dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }else{
        self.tipLabel.text = self.textStringDic[GLScannerTipImageNotFoundQrCode];
        GLScannerAfter(3.0f, ^{
            self.tipLabel.text = self.textStringDic[GLScannerDefaultTipContent];
        });
        [picker dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark 蒙版中间一块要空出来
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == self.maskLayer) {
        UIGraphicsBeginImageContextWithOptions(self.maskLayer.frame.size, false, 1.0);
        //蒙版新颜色
        CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor);
        CGContextFillRect(ctx, self.maskLayer.frame);
        //转换坐标
        CGRect scanFrame = [self.view convertRect:self.scannerBorder.frame fromView:self.scannerBorder.superview];
        //空出中间一块
        CGContextClearRect(ctx, scanFrame);
    }
}

#pragma mark - 通知
- (void)applicationWillEnterForeground {
    [self.scannerBorder startScannerAnimating];
    [self.scanner startScan];
}

- (void)dealloc {
    GLLog(@"释放：%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 懒加载
- (UIColor *)titleColor {
    if (_titleColor == nil) {
        _titleColor = GLScannerDefaultTitleColor;
    }
    return _titleColor;
}

- (UIColor *)tintColor {
    if (_tintColor == nil) {
        _tintColor = GLScannerDefaultTintColor;
    }
    return _tintColor;
}

- (UIColor *)barBackgroundTintColor {
    if (_barBackgroundTintColor == nil) {
        _barBackgroundTintColor = GLScannerDefaultBarBackgroundTintColor;
    }
    return _barBackgroundTintColor;
}

- (void)setBarAlphe:(CGFloat)barAlphe {
    if (barAlphe > 1.0 || barAlphe < 0.0) {
        _barAlphe = 1.0;
    }else{
        _barAlphe = barAlphe;
    }
}

- (UIColor *)viewBackgroundColor {
    if (_viewBackgroundColor == nil) {
        _viewBackgroundColor = GLScannerDefaultViewBackgroundColor;
    }
    return _viewBackgroundColor;
}

- (UIColor *)coverColor {
    if (_coverColor == nil) {
        _coverColor = GLScannerDefaultCoverColor;
    }
    return _coverColor;
}

- (void)setLanguageCode:(NSString *)languageCode {
    _languageCode = languageCode;
    [NSString setUserLanguageCode:languageCode];
}

- (NSMutableDictionary *)textStringDic {
    if (_textStringDic == nil) {
        _textStringDic = @{GLScannerBarTitle:[@"GLScanner_1" customLocalizedString],
                           GLScannerBarLeftTitle:[@"GLScanner_2" customLocalizedString],
                           GLScannerBarRightTitle:[@"GLScanner_3" customLocalizedString],
                           GLScannerDefaultTipContent:[@"GLScanner_6" customLocalizedString],
                           GLScannerTipCameraNotPermission:[@"GLScanner_4" customLocalizedString],
                           GLScannerTipCameraNotAvailable:[@"GLScanner_5" customLocalizedString],
                           GLScannerTipPhotoNotPermission:[@"GLScanner_7" customLocalizedString],
                           GLScannerTipPhotoNotAvailable:[@"GLScanner_8" customLocalizedString],
                           GLScannerTipImageNotFoundQrCode:[@"GLScanner_9" customLocalizedString],
                           }.mutableCopy;
    }
    
    return _textStringDic;
}

@end
