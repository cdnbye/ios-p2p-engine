//
//  CBP2pConfig.h
//  WebRTC
//
//  Created by cdnbye on 2019/5/14.
//  Copyright © 2019 cdnbye. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <WebRTC/RTCConfiguration.h>

typedef NS_ENUM(NSInteger, CBLogLevel) {
    CBLogLevelNone,
    CBLogLevelDebug,
    CBLogLevelInfo,
    CBLogLevelWarn,
    CBLogLevelError,
};

NS_ASSUME_NONNULL_BEGIN

@interface CBP2pConfig : NSObject

/** WebRTC configuration. WebRTC配置 */
@property(nonatomic, strong, nullable) RTCConfiguration *webRTCConfig;

/** The address of signal server. 信令服务器地址 */
@property(nonatomic, copy, nullable) NSString *wsSignalerAddr;

/** The address of tracker server. tracker服务器地址 */
@property(nonatomic, copy, nullable) NSString *announce;

/** Enable or disable p2p engine. 是否开启P2P，默认true */
@property(nonatomic, assign) BOOL p2pEnabled;

/** The port for local http server. 本地代理服务器的端口号 */
@property(nonatomic, assign) NSUInteger localPort;    

/** Max download timeout for WebRTC datachannel. datachannel下载二进制数据的最大超时时间 */
@property(nonatomic, assign) NSTimeInterval dcDownloadTimeout;

/** The max size of binary data that can be stored in the disk for VOD. 磁盘缓存大小 */
@property(nonatomic, assign) NSUInteger diskCacheLimit;

/** The max size of binary data that can be stored in the memory cache. 内存缓存大小 */
@property(nonatomic, assign) NSUInteger memoryCacheLimit;

/** TS file download timeout. 下载ts文件超时时间 */
@property(nonatomic, assign) NSTimeInterval downloadTimeout;

/** User defined tag which is presented in console. 用户自定义标签 */
@property(nonatomic, copy) NSString *tag;

/** Identifier for agent. 代理商标识 */
@property(nonatomic, copy) NSString *agent;

/** Print log level. 打印日志级别 */
@property(nonatomic, assign) CBLogLevel logLevel;

/** Max peer connections at the same time. 最大连接节点数量 */
@property(nonatomic, assign) NSUInteger maxPeerConnections;

/** Use HTTP ranges requests where it is possible. Allows to continue (and not start over) aborted P2P downloads over HTTP. 在可能的情况下使用Http Range请求来补足p2p下载超时的剩余部分数据 */
@property(nonatomic, assign) BOOL useHttpRange;

/** Set User-Agent to http header while requesting ts. 设置请求ts时候的User-Agent */
@property(nonatomic, copy) NSString *userAgent;

/**
 Create a new instance with default configuration.
 实例化方法，用默认配置初始化。
 */
+ (instancetype)defaultConfiguration;

/**
 Create a new instance with default configuration.
 实例化方法，用默认配置初始化。
 */
- (instancetype)init;


@end

NS_ASSUME_NONNULL_END
