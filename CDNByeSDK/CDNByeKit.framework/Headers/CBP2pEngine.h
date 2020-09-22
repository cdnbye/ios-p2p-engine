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

typedef NSString * _Nonnull (^SegmentId) (NSUInteger level, NSUInteger sn, NSString * _Nonnull urlString);

extern NSString *kP2pEngineDidReceiveStatistics ;

@protocol CBP2pEngineDelegate <NSObject>
    
@optional

- (NSTimeInterval)bufferedDuration;

@end

@interface CBP2pEngine : NSObject

/** The config of SDK. SDK的P2P配置 */
@property(nonatomic, strong) CBP2pConfig *p2pConfig;

/** The version of SDK. SDK的版本号 */
@property(nonatomic, copy, readonly, class) NSString *engineVersion;

/** The version of p2p protocol, ，only have the same protocol version as another platform can both interconnect with each other. p2p私有协议的版本号，与其他平台互通的前提是 P2P 协议版本号相同。 */
@property(nonatomic, copy, readonly, class) NSString *dcVersion;

/** Get the connection state of p2p engine. 获取P2P Engine的连接状态 */
@property(nonatomic, assign, readonly) BOOL connected;

/** Get the peer ID of p2p engine. 获取P2P Engine的peer ID */
@property(nonatomic, copy, readonly) NSString *peerId;

/** Pass a block to generate segment Id. 产生标识ts文件的字符串的block。*/
@property (nonatomic, strong) SegmentId segmentId;

/** The delegate of Player Stats. */
@property (nonatomic, weak) id<CBP2pEngineDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

/**
 Start p2p engine with token and the specified config.
 
 @param token  The token which can be obtained from CDNBye console.
 @param config  The specified p2p config or nil.
 */
- (void)startWithToken:(NSString *)token andP2pConfig:(nullable CBP2pConfig *)config NS_SWIFT_NAME(start(token:p2pConfig:));

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
Get parsed local stream url by passing the original stream url(m3u8) to CBP2pEngine instance.

@param url  The original stream url(m3u8).
 @param videoId  video Id for the given url.
@result A parsed local http url.
*/
- (NSURL *)parseStreamURL:(NSURL *)url withVideoId:(NSString *)videoId;

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
