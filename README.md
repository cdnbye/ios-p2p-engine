**English | [简体中文](Readme_zh.md)**

<h1 align="center"><a href="" target="_blank" rel="noopener noreferrer"><img width="250" src="https://cdnbye.oss-cn-beijing.aliyuncs.com/pic/cdnbye.png" alt="cdnbye logo"></a></h1>
<h4 align="center">Save Your Bandwidth using WebRTC.</h4>
<p align="center">
<a href="https://cocoapods.org/pods/CDNByeSDK"><img src="https://img.shields.io/cocoapods/v/CDNByeSDK.svg?style=flat" alt="version"></a>
<a href="https://cocoapods.org/pods/CDNByeSDK"><img src="https://img.shields.io/cocoapods/p/CDNByeSDK.svg?style=flat" alt="platform"></a>
</p>

CDNBye iOS P2P Engine scales live/vod video streaming by peer-to-peer network using bittorrent-like protocol. Powered by WebRTC Datachannel, this SDK can interconnect with the Web side [plug-in](https://github.com/cdnbye/hlsjs-p2p-engine) of CDNBye, which greatly increases the number of nodes in the P2P network, breaking the gap between the browser and mobile application. Merely a few lines of codes are required to quickly integrate into existing projects. As expected, it supports any iOS player!

## Features
- Interconnect with CDNBye [hlsjs-p2p-engine](https://github.com/cdnbye/hlsjs-p2p-engine)
- Support live and VOD streams over HLS protocol(m3u8)
- Support encrypted HLS stream
- Very easy to  integrate with an existing ios project
- Support any iOS player
- Efficient scheduling policies to enhance the performance of P2P streaming
- Highly configurable
- Use IP database to group up peers by ISP and regions

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate CDNByeSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
# Uncomment the next line if you're using Swift
# use_frameworks!
pod 'CDNByeSDK'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage
See [document](https://docs.cdnbye.com/#/en/ios/usage)

## Requirements
This library requires iOS 9.0+.
<br>NOTICE: This framework doesn’t support bitcode currently.

## API and Configuration
See [API.md](https://docs.cdnbye.com/#/en/ios/API)

## Issue & Feature Request
- If you found a bug, open an issue.
- If you have a feature request, open an issue.

## Related Projects
- [android-p2p-engine](https://github.com/cdnbye/android-p2p-engine) -  iOS Video P2P Engine for Any Player.
- [flutter-p2p-engine](https://github.com/cdnbye/flutter-p2p-engine) - Live/VOD P2P Engine for Flutter, contributed by [mjl0602](https://github.com/mjl0602).
- [hlsjs-p2p-engine](https://github.com/cdnbye/hlsjs-p2p-engine) - Web Video Delivery Technology with No Plugins.

## FAQ
We have collected some [frequently asked questions](https://docs.cdnbye.com/#/en/FAQ). Before reporting an issue, please search if the FAQ has the answer to your problem.

## Contact Us
Email：service@cdnbye.com
