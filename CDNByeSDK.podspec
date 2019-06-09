#
# Be sure to run `pod lib lint CDNByeSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CDNByeSDK'
  s.version          = '0.3.5'
  s.summary          = 'CDNBye iOS SDK for Cross-platform P2P Streaming.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CDNBye iOS SDK implements WebRTC datachannel to scale live/vod video streaming by peer-to-peer network using bittorrent-like protocol. The forming peer network can be layed over other CDNs or on top of the origin server. CDNBye installs a proxy between your video player and your stream which intercepts network requests and proxies them through a P2P engine.
                       DESC

  s.homepage         = 'https://docs.cdnbye.com/#/en/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cdnbye' => 'service@cdnbye.com' }
  s.source           = { :git => 'https://github.com/cdnbye/ios-p2p-engine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  
  s.vendored_frameworks = 'CDNByeSDK/*.{framework}'

  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'GoogleWebRTC', '~> 1.1'
  s.dependency 'SocketRocket', '~> 0.5'
  s.dependency 'CocoaLumberjack', '~> 3.5'
  s.dependency 'YYCache', '~> 1.0'
  s.dependency 'GCDWebServer', '~> 3.5'
end
