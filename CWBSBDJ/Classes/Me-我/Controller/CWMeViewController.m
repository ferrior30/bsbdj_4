//
//  CWMeViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWMeViewController.h"

@interface CWMeViewController ()

@end

@implementation CWMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航栏
    [self setupNav];
}

/**
 *  设置导航栏
 */
- (void)setupNav {
    // 1.设置中间title
    self.navigationItem.title = @"我的";
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//    [self.navigationItem setTitleView:imageV];
    
    // 2.设置右边图标
    UIButton *btn = [[UIButton alloc] init];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(mineSettingIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 sizeToFit];
    [btn2 setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(mineMoonIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    [self.navigationItem setRightBarButtonItems:@[btnItem, btnItem2]];
}

#pragma mark - 监听
/** 监听【设置】按钮 */
- (void)mineSettingIconClick {
    CWLogFunc;
}

/** 监听【月亮】按钮 */
- (void)mineMoonIconClick {
    CWLogFunc;
}

@end
