//
//  CWTopicPictureView.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/14.
//  Copyright © 2016年 CW. All rights reserved.
//
#import "CWTopicPictureView.h"
#import "UIImageView+WebCache.h"
#import "CWTopic.h"
#import "UIView+CWFrame.h"
#import "DALabeledCircularProgressView.h"
#import "CWSeeBigViewController.h"

@interface CWTopicPictureView ()

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** gif图标 */
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
/** 【查看大图】button */
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
/** 图片图形下载进度 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

/** 下载时显示的占位图片 */
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@end


@implementation CWTopicPictureView


//+ (instancetype)picture {
//    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
//}
+ (instancetype)pictureView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 进度条设置
    self.progressView.roundedCorners = 20;
    
    // imageView 添加手势
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickWithGestureRecognizer:)];
    [self.imageView addGestureRecognizer:tap];
    
}

/** 处理数据 */
- (void)setTopic:(CWTopic *)topic {
    _topic = topic;
   
    // 图片
    NSURL *url = [NSURL URLWithString:topic.large_image];
    
    [self.pictureImageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (receivedSize < 0 || expectedSize < 0) return;
        
        // 显示下载时的占位图片
        self.placeholderView.hidden = NO;
        // 显示下载进度条
        self.progressView.hidden = NO;
        // 设置进度值
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        self.progressView.progress = progress;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         // 隐藏下载进度条
        self.progressView.hidden = YES;
        // 隐藏下载时的占位图片
        self.placeholderView.hidden = YES;
    }];

    // 是否是gif图片
    self.gifImageView.hidden = !topic.is_gif;
    
    // 查看大图
    self.seeBigPictureButton.hidden = !topic.isBigPicture;
    
    if (topic.isBigPicture) { // 是大图
        self.pictureImageView.contentMode = UIViewContentModeTop;
        self.pictureImageView.clipsToBounds = YES;
    }else { // 不是大图
        self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
        self.pictureImageView.clipsToBounds = NO;
    }
}

#pragma mark - 监听
/** 监听【查看大图按钮】的点击：弹出大图控制器 */
- (IBAction)seeBigPictureButtonClick:(UIButton *)sender {
    if (self.imageView.image == nil) return;
    
    CWSeeBigViewController *bigVC = [[CWSeeBigViewController alloc] init];
    bigVC.topic = self.topic;
    
    [self.window.rootViewController presentViewController:bigVC animated:YES completion:nil];
}
/** 监听：图片的点击手势 */
- (void)imageClickWithGestureRecognizer:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self seeBigPictureButtonClick:self.seeBigPictureButton];
    }
}


@end