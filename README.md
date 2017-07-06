# GLScanner
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/Gavin-ldh/GLScanner/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GLCodeScanner.svg)](https://img.shields.io/cocoapods/v/GLScanner.svg)


**GLScanner** 最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取，支持多语言；个性化修改，错误处理回调。

```
1. 一个方法初始化所有，Block回调，简单方便
2. 支持个性化修改UI
3. 支持多语言设置(英语、简体中文、繁体中文)，或者自己设置所有语言
```
<br>

 
## 一、使用

在需要用到的地方 `#import <GLScanner.h>`

Xcode8.0以上要求在使用相机或者相册等，项目 `info.plist` 要添加  `Privacy - Photo Library Usage Description`  和  `Privacy - Camera Usage Description`  键值对，不然不给访问;不然不给访问;不然不给访问。千万别忘记了!!!!!!!!

<br> 

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
<br>

#### 具体使用请点击[GLScanner的详细使用](http://www.jianshu.com/p/f9ca42635689)
<br>
<br>

## 二、安装
1. [CocoaPods](https://cocoapods.org/)安装：
```
    pod 'GLScanner' 

    如果搜索不到，请先运行   rm ~/Library/Caches/CocoaPods/search_index.json  在搜索。
    
```
 
2. 下载ZIP包,将 `GLScanner` 资源文件拖到工程中。
<br>
<br>

## 三、其它
为了不影响您项目中导入的其他第三方库，本库没有导入任何其他的第三方内容，可以放心使用。在使用前，您有任何不明白都可以查看Demo或者点击[使用详解](http://www.jianshu.com/p/f9ca42635689)。
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）
* 如果您有什么建议可以Issues我，谢谢
* 后续我会持续更新，为它添加更多的功能，欢迎star :)
