//
//  CWTopicVideoView.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWTopicVideoView.h"
//#import "UIImageView+WebCache.h"
@import SDWebImage;
#import "CWTopic.h"
#import "CWSeeBigViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

/** 播放按钮点击通知 */
NSString * const CWVideoButtonDidClicked = @"CWVideoButtonDidClicked";

@interface CWTopicVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;


@end

@implementation CWTopicVideoView

+ (instancetype)videoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // imageView 添加手势
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithGestureRecognizer:)];
    [self.imageView addGestureRecognizer:tap];
    
}


- (void)setTopic:(CWTopic *)topic {
    _topic = topic;
    
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    // 播放次数
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

#pragma mark - 监听
/** 监听：点击手势 */
- (void)imageClickWithGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.imageView.image == nil) return;
        
        CWSeeBigViewController *bigVC = [[CWSeeBigViewController alloc] init];
        bigVC.topic = self.topic;
        
        [self.window.rootViewController presentViewController:bigVC animated:YES completion:nil];
    }
}

/** 监听：播放按钮的点击 */
- (IBAction)videoButtonDidClicked {
    NSDictionary *userInfo = @{@"topic": self.topic};
    [[NSNotificationCenter defaultCenter] postNotificationName:CWVideoButtonDidClicked object:nil userInfo:userInfo];
}


@end
