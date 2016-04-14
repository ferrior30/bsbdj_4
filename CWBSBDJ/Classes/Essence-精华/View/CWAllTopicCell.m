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

/** ding */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** cai */
@property (weak, nonatomic) IBOutlet UIButton *caibutton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@end

@implementation CWAllTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
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
    
    // 设置底部工具条上按钮数字
    [self setButton:self.dingButton number:topic.ding title:@"顶"];
    [self setButton:self.caibutton number:topic.cai title:@"踩"];
    [self setButton:self.shareButton number:topic.repost title:@"分享"];
    [self setButton:self.commentButton number:topic.comment title:@"评论"];

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
    
    frame.origin.y += CWMargin;
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
