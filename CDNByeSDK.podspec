
Pod::Spec.new do |s|
  s.name             = 'CDNByeSDK'
  s.version          = '1.10.0'
  s.summary          = 'CDNBye iOS SDK for Cross-platform P2P Streaming.'

  s.description      = <<-DESC
CDNBye iOS SDK implements WebRTC datachannel to scale live, vod video streaming by peer-to-peer network using bittorrent-like protocol. The forming peer network can be layed over other CDNs or on top of the origin server. CDNBye installs a proxy between your video player and your stream which intercepts network requests and proxies them through a P2P engine.
                       DESC

  s.homepage         = 'https://docs.cdnbye.com/#/en/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cdnbye' => 'service@cdnbye.com' }
  s.source           = { :git => 'https://github.com/cdnbye/ios-p2p-engine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.static_framework = true
  s.vendored_frameworks = 'CDNByeSDK/*.{framework}'

  s.dependency 'WebRTCDatachannel', '0.0.1'
  s.dependency 'SocketRocket', '~> 0.5'
  s.dependency 'CocoaLumberjack', '~> 3.5'
  s.dependency 'PINCache', '~> 2.3'
  s.dependency 'GCDWebServer', '~> 3.5'
  s.dependency 'CocoaAsyncSocket', '~> 7.6'
  
end
