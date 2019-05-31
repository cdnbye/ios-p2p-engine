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

@property(nonatomic, copy, readonly, class) NSString *engineVersion;

@property(nonatomic, copy, readonly, class) NSString *dcVersion;

@property(nonatomic, assign) BOOL p2pEnabled;

- (instancetype)initWithToken:(NSString *)token andP2pConfig:(nullable CBP2pConfig *)config;

- (NSURL *)parseStreamURL:(NSString *)origin;

- (void)destroy;


@end

NS_ASSUME_NONNULL_END
