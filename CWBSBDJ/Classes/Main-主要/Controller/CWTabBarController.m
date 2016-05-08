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
#import "CWNavigationController.h"

/** TarBarButton重复点击通知 */
NSString * const CWTarBarButtonDidRepeatClicked = @"tabBarDidRepeatClicked";

@interface CWTabBarController () //<UITabBarControllerDelegate>

@end

@implementation CWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加子控制器
    [self setupAllChildVCs];
    
    // 2.设置tabBar
    [self setupTabBar];
    
    // 设置代理（实现重复点击时上拉刷新通知发送的实现方法二）
//    self.delegate = self;

}

/** 设置tabBar */
- (void)setupTabBar {
    CWTabar *tabBar = [[CWTabar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    }

/**
 *  添加所有子控制器
 */
- (void)setupAllChildVCs {
    
    // 1.添加【精华】控制器
    CWEssenceViewController *essenceVC = [[CWEssenceViewController alloc] init];
    [self setupViewController:essenceVC title:@"精华" imageName:@"tabBar_essence_icon" selectImageName:@"tabBar_essence_click_icon"];
    
    // 4.添加【关注】控制器
    [self setupViewController:[[CWFriendTrendViewController alloc] init] title:@"关注" imageName:@"tabBar_friendTrends_icon" selectImageName:@"tabBar_friendTrends_click_icon"];

    // 3.添加【我】控制器
    [self setupViewController:[[CWMeViewController alloc] init] title:@"我" imageName:@"tabBar_me_icon" selectImageName:@"tabBar_me_click_icon"];
    
   
    
    
     // 2.添加【新帖】控制器
    [self setupViewController:[[CWNewViewController alloc] init] title:@"新帖" imageName:@"tabBar_new_icon" selectImageName:@"tabBar_new_click_icon"];
   
    

}

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
//    vc.view.backgroundColor = CWCommonBgColor; 下面这句设置背景颜色会导致不在屏幕上的view也会创建，导致控制器的懒加载特性失效了。最好是放在view的内部设置（viewDidLoad方法中）。
    CWNavigationController *nav = [[CWNavigationController alloc] initWithRootViewController:vc];
   
    // 2.加入到tabBar的子控制器数组
    [self addChildViewController:nav];
    
    // 3.设置tabBar的标题、图标
    nav.tabBarItem.title = title;
//    [nav.tabBarItem setImage:[UIImage imageNamed:imageName]];
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    [nav.tabBarItem setSelectedImage:[UIImage imageNamed:selectImageName]];
    
    // 4.设置【tabBar选中状态】文字颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    // 用vc不行，要用tabBar的直接子控制器才行(tabBarVC->nav-<vc)。
    [nav.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
}
/** 重写：重复点击时发通知 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger preIndex = [self.childViewControllers indexOfObject:self.selectedViewController];
   NSUInteger currentIndex = [tabBar.items indexOfObject:item];
    
    if (preIndex == currentIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CWTarBarButtonDidRepeatClicked object:nil];
    }
}


#pragma mark - UITabBarControllerDelegeta:重复点击时发通知（方法二，上面有另一种实现方法。 注意要设置代理 ）
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (self.selectedViewController == viewController) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:CWTarBarButtonDidRepeatClicked object:nil];
//    }
//    return YES;
//}
@end
