//
//  GLScannerBorder.m
//  GLScanner
//
//  Created by Gavin on 2017/6/28.
//  Copyright © 2017年 Gavin. All rights reserved.
//


#import "GLQrScanner.h"
#import "GLScannerBorder.h"

@interface GLScannerBorder ()

@property (nonatomic, strong) UIImageView *scannerLine;

@end

@implementation GLScannerBorder

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.clipsToBounds = true;
    
    if (self.scannerLine == nil) {
        
        // 冲击波图像
        self.scannerLine = [[UIImageView alloc] initWithImage:[GLScannerBorder imageResourceWithName:@"QRCodeScanLine"]];
        
        self.scannerLine.frame = CGRectMake(0, 0, self.bounds.size.width, self.scannerLine.bounds.size.height);
        self.scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, 0);
        
        [self addSubview:self.scannerLine];
        
        // 加载边框图像
        for (NSInteger i = 1; i < 5; i++) {
            NSString *imgName = [NSString stringWithFormat:@"ScanQR%zd", i];
            UIImageView *imaageView = [[UIImageView alloc] initWithImage:[GLScannerBorder imageResourceWithName:imgName]];
            
            [self addSubview:imaageView];
            
            CGFloat offsetX = self.bounds.size.width - imaageView.bounds.size.width;
            CGFloat offsetY = self.bounds.size.height - imaageView.bounds.size.height;
            
            switch (i) {
                case 2:
                    imaageView.frame = CGRectOffset(imaageView.frame, offsetX, 0.0);
                    break;
                case 3:
                    imaageView.frame = CGRectOffset(imaageView.frame, 0.0, offsetY);
                    break;
                case 4:
                    imaageView.frame = CGRectOffset(imaageView.frame, offsetX, offsetY);
                    break;
                default:
                    break;
            }
        }
    }
}


#pragma mark - Methods
#pragma mark 拿取资源包图片
+ (UIImage *)imageResourceWithName:(NSString *)imageName {
    // 图像文件包
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"GLScanner" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    
    NSString *fileName = [NSString stringWithFormat:@"%@@2x", imageName];
    NSString *path = [imageBundle pathForResource:fileName ofType:@"png"];
    return [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


#pragma mark  开始扫描动画
- (void)startScannerAnimating {
    
    [self stopScannerAnimating];
    
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height);
    } completion:nil];
}

#pragma mark 停止扫描动画
- (void)stopScannerAnimating {
    [self.scannerLine.layer removeAllAnimations];
    self.scannerLine.center = CGPointMake(self.bounds.size.width * 0.5, 0);
}




@end
