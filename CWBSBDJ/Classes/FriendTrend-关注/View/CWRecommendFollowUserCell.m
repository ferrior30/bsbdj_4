//
//  CWRecommendFollowUserCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWRecommendFollowUserCell.h"
#import "CWRecommendUser.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+CWExtension.h"

@interface CWRecommendFollowUserCell ()

/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
/** 关注数 */
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation CWRecommendFollowUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecommendUser:(CWRecommendUser *)recommendUser {
    _recommendUser = recommendUser;
    
    // 头像
    [self.headerImageView cw_setCircleIconWithURL:[NSURL URLWithString:recommendUser.header]];
    
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:recommendUser.header]];
    
    // 昵称
    self.screenNameLabel.text = recommendUser.screen_name;
    
    // 关注数量
    self.fansCountLabel.text = [NSString stringWithFormat:@"%@人关注", recommendUser.fans_count];
}

@end
