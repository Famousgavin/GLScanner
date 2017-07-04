//
//  ViewController.m
//  GLCodeScanner
//
//  Created by Gavin on 2017/6/27.
//  Copyright © 2017年 Gavin. All rights reserved.
//



#import "GLScanner.h"
#import "ViewController.h"

@interface ViewController () <UITableViewDelegate>
    
@property (weak, nonatomic) IBOutlet UITableView *tableView;
    

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *scanResultLabel;
    
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.dataSource = @[@[@"Navigation+Model", @"Push",],
                        @[@"Navigation+Model", @"Push",],];

}
    
#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}
    
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *IDCell = @"GLTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //model
            GLScannerController *scanner = [GLScannerController scannerWithInitRootViewBlock:^(GLScannerViewController *rootScannerView) {
                
            } completion:^(NSString *stringValue) {
                self.scanResultLabel.text = stringValue;
            }];
            
            [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
            
            [self showDetailViewController:scanner sender:nil];
            
        }else if (indexPath.row == 1) {
            //push
            
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //SBCodeModel
        }else if (indexPath.row == 1) {
            //SBCodePush
        }
        
    }
    
//    GLMeetingListCell *cell = (GLMeetingListCell *)[tableView cellForRowAtIndexPath:indexPath];
//    GLMeetingDetailViewController *meetingDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GLMeetingDetailViewController class])];
//    meetingDetailViewController.listModel = cell.model;
//    meetingDetailViewController.indexPath = indexPath;
//    meetingDetailViewController.delegate = self;
//    [self.navigationController pushViewController:meetingDetailViewController animated:true];
    
}
    
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"代码初始化";
    }else if (section == 1) {
        return @"Storyboard初始化";
    }
    return @"";
}

@end
