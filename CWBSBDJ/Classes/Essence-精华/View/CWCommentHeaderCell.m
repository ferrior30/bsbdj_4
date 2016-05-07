//
//  CWCommentHeaderCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/7.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWCommentHeaderCell.h"
#import "UIView+CWFrame.h"

@implementation CWCommentHeaderCell

//+ (instancetype)commentHeader {
//    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([[self superclass] class]) owner:nil options:nil].firstObject;
//    
////     return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CWTopicCell class]) owner:nil options:nil].firstObject;
//}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += CWMargin;
    
    [[self superclass] setFrame: frame];
}
@end
