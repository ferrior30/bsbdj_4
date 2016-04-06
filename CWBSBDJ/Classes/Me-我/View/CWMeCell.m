//
//  CWMeCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/6.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWMeCell.h"
#import "UIView+CWFrame.h"

@implementation CWMeCell
/** 初始化 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image == nil)  return;

    self.imageView.frame = CGRectMake(self.imageView.x, CWMargin / 2, self.height - CWMargin, self.height - CWMargin);
    
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + CWMargin;
}

@end
