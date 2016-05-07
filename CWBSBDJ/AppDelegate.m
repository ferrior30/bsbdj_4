//
//  AppDelegate.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/7.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "AppDelegate.h"
#import "CWTabBarController.h"
#import "CWStatusBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    UIWindow *window = [[UIWindow alloc] init];
    window.frame = [UIScreen mainScreen].bounds;
    self.window = window;
    
    // 2.设置根控制器
    self.window.rootViewController = [[CWTabBarController alloc] init];
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    // 4.添加状态栏 // 添加后系统的statusBar就不起作用了。
    [CWStatusBarViewController show];
    
    return YES;
}

@end
