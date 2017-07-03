Pod::Spec.new do |s|

  s.name         = "GLCodeScanner"
  s.version      = "1.0.0"
  s.summary      = "最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取"
  s.description  = <<-DESC
                    最好用的iOS二维码、条形码，扫描、生成框架，支持闪光灯，从相册获取；支持代码和Storyboard两种初始化方式
                   DESC

  s.homepage     = "https://github.com/Gavin-ldh/GLCodeScanner"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
    #s.license      = { :type => "MIT", :file => "FILE_LICENSE" }   #协议
  s.author             = { "Gavin" => "gavin.ldh@qq.com" }  # 开发者信息
  # Or just: s.author    = "Gavin"
  # s.authors            = { "Gavin" => "gavin.ldh@qq.com" }
  # s.social_media_url   = "http://twitter.com/Gavin"

    s.platform     = :ios
#   s.platform     = :ios, "8.0"
   s.ios.deployment_target = "8.0"  # 最低版本
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Gavin-ldh/GLCodeScanner.git", :tag => s.version }

  s.source_files  =  "GLCodeScanner/*.{h,m}"  # 库文件 库的原代码目录
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

#s.resource  = "GLScanner.bundle/ScannerLocalizable.strings"
 s.resources = 'GLCodeScanner/Resource/*.{png,xib,nib,bundle,strings}'
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

   s.framework  = "UIKit"
# s.frameworks = "UIKit", ""  #依赖的framework

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"   #依赖的第三方库#

end
