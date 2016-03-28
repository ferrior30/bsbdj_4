//
//  CWNavigationController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWNavigationController.h"

@interface CWNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation CWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置pop手势的代理
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 拦截push过程，设置导航栏返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 2.设置返回按钮
    if (self.childViewControllers.count > 0) {
        //隐藏底部的tabBar
         viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma makr - 监听
/** 点击返回按钮返回上一界面 */
- (void)back {
    [self popViewControllerAnimated:YES];
}

#pragma mark-
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CWLog(@"f");
    return self.childViewControllers.count > 1;
}


@end
