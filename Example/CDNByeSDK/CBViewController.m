//
//  ViewController.m
//  SDKTest
//
//  Created by cdnbye on 2019/5/31.
//  Copyright © 2019 cdnbye. All rights reserved.
//

#import "CBViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <CDNByeKit/CBP2pEngine.h>

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

NSString *VOD_URL = @"http://cn1.kankia.com/hls/20191220/596ff11e1db2c3969da01367fc41d3b0/1576776716/index.m3u8";
NSString *LIVE_URL = @"http://hefeng.live.tempsource.cjyun.org/videotmp/s10100-hftv.m3u8";

@interface CBViewController ()
@property (strong, nonatomic) AVPlayerViewController *playerVC;
@property (strong, nonatomic) NSString *urlString;

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
@property (strong, nonatomic) UIButton *buttionReplay;
@property (strong, nonatomic) UIButton *buttionSwitch;
@property (strong, nonatomic) UIButton *buttionLive;
@property (strong, nonatomic) UIButton *buttionVod;

@end

@implementation CBViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.playerVC = [[AVPlayerViewController alloc] init];
    
    self.urlString = VOD_URL;
    NSURL *originalUrl = [NSURL URLWithString:self.urlString];
    NSURL *parsedUrl = [[CBP2pEngine sharedInstance] parseStreamURL:originalUrl];
    self.playerVC.player = [[AVPlayer alloc] initWithURL:parsedUrl];
    
    self.playerVC.view.frame = CGRectMake(0, 40, SCREEN_WIDTH, 300);
    [self.view addSubview:self.playerVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMsg:) name:kP2pEngineDidReceiveStatistics object:nil];
    
    [self.playerVC.player play];
    
    [self showStatisticsView];
    [self showButtonView];
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
    //    statsView.backgroundColor = [UIColor redColor];
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
    if (![CBP2pEngine sharedInstance].connected) {
        state = @"No";
    }
    self.labelP2pEnabled.text = [NSString stringWithFormat:@"Connected: %@", state];
}

- (void)showButtonView {
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(5, 530, SCREEN_WIDTH-10, 300)];
    btnView.autoresizesSubviews = YES;
    [self.view addSubview:btnView];
    
    CGFloat height = 40;
    CGFloat width = 160;
    UIButton *btnReplay = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, width, height)];
    btnReplay.backgroundColor = [UIColor greenColor];
    [btnReplay setTitle:@"Replay" forState:UIControlStateNormal];
    [btnView addSubview:btnReplay];
    self.buttionReplay = btnReplay;
    [btnReplay addTarget:self action:@selector(btnReplayClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSwitch = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-20, 10, width, height)];
    btnSwitch.backgroundColor = [UIColor purpleColor];
    [btnSwitch setTitle:@"Switch" forState:UIControlStateNormal];
    [btnView addSubview:btnSwitch];
    self.buttionSwitch = btnSwitch;
    [btnSwitch addTarget:self action:@selector(btnSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnVod = [[UIButton alloc] initWithFrame:CGRectMake(10, height+30, width, height)];
    btnVod.backgroundColor = [UIColor cyanColor];
    [btnVod setTitle:@"VOD" forState:UIControlStateNormal];
    [btnView addSubview:btnVod];
    self.buttionVod = btnVod;
    [btnVod addTarget:self action:@selector(btnVodClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnLive = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-width-20, height+30, width, height)];
    btnLive.backgroundColor = [UIColor orangeColor];
    [btnLive setTitle:@"Live" forState:UIControlStateNormal];
    [btnView addSubview:btnLive];
    self.buttionLive = btnLive;
    [btnLive addTarget:self action:@selector(btnLiveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIButton *btn in btnView.subviews) {
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 10;
    }
}

-(void)btnReplayClick:(UIButton *)button {
    if (!self.urlString) return;
    [self.playerVC.player pause];
    NSURL *originalUrl = [NSURL URLWithString:self.urlString];
    NSURL *parsedUrl = [[CBP2pEngine sharedInstance] parseStreamURL:originalUrl];
    self.playerVC.player = nil;
    self.playerVC.player = [[AVPlayer alloc] initWithURL:parsedUrl];
    [self.playerVC.player play];
    
    [self clearData];
    [self updateStatistics];
}

-(void)btnSwitchClick:(UIButton *)button {
    if ([self.urlString isEqualToString:VOD_URL]) {
        self.urlString = LIVE_URL;
    } else {
        self.urlString = VOD_URL;
    }
    [self btnReplayClick:nil];
}

-(void)btnVodClick:(UIButton *)button {
    self.urlString = VOD_URL;
    [self btnReplayClick:nil];
}

-(void)btnLiveClick:(UIButton *)button {
    self.urlString = LIVE_URL;
    [self btnReplayClick:nil];
}

- (void)clearData {
    self.totalHttpDownloaded = 0;
    self.totalP2pDownloaded = 0;
    self.totalP2pUploaded = 0;
}

@end
