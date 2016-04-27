//
//  CWTopicVideoView.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWTopicVideoView.h"
#import "UIImageView+WebCache.h"
#import "CWTopic.h"
#import "CWSeeBigViewController.h"

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
/** 监听【查看大图按钮】的点击：弹出大图控制器 */
- (IBAction)seeBigPictureButtonClick:(UIButton *)sender {
    if (self.imageView.image == nil) return;
    
    CWSeeBigViewController *bigVC = [[CWSeeBigViewController alloc] init];
    bigVC.topic = self.topic;
    
    [self.window.rootViewController presentViewController:bigVC animated:YES completion:nil];
}

@end
