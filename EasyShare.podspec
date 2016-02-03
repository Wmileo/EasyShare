Pod::Spec.new do |s|
  s.name         = "EasyShare"
  s.version      = "0.0.2"
  s.summary      = "简单封装分享"
  s.description  = <<-DESC
					 简单封装分享功能
                   DESC

  s.homepage     = "https://github.com/Wmileo/EasyShare"
  s.license      = "MIT"
  s.author       = { "leo" => "work.mileo@gmail.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Wmileo/EasyShare.git", :tag => s.version.to_s }

  s.source_files  = "EasyShare/Share/*"
  s.frameworks   = 'SystemConfiguration'
  s.libraries = 'z' , 'sqlite3.0' , 'c++' , 'ahahahahaha'
  s.requires_arc = true

  s.vendored_frameworks = 'EasyShare/Framework/*.{framework}'
  s.dependency 'iOS-WechatSDK'

end
