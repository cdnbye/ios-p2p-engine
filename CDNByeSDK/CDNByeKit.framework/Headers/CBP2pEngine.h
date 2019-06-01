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

extern NSString *kP2pEngineDidReceiveStatistics ;

@interface CBP2pEngine : NSObject

/** The version of SDK. SDK的版本号 */
@property(nonatomic, copy, readonly, class) NSString *engineVersion;

/** The version of p2p protocol. p2p私有协议的版本号 */
@property(nonatomic, copy, readonly, class) NSString *dcVersion;

/** Enable or disable p2p engine. 开启或关闭P2P Engine */
@property(nonatomic, assign) BOOL p2pEnabled;

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
 Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.
 
 @param origin  The original stream url(m3u8).
 @result A parsed local http url.
 */
- (NSURL *)parseStreamURL:(NSString *)origin NS_SWIFT_NAME(parse(streamURL:));

/**
 Destroy CBP2pEngine instance, stop p2p and free used resources.
 */
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
