**[English](README.md) | 简体中文**

<h1 align="center"><a href="" target="_blank" rel="noopener noreferrer"><img width="250" src="https://github.com/cdnbye/hlsjs-p2p-engine/blob/master/figs/cdnbye.png" alt="cdnbye logo"></a></h1>
<h4 align="center">视频/直播APP省流量&加速神器.</h4>
<p align="center">
<a href="https://cocoapods.org/pods/CDNByeSDK"><img src="https://img.shields.io/cocoapods/v/CDNByeSDK.svg?style=flat" alt="version"></a>
<a href="https://cocoapods.org/pods/CDNByeSDK"><img src="https://img.shields.io/cocoapods/p/CDNByeSDK.svg?style=flat" alt="platform"></a>
</p>

P2P技术使观看相同内容的用户之间可以相互分享数据，不仅能效降低视频/直播的带宽成本，还可以提升用户的播放体验，降低卡顿、二次缓存的发生率。本SDK传输能力基于WebRTC Datachannel，可以与CDNBye的[Web端插件](https://github.com/cdnbye/hlsjs-p2p-engine)互联互通，大大提高了P2P网络中的节点数量，打破了浏览器与移动端APP的隔阂，实现了真正意义上的全平台流媒体加速。只需要几行代码即可快速集成到现有项目中，配置自由度高，支持任何iOS播放器，支持高度定制以及二次开发。

该插件的优势如下：
- 完全免费
- 可与CDNBye Web端[P2P插件](https://github.com/cdnbye/hlsjs-p2p-engine)互联互通
- 支持基于HLS流媒体协议(m3u8)的直播和点播场景
- 几行代码即可在现有项目中快速集成
- 支持任何播放器
- 通过预加载形式实现P2P加速，完全不影响用户的播放体验
- 高可配置化，用户可以根据特定的使用环境调整各个参数
- 通过有效的调度策略来保证用户的播放体验以及p2p分享率
- Tracker服务器根据访问IP的ISP、地域等进行智能调度
- API已经固化，新版本完全兼容旧版本代码

## 安装方法

[CocoaPods](https://cocoapods.org/) 是针对 Objective-C 的依赖管理工具，它能够将使用第三方库的安装过程变得非常简单和自动化，你能够用下面的命令来安装它：

```bash
$ sudo gem install cocoapods
```

#### Podfile

为了使用 CoacoaPods 集成 CDNByeKit 到你的 Xcode 工程当中，你需要编写你的 `Podfile`

```ruby
target 'TargetName' do
pod 'CDNByeSDK'
end
```

然后，运行如下的命令：

```bash
$ pod install
```

## API文档

## 后台管理系统

## 反馈及意见

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 issues 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 Labels 中指明类型为 bug 或者其他。

## FAQ
我们收集了一些[常见问题](https://docs.cdnbye.com/#/FAQ)。在报告issue之前请先查看一下。

## 联系我们
邮箱：service@cdnbye.com
