Pod::Spec.new do |s|

  s.name         = "VideoToGifManager"
  s.version      = "0.0.1"
  s.summary      = "用于视频转换成gif图片"

  s.description  = <<-DESC
    用来把视频转成gif图片
                   DESC

  s.homepage     = "https://www.shenhongbang.cc"

  s.license      = "MIT"
  s.author       = { "shenhongbang" => "shenhongbang@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/jiutianhuanpei/VideoToGifManager.git", :tag => s.version }

  s.source_files  = "Source/*"

  s.frameworks = "AVFoundation", "UIKit"
  s.requires_arc = true
  
  #s.dependency  'HYMediator'	#这个是此库依赖的三方库
  #s.xcconfig = {
  # 'USER_HEADER_SEARCH_PATHS' => '$(inherited) $(SRCROOT)/HYMediator'  #这个是配置路径，如果本库有依赖与三方的文件，需要配置这个，否则报错
  #}

end
