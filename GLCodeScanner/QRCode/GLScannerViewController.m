//
//  GLScannerViewController.m
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//


/// 控件间距
#define kControlMargin  42.0
/// 相册图片最大尺寸
#define kImageMaxSize   CGSizeMake(1000, 1000)


#import "GLScannerMaskView.h"
#import "GLScannerConfig.h"
#import "UIImage+GLAdd.h"
#import "GLScannerViewController.h"
#import "GLScannerBorder.h"
#import "GLScanner.h"


typedef NS_ENUM(NSInteger, GLScannerInitType) {
    /**  代码初始化视图  */
    GLScannerInitTypeCode            = 0x00,
    /**  Storyboard初始化视图  */
    GLScannerInitTypeStoryboard,
    
};


@interface GLScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CALayerDelegate>


/**  扫描框  */
@property (nonatomic, strong) GLScannerBorder *scannerBorder;
/**  扫描器  */
@property (nonatomic, strong) GLScanner *scanner;
/**  提示标签  */
@property (nonatomic, strong) UILabel *tipLabel;
/**  手电筒  */
@property (nonatomic, strong) UIButton *torchButton;

@property (nonatomic, strong) CALayer *maskLayer;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, assign) GLScannerInitType initType;


@end

@implementation GLScannerViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        self.initType = GLScannerInitTypeStoryboard;
    }
    return self;
}

+ (instancetype)scannerViewWithCompletion:(void (^)(NSString *))completion {
    
    GLScannerViewController *scannerViewController = [[GLScannerViewController alloc] init];
    scannerViewController.completion = completion;
    scannerViewController.initType = GLScannerInitTypeCode;
    return scannerViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.scannerBorder startScannerAnimating];
    [self.scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scannerBorder stopScannerAnimating];
    [self.scanner stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    // 实例化扫描器
    __weak typeof(self) weakSelf = self;
    if (self.scanner == nil) {
        self.scanner = [GLScanner scanerWithInView:self.view scanFrame:self.scannerBorder.frame completion:^(NSString *stringValue) {
            // 完成回调
            if (weakSelf.completion) {
                weakSelf.completion(stringValue);
            }
            
            // 关闭
            [weakSelf clickCloseButton];
        }];

        //错误回调
        self.scanner.onError = ^(NSError *error) {
            if (weakSelf.onError) {
                weakSelf.onError(error);
            }
        };
        
        
    }
    
//    ///添加获取图像亮度值
//    __weak typeof(self.scanner) weakScanner = self.scanner;
//    [self.scanner addCaptureImage:^(NSInteger bright) {
//        if (bright > 40) {
//            if (weakScanner.isTorchOpen) {
//                return;
//            }
//            weakSelf.torchButton.hidden = YES;
//        } else {
//            weakSelf.torchButton.hidden = NO;
//        }
//    }];
}

#pragma mark 初始化UI
- (void)initUI {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self initNavigationBar];
    [self initScanerBorder];
    [self initOtherControls];
    
}

#pragma mark 初始化导航栏
- (void)initNavigationBar {
    //背景颜色
//    [self.navigationController.navigationBar setBarTintColor:self.barTintColor];
    self.navigationController.navigationBar.translucent = true;
    
    //标题
    self.title = self.titleString;
    
    
    //左右按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    [leftButton setTitle:self.leftButtonTitle forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:self.navigationItemFontSize];
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
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    [rightButton setTitle:self.rightButtonTitle forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:self.navigationItemFontSize];
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

#pragma mark 初始化扫描框
- (void)initScanerBorder {
    
    if (self.scannerBorder == nil) {
        CGFloat width = self.view.bounds.size.width - 80.0;
        self.scannerBorder = [[GLScannerBorder alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        
        self.scannerBorder.center = CGPointMake(self.view.center.x, self.view.center.y-40.0);
        self.scannerBorder.tintColor = self.navigationController.navigationBar.tintColor;
        
        [self.view addSubview:self.scannerBorder];
    }
    
    //创建周围的遮罩层
    GLScannerMaskView *maskView = [GLScannerMaskView maskViewWithFrame:self.view.bounds cropRect:self.scannerBorder.frame];
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
    if (self.tipLabel == nil) {
        self.tipLabel = [[UILabel alloc] init];
        
        self.tipLabel.text = @"将二维码/条码放入框中，即可自动扫描";
        self.tipLabel.font = [UIFont systemFontOfSize:13.0];
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.tipLabel sizeToFit];
        self.tipLabel.center = CGPointMake(self.scannerBorder.center.x, CGRectGetMaxY(self.scannerBorder.frame) + kControlMargin);
        
        [self.view addSubview:self.tipLabel];
    }
    
    //手电筒
    if (self.torchButton == nil) {
        self.torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.torchButton.frame = CGRectMake(0.0, 0.0, self.scannerBorder.bounds.size.width/3, self.scannerBorder.bounds.size.width/3);
        self.torchButton.center = CGPointMake(self.scannerBorder.center.x, CGRectGetMaxY(self.scannerBorder.frame) + kControlMargin*2.0);

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


#pragma mark - Action
#pragma mark 点击关闭按钮
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark 点击相册按钮
- (void)clickAlbumButton {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.tipLabel.text = @"无法访问相册";
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.view.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    
    [self showDetailViewController:picker sender:nil];
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
        image = [image imageByResizeToSize:kImageMaxSize contentMode:UIViewContentModeScaleAspectFit];
        [GLScanner scaneImage:image completion:^(NSArray *values) {
            
            if (values.count > 0) {
                if (self.completion) {
                    self.completion(values);
                }
                
                [picker dismissViewControllerAnimated:false completion:^{
                    [self clickCloseButton];
                }];
            } else {
                self.tipLabel.text = @"没有识别到二维码，请选择其他照片";
                [picker dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }else{
        self.tipLabel.text = @"没有识别到二维码，请选择其他照片";
        [picker dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark 蒙版中间一块要空出来
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == self.maskLayer) {
        UIGraphicsBeginImageContextWithOptions(self.maskLayer.frame.size, NO, 1.0);
        //蒙版新颜色
        CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor);
        CGContextFillRect(ctx, self.maskLayer.frame);
        //转换坐标
        CGRect scanFrame = [self.view convertRect:self.scannerBorder.frame fromView:self.scannerBorder.superview];
        //空出中间一块
        CGContextClearRect(ctx, scanFrame);
    }
}

- (void)dealloc {
    GLLog(@"释放：%s", __func__);
}

#pragma mark - 重写
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 懒加载
- (UIColor *)barTintColor {
    if (_barTintColor == nil) {
        _barTintColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    }
    return _barTintColor;
}

- (NSString *)titleString {
    if (_titleString == nil) {
        _titleString = @"扫一扫";
    }
    return _titleString;
}

- (NSString *)leftButtonTitle {
    if (_leftButtonTitle == nil) {
        _leftButtonTitle = @"关闭";
    }
    return _leftButtonTitle;
}

- (NSString *)rightButtonTitle {
    if (_rightButtonTitle == nil) {
        _rightButtonTitle = @"相册";
    }
    return _rightButtonTitle;
}

- (void)setHiddenRightBarButtonItem:(BOOL)hiddenRightBarButtonItem {
    _hiddenRightBarButtonItem = hiddenRightBarButtonItem;
    self.rightButton.hidden = hiddenRightBarButtonItem;
}


- (CGFloat)navigationItemFontSize {
    if (_navigationItemFontSize == 0.0) {
        _navigationItemFontSize = 16.0;
    }
    return _navigationItemFontSize;
}

@end
