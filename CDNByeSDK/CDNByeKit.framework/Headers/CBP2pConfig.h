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

// WebRTC配置
@property(nonatomic, strong, nullable) RTCConfiguration *webRTCConfig;

// 信令服务器地址
@property(nonatomic, copy, nullable) NSString *wsSignalerAddr;

// tracker服务器地址
@property(nonatomic, copy, nullable) NSString *announce;

// 是否开启P2P，默认true
@property(nonatomic, assign) BOOL p2pEnabled;

// datachannel上传二进制数据的超时时间
@property(nonatomic, assign) NSTimeInterval dcUploadTimeout;

// 每次通过datachannel发送的包的大小(默认64*1024)
@property(nonatomic, assign) NSUInteger packetSize;

// 缓存大小
@property(nonatomic, assign) NSUInteger maxBufferSize;

// 下载ts文件超时时间
@property(nonatomic, assign) NSTimeInterval downloadTimeout;

// 用户自定义标签
@property(nonatomic, copy) NSString *tag;

// 代理商标识
@property(nonatomic, copy) NSString *agent;

// log的level，分为debug、info、warn、error、none
@property(nonatomic, assign) CBLogLevel logLevel;

+ (instancetype)defaultConfiguration;

- (instancetype)init;


@end

NS_ASSUME_NONNULL_END
