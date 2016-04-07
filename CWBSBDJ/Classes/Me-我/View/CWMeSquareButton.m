//
//  CWMeSquareButton.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/7.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWMeSquareButton.h"
#import "CWMeSquare.h"
#import "UIButton+WebCache.h"
#import "UIView+CWFrame.h"

@implementation CWMeSquareButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)setMeSquare:(CWMeSquare *)meSquare {
    _meSquare = meSquare;
    
    // 设置名字
    [self setTitle:meSquare.name forState:UIControlStateNormal];

    // 设置图片
    NSURL *url = [NSURL URLWithString:meSquare.icon];
//    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mine-setting-iconN"]];
    
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
}

/**
 *  布局
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat WH = self.width - 4 * CWMargin;

    self.imageView.frame = CGRectMake(CWMargin * 2, CWMargin, WH, WH);
    
    // titleLabel
    self.titleLabel.frame = CGRectMake(0, WH + CWMargin, self.width, CWMargin * 3);
}
@end
