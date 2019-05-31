//
//  CBViewController.m
//  CDNByeSDK
//
//  Created by snowinszu on 05/30/2019.
//  Copyright (c) 2019 snowinszu. All rights reserved.
//

#import "CBViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <CDNByeKit/CBP2pEngine.h>

@interface CBViewController ()

@property (strong, nonatomic)AVPlayerViewController *player;


@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.player.player play];
}

- (AVPlayerViewController *)player{
    if (!_player) {
        _player = [[AVPlayerViewController alloc] init];
        CBP2pConfig *config = [CBP2pConfig defaultConfiguration];
        //        config.announce = @"https://tracker.cdnbye.com:8090";
        config.logLevel =  CBLogLevelDebug;
        //        config.downloadTimeout = 3;
        CBP2pEngine *engine = [[CBP2pEngine alloc] initWithToken:@"free" andP2pConfig:config];
        
        NSURL *url = [engine parseStreamURL:@"https://video-dev.github.io/streams/x36xhzz/url_2/193039199_mp4_h264_aac_ld_7.m3u8"];
        
        _player.player = [[AVPlayer alloc] initWithURL:url];
        
        // 全屏播放
        //        [self presentViewController: self.player animated:YES completion:nil];
        
        
        self.player.view.frame = CGRectMake(0, 100, 400, 400);
        [self.view addSubview:self.player.view];
    }
    return _player;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
