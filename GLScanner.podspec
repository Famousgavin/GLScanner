Pod::Spec.new do |s|

  s.name          = "GLScanner"
  s.version       = "1.0.1"
  s.summary       = "最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取；个性化修改，支持多语言"
  s.description   = <<-DESC
                    最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取；个性化修改，错误处理回调；支持多语言。
                    DESC

  s.homepage      = "https://github.com/Gavin-ldh/GLScanner"
  s.license       = "MIT"
  s.author        = { "Gavin" => "gavin.ldh@hotmail.com" }
  s.social_media_url = "https://www.dhlee.cn"
  s.platform      = :ios
  s.ios.deployment_target = "8.0"
  s.source        = { :git => "https://github.com/Gavin-ldh/GLScanner.git", :tag => s.version }
  s.source_files  =  "GLScanner/*.{h,m}"
  s.resources     = 'GLScanner/Resource/*.{png,xib,nib,bundle,strings}'
  s.framework     = "UIKit"
  s.requires_arc  = true

#  s.dependency "MBProgressHUD"

end
