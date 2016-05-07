//
//  CWCommentCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/5.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWCommentCell.h"
#import "CWComment.h"
#import "CWUser.h"

#import "UIImage+CWCircleImage.h"
#import "UIButton+WebCache.h"
#import "UIView+CWFrame.h"
#import "CWProfileButton.h"

@interface CWCommentCell ()
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (weak, nonatomic) IBOutlet CWProfileButton *profileButton;
/** 性别 */
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 点赞数 */
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation CWCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(CWComment *)comment {
    _comment = comment;

    // 头像
    NSURL *url = [NSURL URLWithString:comment.user.profile_image];

    [self.profileButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return ;
        UIImage *circleImage = [image circleImage];
//        self.profileButton.imageView.frame = self.profileButton.bounds;
//        self.profileButton.imageView.contentMode = UIViewContentModeScaleToFill;
        [self.profileButton setImage:circleImage forState:UIControlStateNormal];
    }];


    // 性别
    if ([comment.user.sex  isEqual: @"m"]) {
        self.genderImageView.image = [UIImage imageNamed:@"Profile_manIcon"];
    }else {
        self.genderImageView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
    
    // 用户名
    self.userNameLabel.text = comment.user.username;
    
    // 点赞数
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    // 评论内容并计算评论内容的高度
    self.commentLabel.text = comment.content;
//    CGFloat height =

    
//    [self layoutIfNeeded];
    
}
@end
