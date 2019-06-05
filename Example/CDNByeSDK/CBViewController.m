
//  Created by cdnbye on 2019/5/31.
//  Copyright © 2019 cdnbye. All rights reserved.
//

#import "CBViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <CDNByeKit/CBP2pEngine.h>

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface CBViewController ()
@property (strong, nonatomic) AVPlayerViewController *player;
@property (strong, nonatomic) CBP2pEngine *engine;

@property (assign, nonatomic) double totalHttpDownloaded;
@property (assign, nonatomic) double totalP2pDownloaded;
@property (assign, nonatomic) double totalP2pUploaded;
@property (strong, nonatomic) NSArray *peers;
@property (strong, nonatomic) UILabel *labelOffload;
@property (strong, nonatomic) UILabel *labelRatio;
@property (strong, nonatomic) UILabel *labelUpload;
@property (strong, nonatomic) UILabel *labelP2pEnabled;
@property (strong, nonatomic) UILabel *labelPeers;
@property (strong, nonatomic) UILabel *labelVersion;

@end

@implementation CBViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.player = [[AVPlayerViewController alloc] init];
    CBP2pConfig *config = [CBP2pConfig defaultConfiguration];
    //    config.logLevel =  CBLogLevelDebug;
    config.tag = @"avplayer";
    self.engine = [[CBP2pEngine alloc] initWithToken:@"free" andP2pConfig:config];
    
    NSURL *url = [self.engine parseStreamURL:@"https://video-dev.github.io/streams/x36xhzz/url_2/193039199_mp4_h264_aac_ld_7.m3u8"];
    self.player.player = [[AVPlayer alloc] initWithURL:url];
    
    self.player.view.frame = CGRectMake(0, 40, SCREEN_WIDTH, 300);
    [self.view addSubview:self.player.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMsg:) name:kP2pEngineDidReceiveStatistics object:nil];
    
    [self.player.player play];
    
    [self showStatisticsView];
}
/*
 Get the downloading statistics, including totalP2PDownloaded, totalP2PUploaded and totalHTTPDownloaded.
 */
- (void)didReceiveMsg:(NSNotification *)note {
    NSDictionary *dict = (NSDictionary *)note.object;
    //    NSLog(@"didReceiveMsg %@", dict);
    if (dict[@"httpDownloaded"]) {
        self.totalHttpDownloaded += [dict[@"httpDownloaded"] doubleValue]/1024;
    } else if (dict[@"p2pDownloaded"]) {
        self.totalP2pDownloaded += [dict[@"p2pDownloaded"] doubleValue]/1024;
    } else if (dict[@"p2pUploaded"]) {
        self.totalP2pUploaded += [dict[@"p2pUploaded"] doubleValue]/1024;
    } else if (dict[@"peers"]) {
        self.peers = (NSArray *)dict[@"peers"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatistics];
    });
}

- (void)showStatisticsView {
    UIView *statsView = [[UIView alloc] initWithFrame:CGRectMake(5, 350, SCREEN_WIDTH-10, 300)];
    statsView.autoresizesSubviews = YES;
    [self.view addSubview:statsView];
    
    CGFloat height = 40;
    CGFloat width = 160;
    UILabel *labelOffload = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, width, height)];
    labelOffload.layer.borderColor = [UIColor greenColor].CGColor;
    [statsView addSubview:labelOffload];
    self.labelOffload = labelOffload;
    
    UILabel *labelRatio = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-20, 10, width, height)];
    labelRatio.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [statsView addSubview:labelRatio];
    self.labelRatio = labelRatio;
    
    UILabel *labelUpload = [[UILabel alloc] initWithFrame:CGRectMake(10, height+30, width, height)];
    labelUpload.layer.borderColor = [UIColor blueColor].CGColor;
    [statsView addSubview:labelUpload];
    self.labelUpload = labelUpload;
    
    UILabel *labelP2pEnabled = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-20, height+30, width, height)];
    labelP2pEnabled.layer.borderColor = [UIColor redColor].CGColor;
    [statsView addSubview:labelP2pEnabled];
    self.labelP2pEnabled = labelP2pEnabled;
    
    UILabel *labelPeers = [[UILabel alloc] initWithFrame:CGRectMake(10, 2*height+50, width, height)];
    labelPeers.layer.borderColor = [UIColor purpleColor].CGColor;
    [statsView addSubview:labelPeers];
    self.labelPeers = labelPeers;
    
    UILabel *labelVersion = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-20, 2*height+50, width, height)];
    labelVersion.layer.borderColor = [UIColor brownColor].CGColor;
    [statsView addSubview:labelVersion];
    self.labelVersion = labelVersion;
    self.labelVersion.text = [NSString stringWithFormat:@"Version: %@", CBP2pEngine.engineVersion];
    
    for (UILabel *label in statsView.subviews) {
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.layer.borderWidth = 2;
    }
    
    [self updateStatistics];
}

- (void)updateStatistics {
    double ratio = 0;
    if (self.totalHttpDownloaded != 0) {
        ratio = self.totalP2pDownloaded/(self.totalP2pDownloaded+self.totalHttpDownloaded);
    }
    self.labelOffload.text = [NSString stringWithFormat:@"Offload: %.2fMB", self.totalP2pDownloaded];
    self.labelUpload.text = [NSString stringWithFormat:@"Upload: %.2fMB", self.totalP2pUploaded];
    self.labelRatio.text = [NSString stringWithFormat:@"P2P Ratio: %.0f%%", ratio*100];
    self.labelPeers.text = [NSString stringWithFormat:@"Peers: %@", @(self.peers.count)];
    
    NSString *state = @"Yes";
    if (!self.engine.connected) {
        state = @"No";
    }
    self.labelP2pEnabled.text = [NSString stringWithFormat:@"Connected: %@", state];
}

@end
