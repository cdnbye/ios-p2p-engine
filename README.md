**English | [简体中文](Readme_zh.md)**

<h1 align="center"><a href="" target="_blank" rel="noopener noreferrer"><img width="250" src="https://github.com/cdnbye/hlsjs-p2p-engine/blob/master/figs/cdnbye.png" alt="cdnbye logo"></a></h1>
<h4 align="center">Save Your Bandwidth using WebRTC.</h4>
<p align="center">
<a href="https://cocoapods.org/pods/CDNByeSDK"><img src="https://img.shields.io/cocoapods/v/CDNByeSDK.svg?style=flat" alt="version"></a>
<a href="https://cocoapods.org/pods/CDNByeSDK"><img src="https://img.shields.io/cocoapods/p/CDNByeSDK.svg?style=flat" alt="platform"></a>
</p>

CDNBye iOS P2P Engine implements [WebRTC](https://en.wikipedia.org/wiki/WebRTC) datachannel to scale live/vod video streaming by peer-to-peer network using bittorrent-like protocol.

## Features
- Totally free at charge
- Interconnect with CDNBye [hlsjs-p2p-engine](https://github.com/cdnbye/hlsjs-p2p-engine)
- Support live and VOD streams over HLS protocol(m3u8)
- Very easy to  integrate with an existing ios project
- Support any iOS player
- Efficient scheduling policies to enhance the performance of P2P streaming
- Highly configurable
- Use IP database to group up peers by ISP and regions
- API frozen, new releases will not break your code

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate CDNByeKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
pod 'CDNByeSDK'
end
```

Then, run the following command:

```bash
$ pod install
```

## API and Configuration

## Console

## Issue & Feature Request
- If you found a bug, open an issue.
- If you have a feature request, open an issue.

## FAQ
We have collected some [frequently asked questions](https://docs.cdnbye.com/#/en/FAQ). Before reporting an issue, please search if the FAQ has the answer to your problem.

## Contact Us
Email：service@cdnbye.com
