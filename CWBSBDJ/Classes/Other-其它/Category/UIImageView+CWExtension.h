//
//  UIImageView+CWExtension.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/6.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CWExtension)
/**
 *  用默认的方式设置圆形头像（默认是圆形），及占位图片
 */
- (void)cw_setDefaultIconWithURL:(NSURL *)url;
/**
 *  设置圆形头像，及占位图片
 */
- (void)cw_setCircleIconWithURL:(NSURL *)url;
/**
 *  设置矩形头像，及占位图片
 */
- (void)cw_setSquareIconWithURL:(NSURL *)url;
@end
