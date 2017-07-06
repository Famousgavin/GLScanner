//
//  GLMeViewController.m
//  GLCodeScannerDemo
//
//  Created by Gavin on 2017/7/4.
//  Copyright © 2017年 Gavin. All rights reserved.
//


#import "GLScanner.h"

#import "UIView+Utils.h"
#import "UIImage+GLAdd.h"
#import "GLScanner.h"
#import "GLMeViewController.h"

@interface GLMeViewController ()
    
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strng = @"https://github.com/Gavin-ldh";
    UIImage *iconImage = [UIImage imageNamed:@"icon"];
    CGFloat width = self.view.frame.size.width/5.0;
    iconImage = [iconImage imageByResizeToSize:CGSizeMake(width, width) contentMode:UIViewContentModeScaleAspectFill];
    
    [GLQrScanner qrImageWithString:strng icon:iconImage scale:0.15 completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    [self.imageView setLongPressActionWithBlock:^{
        
        [GLQrScanner scaneImage:self.imageView.image completion:^(NSArray *values) {
            [self openURLString:values.lastObject];
        }];
        
    }];
    
    self.contentLabel.text = @"感谢黑夜的来临，\n\n我知道今天不论有多失败，\n\n全新的明天仍然等待我来证明自己。";
}

- (IBAction)clickProjectButton:(UIButton *)sender {
    [self openURLString:@"https://github.com/Gavin-ldh/GLScanner"];
}


- (void)openURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
#else
        [[UIApplication sharedApplication] openURL:url];
#endif
    }
}


@end
