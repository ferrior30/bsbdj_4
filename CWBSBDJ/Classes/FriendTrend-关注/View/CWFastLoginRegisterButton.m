//
//  CWFastLoginRegisterButton.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWFastLoginRegisterButton.h"
#import "UIView+CWFrame.h"

@interface CWFastLoginRegisterButton ()
//@property (assign, nonatomic) CGFloat newheight;
//@property (assign, nonatomic) CGFloat titleHeight;
@end

@implementation CWFastLoginRegisterButton
/** 初始化化设置 */
- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
