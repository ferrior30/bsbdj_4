//
//  CWPlayBackViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/15.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWPlayBackViewController.h"

@interface CWPlayBackViewController ()
{
    AVPlayer *_player;
    id _tiemObserver;
}
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (strong, nonatomic) AVURLAsset *asset;

@end

@implementation CWPlayBackViewController

static int  CWPlayBackViewControllerKVOContext = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:&CWPlayBackViewControllerKVOContext];
//    [self addObserver:self forKeyPath:@"play.rate" options:NSKeyValueObservingOptionNew context:&CWPlayBackViewControllerKVOContext];
    
    
    self.playerLayer.player = self.player;
    
    // 更新UI
    __weak typeof(self) weakSelf = self;
    _tiemObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat timeSeconds = CMTimeGetSeconds(weakSelf.player.currentTime);
        
        int minutes = truncf(timeSeconds / 60);
        int secondes = truncf(timeSeconds - minutes * 60);
        
        weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes, secondes];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.view.frame = CGRectMake(0, 0, 20, 500);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"URL"];
    [self.player removeTimeObserver:_tiemObserver];
}

// MARK : Properties
- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

// MARK: IBAction
- (IBAction)playOrPause:(UIButton *)sender {
    if (self.player.rate == 0) {
        [sender setImage:[UIImage imageNamed:@"PlayButton"] forState:UIControlStateNormal];
        [self.player play];
    }else {
        [sender setImage:[UIImage imageNamed:@"PlayButton"] forState:UIControlStateNormal];
        [self.player pause];
    }
    NSLog(@"%s", __func__);

}
- (IBAction)sliderValueChanged:(UISlider *)sender {
     NSLog(@"%s", __func__);
}

// MARK: - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 不是我们的KVO
    if (context != &CWPlayBackViewControllerKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    // URL
    if ([keyPath  isEqual: @"URL"]) {
        NSURL *URL = change[NSKeyValueChangeNewKey];
        self.asset = [AVURLAsset assetWithURL:URL];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
        [self.player replaceCurrentItemWithPlayerItem:item];
        
        CGFloat timeSeconds = CMTimeGetSeconds(self.player.currentTime);
        int minutes = truncf(timeSeconds / 60);
        int secondes = truncf(timeSeconds - minutes * 60);
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes, secondes];
    }
}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.URL = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0405/5703818976ef5_wpd.mp4"];
//}

@end
