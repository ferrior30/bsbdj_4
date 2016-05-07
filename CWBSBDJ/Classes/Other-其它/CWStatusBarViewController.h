//
//  CWStatusBarViewController.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/7.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWStatusBarViewController : UIViewController
+ (instancetype)shareInstance;
+ (void)show;

#pragma mark - 状态栏
/** 状态栏的显示与隐藏 */
@property (assign, nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;
/** 状态栏的样式 */
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
@end
