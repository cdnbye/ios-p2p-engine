//
//  CBP2pEngine.h
//  WebRTC
//
//  Created by cdnbye on 2019/5/14.
//  Copyright © 2019 cdnbye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBP2pConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * _Nonnull (^ChannelId) (NSString * _Nonnull urlString);

extern NSString *kP2pEngineDidReceiveStatistics ;

@interface CBP2pEngine : NSObject

/** The version of SDK. SDK的版本号 */
@property(nonatomic, copy, readonly, class) NSString *engineVersion;

/** The version of p2p protocol. p2p私有协议的版本号 */
@property(nonatomic, copy, readonly, class) NSString *dcVersion;

/** Get the connection state of p2p engine. 获取P2P Engine的连接状态 */
@property(nonatomic, assign, readonly) BOOL connected;

/** Get the peer ID of p2p engine. 获取P2P Engine的peer ID */
@property(nonatomic, copy, readonly) NSString *peerId;

/** Some m3u8 urls play the same live/vod but have different paths on them. For example, example.com/clientId1/file.m3u8 and example.com/clientId2/file.m3u8. In this case, you can format a common channelId for them.
    构造一个共同的chanelId，使实际观看同一直播/视频的节点处在相同频道中。 */
@property (nonatomic, strong) ChannelId channelId;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new instance with token and the specified config.
 Multiple instances will make the p2p unstable.
 
 @param token  The token which can be obtained from CDNBye console.
 @param config  The specified p2p config or nil.
 @result A new engine object.
 */
- (instancetype)initWithToken:(NSString *)token andP2pConfig:(nullable CBP2pConfig *)config NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(token:p2pConfig:));

/**
 Get the shared instance of CBP2pEngine.
 Please call [CBP2pEngine initWithToken: andP2pConfig:] before calling it.
 */
+ (instancetype)sharedInstance;

/**
 Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
 
 @param url  The original stream url(m3u8).
 @result A parsed local http url.
 */
- (NSURL *)parseStreamURL:(NSURL *)url NS_SWIFT_NAME(parse(streamURL:));

/**
 Stop p2p and free used resources.
 */
- (void)stopP2p;

/**
 Restart p2p engine.
 */
- (void)restartP2p;

@end

NS_ASSUME_NONNULL_END
