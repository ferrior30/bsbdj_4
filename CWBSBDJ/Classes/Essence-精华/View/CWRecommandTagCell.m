//
//  CWRecommandTagCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/29.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWRecommandTagCell.h"
#import "CWRecommandTag.h"
#import "UIImageView+WebCache.h"
#import "UIImage+CWCircleImage.h"

/**
@property (nonatomic, copy) NSString *theme_name;

@property (nonatomic, copy) NSString *image_list;

@property (nonatomic, assign) NSInteger sub_number;

*/

@interface CWRecommandTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation CWRecommandTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 获取模型时设置UI界面 */
- (void)setRecommandTag:(CWRecommandTag *)recommandTag {
    _recommandTag = recommandTag;
    
    // 头像
    NSURL *url = [NSURL URLWithString:recommandTag.image_list];
    
//    [self.imageListImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    [self.imageListImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        image = nil;
        if (image == nil) return ;
        UIImage *circleImage = [image circleImage];
        self.imageListImageView.image = circleImage;
    }];
    
    // 主题文字
    self.themeNameLabel.text = recommandTag.theme_name;
    
    // 订阅数
    if (recommandTag.sub_number > 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", recommandTag.sub_number / 10000.0];
    }else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%ld", recommandTag.sub_number];
    }
}

/** 设置分隔线 */
- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
