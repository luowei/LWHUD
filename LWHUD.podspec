#
# Be sure to run `pod lib lint LWHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LWHUD'
  s.version          = '1.0.0'
  s.summary          = 'HUD组件，MBProgressHUD 的山寨版.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HUD组件，MBProgressHUD 的山寨版.适用于在SDK中使用，可为避免SDK与App的依赖冲突.。
                       DESC

  s.homepage         = 'https://github.com/luowei/LWHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWHUD.git'}
  # s.source           = { :git => 'https://gitlab.com/ioslibraries1/lwhud.git'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LWHUD/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LWHUD' => ['LWHUD/Assets/*.png']
  # }

  s.public_header_files = 'LWHUD/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
