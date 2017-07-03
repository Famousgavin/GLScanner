Pod::Spec.new do |s|

  s.name         = "GLCodeScanner"
  s.version      = "1.0.1"
  s.summary      = "最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取"
  s.description  = <<-DESC
                    最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取；支持代码和Storyboard两种初始化方式
                   DESC

  s.homepage     = "https://github.com/Gavin-ldh/GLCodeScanner"
  s.license      = "MIT"
  s.author             = { "Gavin" => "gavin.ldh@qq.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/Gavin-ldh/GLCodeScanner.git", :tag => s.version }
  s.source_files  =  "GLCodeScanner/*.{h,m}"
  s.resources = 'GLCodeScanner/Resource/*.{png,xib,nib,bundle,strings}'
  s.framework  = "UIKit"
  s.requires_arc = true

end
