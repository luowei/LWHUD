#
# Be sure to run `pod lib lint LWHUD_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LWHUD_swift'
  s.version          = '1.0.0'
  s.summary          = 'LWHUD的Swift版本，轻量级HUD组件，支持SwiftUI。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LWHUD_swift，Swift版本的HUD组件，提供了UIKit和SwiftUI两种使用方式，支持多种展示样式和自定义配置。
                       DESC

  s.homepage         = 'https://github.com/luowei/LWHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWHUD.git'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'LWHUD_swift/Classes/**/*'

  # s.resource_bundles = {
  #   'LWHUD_swift' => ['LWHUD_swift/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'SwiftUI'
  # s.dependency 'AFNetworking', '~> 2.3'
end
