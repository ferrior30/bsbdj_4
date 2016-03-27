//
//  CWEssenceViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWEssenceViewController.h"

@interface CWEssenceViewController ()

@end

@implementation CWEssenceViewController

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
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    [self.navigationItem setTitleView:imageV];
    
    // 2.设置左边图标
    UIButton *btn = [[UIButton alloc] init];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(MainTagSubIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:btnItem];
}

/**
 *  监听：导航栏左边按钮的点击
 */
- (void)MainTagSubIconClick {
    CWLogFunc;
}

@end
