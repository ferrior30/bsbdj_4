//
//  CWAllTopicCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWAllTopicCell.h"
#import "CWTopic.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+CWExtension.h"


///**
//
//@property (nonatomic, copy) NSString *name;
///** 用户的头像 */
//@property (nonatomic, copy) NSString *profile_image;
///** 帖子的文字内容 */
//@property (nonatomic, copy) NSString *text;
///** 帖子审核通过的时间 */
//@property (nonatomic, copy) NSString *created_at;
///** 顶数量 */
//@property (nonatomic, assign) NSInteger ding;
///** 踩数量 */
//@property (nonatomic, assign) NSInteger cai;
///** 转发\分享数量 */
//@property (nonatomic, assign) NSInteger repost;
///** 评论数量 */
//@property (nonatomic, assign) NSInteger comment;
// */

@interface CWAllTopicCell()
/** 用户头像imageView */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称label */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间label */
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
/** 帖子文字内容label */
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@end

@implementation CWAllTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 设置数据 */
- (void)setTopic:(CWTopic *)topic {
    _topic = topic;
    
    // 设置头像
    NSURL *url = [NSURL URLWithString:topic.profile_image];
    [self.profileImageView cw_setCircleIconWithURL:url];
    
    // 昵称
    self.nameLabel.text = topic.name;
    
    // 时间
    self.createdAt.text = topic.created_at;
    
    // 正文
    self.text_label.text = topic.text;
}

@end
