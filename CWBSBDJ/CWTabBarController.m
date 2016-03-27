//
//  CWTabBarController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWTabBarController.h"
#import "CWEssenceViewController.h"
#import "CWNewViewController.h"
#import "CWMeViewController.h"
#import "CWFriendTrendViewController.h"
#import "CWTabar.h"


@interface CWTabBarController ()

@end

@implementation CWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加子控制器
    [self setupAllChildVCs];
    
    // 2.设置tabBar
    [self setupTabBar];
    
    // 设置tabBar文字属性(下面有另一种方法）
//    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor redColor]};
//    UITabBarItem *item = [UITabBarItem appearance];
//    [item setTitleTextAttributes:dict forState:UIControlStateSelected];
}

- (void)setupTabBar {
    CWTabar *tabBar = [[CWTabar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    }

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@", self.tabBar.subviews);
}

/**
 *  添加所有子控制器
 */
- (void)setupAllChildVCs {
    // 1.添加【精华】控制器
    CWEssenceViewController *essenceVC = [[CWEssenceViewController alloc] init];
    [self setupViewController:essenceVC title:@"精华" imageName:@"tabBar_essence_icon" selectImageName:@"tabBar_essence_click_icon"];
    
    
     // 2.添加【新帖】控制器
    [self setupViewController:[[CWNewViewController alloc] init] title:@"新帖" imageName:@"tabBar_new_icon" selectImageName:@"tabBar_new_click_icon"];
    
    // 3.添加【我】控制器
    [self setupViewController:[[CWMeViewController alloc] init] title:@"我" imageName:@"tabBar_me_icon" selectImageName:@"tabBar_me_click_icon"];
    
    // 4.添加【关注】控制器
    [self setupViewController:[[CWFriendTrendViewController alloc] init] title:@"关注" imageName:@"tabBar_friendTrends_icon" selectImageName:@"tabBar_friendTrends_click_icon"];
}

#define CWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CWGColorA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define CWRandomColor CWColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

/**
 *  添加一个子控制器
 *
 *  @param vc              用于包装成导航控制器
 *  @param title           tabBar标题
 *  @param imageName       tabBar普通状态图片
 *  @param selectImageName tabBar选中状态图片
 */
- (void)setupViewController:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName {
    // 1.包装导航控制器
    vc.view.backgroundColor = CWRandomColor;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
   
    // 2.加入到tabBar的子控制器数组
    [self addChildViewController:nav];
    
    // 3.设置tabBar的标题、图标
    nav.tabBarItem.title = title;
//    [nav.tabBarItem setImage:[UIImage imageNamed:imageName]];
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    [nav.tabBarItem setSelectedImage:[UIImage imageNamed:selectImageName]];
    
    // 4.设置【tabBar选中状态】文字颜色
    /// 法一：
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor purpleColor];
    // 用vc不行，要用tabBar的直接子控制器才行。
//    [nav.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    /// 法二：
    vc.tabBarController.tabBar.tintColor = [UIColor darkGrayColor];
}
@end
