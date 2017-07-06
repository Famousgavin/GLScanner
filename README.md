# GLScanner
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/Gavin-ldh/GLScanner/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GLCodeScanner.svg)](https://img.shields.io/cocoapods/v/GLScanner.svg)


**GLScanner** 最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取；个性化修改，错误处理回调。

 
## GLScanner的使用
在需要用到的地方 `#import <GLScanner.h>`

```
GLScannerController *scanner = [GLScannerController scannerWithInitRootView:^(GLScannerViewController *rootScannerView) {
#pragma mark UI初始化个性修改 

} completion:^(NSString *value, BOOL *dismissAnimation) {
#pragma mark 扫描成功处理

} error:^(GLScannerViewController *rootScannerView, NSError *error) {
#pragma mark 错误处理

}];

[self presentViewController:scanner animated:true completion:nil];

```

<!--HUPhotoBrowser支持本地图片浏览-->
<!---->
<!--[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images atIndex:indexPath.row];-->
<!---->
<!--HUPhotoBrowser同时支持网络图片浏览-->
<!---->
<!--[HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];-->
<!---->
<!--在需要浏览的图片的点击事件中调用即可：-->
<!---->
<!--```Objective-C-->
<!--- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {-->
<!---->
<!--PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];-->
<!--if (_localImage) {-->
<!--[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.originalImages atIndex:indexPath.row];-->
<!--}-->
<!--else {-->
<!--[HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"placeholder"] atIndex:indexPath.row dismiss:nil];-->
<!--}-->
<!---->
<!--}-->
<!--```-->
<!---->
<!--你还可以获取到当前浏览到的图片-->
<!---->
<!--```Objective-C-->
<!--[HUPhotoBrowser showFromImageView:cell.imageView withImages:self.images placeholderImage:nil atIndex:indexPath.row dismiss:^(UIImage *image, NSInteger index) {-->
<!---->
<!--}];-->
<!--```-->
<!--#HUPhotoPicker-->
<!--![image](https://github.com/hujewelz/HUPhotoBrowser/blob/master/screenshot/201604301836.png)-->
<!---->
<!--在需要用到的地方`#import "HUImagePickerViewController.h"`，并且遵循`HUImagePickerViewControllerDelegate,UINavigationControllerDelegate`代理.-->
<!--现在你就可以像使用`UIImagePickerController`一样的使用它了:-->
<!---->
<!--```-->
<!--HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];-->
<!--picker.delegate = self;-->
<!--picker.maxAllowedCount = 10;-->
<!--picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO-->
<!--[self presentViewController:picker animated:YES completion:nil];-->
<!--```-->
<!--在代理方法中你可以拿到你选择的图片-->
<!---->
<!--```-->
<!--- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{-->
<!--NSLog(@"images info: %@", info);-->
<!--_images = info[kHUImagePickerThumbnailImage];-->
<!--_originalImages = info[kHUImagePickerOriginalImage];-->
<!---->
<!--[self.collectionView reloadData];-->
<!--}-->
<!--```-->
<!---->
<!--```-->
<!--images info: {-->
<!--kHUImagePickerOriginalImage =     (-->
<!--"<UIImage: 0x7fbdb381f920>, {1668, 2500}",-->
<!--"<UIImage: 0x7fbdb15fbef0>, {4288, 2848}",-->
<!--"<UIImage: 0x7fbdb3914d40>, {3000, 2002}"-->
<!--);-->
<!--kHUImagePickerThumbnailImage =     (-->
<!--"<UIImage: 0x7fbdb15f36c0>, {40, 60}",-->
<!--"<UIImage: 0x7fbdb15f2b10>, {60, 40}",-->
<!--"<UIImage: 0x7fbdb15f4be0>, {60, 40}"-->
<!--);-->
<!--}-->


## 安装

1. [CocoaPods](https://cocoapods.org/)安装：
```
    pod 'GLScanner' 
```
2. 下载ZIP包,将`GLScanner`资源文件拖到工程中。


## 其他
为了不影响您项目中导入的其他第三方库，本库没有导入任何其他的第三方内容，可以放心使用。在使用前，您可以查看Demo
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果您有什么建议可以Issues我，谢谢
* 后续我会持续更新，为它添加更多的功能，欢迎star :)
