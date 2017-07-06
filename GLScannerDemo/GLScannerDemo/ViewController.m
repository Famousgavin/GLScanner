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
    

@property (nonatomic, strong) NSString *scanResult;
    
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.dataSource = @[@"扫一扫(默认)",
                        @"扫一扫(个性化修改)",
                        @"扫一扫(多语言)",];

}
    
#pragma mark - Delegate
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *IDCell = @"GLTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    
    GLScannerController *scanner = [GLScannerController scannerWithInitRootView:^(GLScannerViewController *rootScannerView) {
#pragma mark UI初始化个性修改
        if (indexPath.row == 0) {
            //默认
            
        }else if (indexPath.row == 1) {
            //标题颜色
            rootScannerView.titleColor = [UIColor whiteColor];

            //设置bar背景图片或者颜色 二选一 优先图片
            rootScannerView.barBackgroundImage = [UIImage imageNamed:@"bar_background"];
            //rootScannerView.barBackgroundTintColor = [UIColor lightGrayColor];
            
            //统一设置bar 和扫描工作的图片的颜色
            rootScannerView.tintColor = [UIColor whiteColor];
            
            //设置遮挡颜色
            //rootScannerView.coverColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
            
            //自定义左侧item
            rootScannerView.leftBarButtonItem = ^UIButton *(UIButton *leftButton) {
                //可以修改button的一些属性
                //自己创建一个返回也可以 可以自己实现触发方法
                return leftButton;
            };
            
            //自定义右侧item
            rootScannerView.rightBarButtonItem = ^UIButton *(UIButton *rightButton) {
                //可以修改button的一些属性
                [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                //优先这里设置
                [rightButton setTitle:@"Photo" forState:UIControlStateNormal];
                //自己创建一个返回也可以
                return rightButton;
            };
            
            //可以隐藏右侧ltem
            rootScannerView.hiddenRightBarButtonItem = true;
            
            //隐藏提示label
            //rootScannerView.hiddenTipLabel = true;
            
        }else if (indexPath.row == 2) {
            //设置语言 默认跟随系统
            CGFloat index = arc4random_uniform(4);
            if (index == 0) {
                rootScannerView.languageCode = GLScannerLocalizedStringZh_Hans;
            }else if (index == 1) {
                rootScannerView.languageCode = GLScannerLocalizedStringZh_Hant;
            }else if (index == 2) {
                rootScannerView.languageCode = GLScannerLocalizedStringEn;
            }else{
                //或者设置语言文本
                rootScannerView.textStringDic[GLScannerBarTitle] = @"掃一掃";
                rootScannerView.textStringDic[GLScannerBarRightTitle] = @"Photo";
                rootScannerView.textStringDic[GLScannerDefaultTipContent] = @"将二维码放入框中，即可自动扫描";
            }
        }

    } completion:^(NSString *value, BOOL *dismissAnimation) {
#pragma mark 扫描成功处理
        self.scanResult = value;
        [self.tableView reloadData];
        *dismissAnimation = false;
        
    } error:^(GLScannerViewController *rootScannerView, NSError *error) {
        
#pragma mark 错误处理
        /**
            错误回调可以根据 rootScannerView 是否释放扫描控制器 或者提示
            [rootScannerView dismissViewControllerAnimated:false completion:^{
                //相机相册没有权限 跳转设置权限
                if (error.code == GLSimpleScannerErrorCodeCameraPermission) {
                    [self showAlertPermissionWithTitle:@"相机没有访问权限，请授权使用"  fromController:self];
                }else if (error.code == GLSimpleScannerErrorCodePhotoPermission) {
                    [self showAlertPermissionWithTitle:@"相册没有访问权限，请授权使用"  fromController:self];
                }
            }];
         */
        
        //相机相册没有权限 跳转设置权限
        if (error.code == GLSimpleScannerErrorCodeCameraPermission) {
            [self showAlertPermissionWithTitle:@"相机没有访问权限，请授权使用"  fromController:rootScannerView];
        }else if (error.code == GLSimpleScannerErrorCodePhotoPermission) {
            [self showAlertPermissionWithTitle:@"相册没有访问权限，请授权使用"  fromController:rootScannerView];
        }
    }];
    [self presentViewController:scanner animated:true completion:nil];
}
    
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"代码初始化(Navigation+Model)";
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.scanResult.length > 0) {
       return [NSString stringWithFormat:@"扫描结果：%@", self.scanResult];
    }
    return @"";
}

- (void)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction *action) {
       
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)showAlertPermissionWithTitle:(NSString *)title fromController:(UIViewController *)fromController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction *action) {
         [GLQrScanner openSettingsURLString];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [fromController presentViewController:alertController animated:true completion:nil];
}

@end
