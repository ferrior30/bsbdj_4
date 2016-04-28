//
//  CWFriendTrendViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWFriendTrendViewController.h"
#import "UIBarButtonItem+CWExtention.h"
#import "CWLoginRegisterViewController.h"
#import "CWRecommendFollowViewController.h"

@interface CWFriendTrendViewController ()

@end

@implementation CWFriendTrendViewController

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
    self.navigationItem.title = @"我的关注";
    
    // 2.设置左边图标
    UIBarButtonItem *item = [UIBarButtonItem barButtonItemWithImageName:@"friendsRecommentIcon" highlightedImageName:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecommentIconClick)];
    
    [self.navigationItem setLeftBarButtonItem:item];
}

/**
 *  监听：导航栏左边按钮的点击,弹出推荐关注界面
 */
- (void)friendsRecommentIconClick {
    
    CWRecommendFollowViewController *followVC = [[CWRecommendFollowViewController alloc] init];
    
    [self.navigationController pushViewController:followVC animated:YES];
}
/** 监听：【登陆和注册】按钮点击 */
- (IBAction)loginRegister {
    CWLoginRegisterViewController *loginRegisterVC = [[CWLoginRegisterViewController alloc] init];
    
    [self.navigationController presentViewController:loginRegisterVC animated:YES completion:nil];
}


@end
