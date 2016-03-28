//
//  UIView+CWFrame.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/28.
//  Copyright © 2016年 cw. All rights reserved.
//
/**
 *  快速设置控件的frame
 *
 *  @param CWFrame 快速设置控件的frame
 *
 */

#import <UIKit/UIKit.h>

@interface UIView (CWFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@end
