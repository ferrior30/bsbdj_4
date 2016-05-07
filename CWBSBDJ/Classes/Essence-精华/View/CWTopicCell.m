//
//  CWTopicCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWTopicCell.h"
#import "CWTopic.h"
#import "UIImageView+CWExtension.h"
#import "CWComment.h"
#import "CWUser.h"
#import "CWTopicPictureView.h"
#import "CWTopicVideoView.h"
#import "CWTopicVoiceView.h"

@interface CWTopicCell()
/** 用户头像imageView */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称label */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间label */
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
/** 帖子文字内容label */
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** ding */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** cai */
@property (weak, nonatomic) IBOutlet UIButton *caibutton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 最新评论整体 */
@property (weak, nonatomic) IBOutlet UIView *hotCommentView;
/** 最热评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *hotCommentLabel;

/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) CWTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) CWTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) CWTopicVideoView *videoView;

@end

@implementation CWTopicCell
/** 自定义类方法 */
+ (instancetype)topicCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CWTopicCell class]) owner:nil options:nil].firstObject;
}
#pragma mark - 懒加载

/** 图片控件 */
- (CWTopicPictureView *)pictureView {
    if (_pictureView == nil) {
        _pictureView = [CWTopicPictureView pictureView];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}

/** 声音控件 */
- (CWTopicVoiceView *)voiceView {
    if (_voiceView == nil) {
        _voiceView = [CWTopicVoiceView voiceView];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}

/** 视频控件 */
- (CWTopicVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [CWTopicVideoView videoView];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    //
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 设置数据 */
- (void)setTopic:(CWTopic *)topic {
    _topic = topic;
    
    // 1.设置头像
    NSURL *url = [NSURL URLWithString:topic.profile_image];
    [self.profileImageView cw_setCircleIconWithURL:url];
    
    // 2.昵称
    self.nameLabel.text = topic.name;
    
    //3. 时间
    self.createdAt.text = topic.created_at;
    
    // 4.正文
    self.text_label.text = topic.text;
    
    // 5.设置底部工具条上按钮数字
    [self setButton:self.dingButton number:topic.ding title:@"顶"];
    [self setButton:self.caibutton number:topic.cai title:@"踩"];
    [self setButton:self.shareButton number:topic.repost title:@"分享"];
    [self setButton:self.commentButton number:topic.comment title:@"评论"];
    
    // 6.最热评论
    if (topic.top_cmt.count) { // 有最热评论
        self.hotCommentView.hidden = NO;
        
        CWComment *comment = topic.top_cmt.firstObject;
        
        self.hotCommentLabel.text = [NSString stringWithFormat:@"%@: %@", comment.user.username, comment.content];
    }else { // 没有最热评论
        // 隐藏最热评论控件
        self.hotCommentView.hidden = YES;
    }
    
    // 7. 中间控件
    if (topic.type == CWTopicTypePicture) { // 图片控件
        self.pictureView.hidden = NO;
        self.pictureView.frame = topic.centerViweFrame;
        self.pictureView.topic = topic;
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;

    }else if (topic.type == CWTopicTypeVideo) { // 视频
        self.videoView.hidden = NO;
        self.videoView.frame = topic.centerViweFrame;
        self.videoView.topic = topic;
        
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        
    }else if (topic.type == CWTopicTypeVoice){ // 声音
        self.voiceView.hidden = NO;
        self.voiceView.frame = topic.centerViweFrame;
        self.voiceView.topic = topic;
        
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }else { // 文字
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
}

/**
 *  设置底部工具条里button的title
 *
 *  @param button 按钮
 *  @param number 数字
 *  @param title  数字为0时的title
 */
- (void)setButton:(UIButton *)button number:(NSInteger)number title:(NSString *)title {
    if (number <= 0 ) {
        [button setTitle:title forState:UIControlStateNormal];
    }else if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.2f", number / 10000.0] forState:UIControlStateNormal];
    }else {
        [button setTitle:[NSString stringWithFormat:@"%ld", number] forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame {
    
    // 头部间距
    frame.origin.y += CWMargin;
    
    // 尾部间距
    frame.size.height -= CWMargin;
    
    [super setFrame:frame];
}

/**
 *  监听点击：弹出其它选项
 */
- (IBAction)moreClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CWLog(@"%s",__FUNCTION__);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CWLog(@"收藏 %s",__FUNCTION__);
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CWLog(@"举报 %s",__FUNCTION__);
    }]];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


@end
