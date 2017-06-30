//
//  ViewController.m
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/27.
//  Copyright © 2017年 Gavin. All rights reserved.
//


#import "GLScannerController.h"
#import "GLScanner.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *scanResultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strng = @"Gavin-ldh";
    UIImage *icon = [UIImage imageNamed:@"test"];
    
    [GLScanner qrImageWithString:strng icon:icon scale:0.15 completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (IBAction)clickScanButton:(UIButton *)sender {
    
    GLScannerController *scanner = [GLScannerController scannerWithInitRootViewBlock:^(GLScannerViewController *rootScannerView) {
        
    } completion:^(NSString *stringValue) {
         self.scanResultLabel.text = stringValue;
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    
    [self showDetailViewController:scanner sender:nil];
}

@end
