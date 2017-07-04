//
//  GLMeViewController.m
//  GLCodeScannerDemo
//
//  Created by Gavin on 2017/7/4.
//  Copyright © 2017年 Gavin. All rights reserved.
//


#import "GLScanner.h"
#import "GLMeViewController.h"

@interface GLMeViewController ()
    
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strng = @"Gavin-ldh 需要你的支持";
    UIImage *icon = [UIImage imageNamed:@"icon"];
    
    [GLQrScanner qrImageWithString:strng icon:icon scale:0.15 completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (IBAction)clickProjectButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

    
    
@end
