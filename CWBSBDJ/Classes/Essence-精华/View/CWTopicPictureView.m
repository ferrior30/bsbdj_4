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

@interface CWTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

/** gif图标 */
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
/** 【查看大图】button */
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end


@implementation CWTopicPictureView
+ (instancetype)picture {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
/** 处理数据 */
- (void)setTopic:(CWTopic *)topic {
    _topic = topic;
    
    self.pictureImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (topic.isBigPicture) {
        self.pictureImageView.contentMode = UIViewContentModeTopLeft;
    }else {
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    // 图片
    NSURL *url = [NSURL URLWithString:topic.small_image];
    [self.pictureImageView sd_setImageWithURL:url];
    
    // gif图片
    self.gifImageView.hidden = !topic.is_gif;
    
    // 查看大图
    self.seeBigPictureButton.hidden = !topic.isBigPicture;
}

#pragma mark - 监听
/** 监听【查看大图按钮】的点击 */
- (IBAction)seeBigPictureButtonClick:(UIButton *)sender {
    CWLog(@"%s", __func__);
}

@end