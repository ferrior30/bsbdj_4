//
//  CWMeFootView.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/7.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWMeFootView.h"
#import "UIView+CWFrame.h"
#import "CWMeSquareButton.h"
#import "CWHTTPSessionManager.h"
#import "MJExtension.h"
#import "CWMeSquare.h"
#import "SVProgressHUD.h"
#import "CWWebViewController.h"

@implementation CWMeFootView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = CWCommonBgColor;
        // 请求数据
        [self loadMeSquares];
    }
    
    return self;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews {
    [super layoutSubviews];

//    // 按钮的宽度和高度
//    CGFloat w = self.width / 4;
//    CGFloat H = w;
//    
//    for (CWMeSquareButton *btn in self.subviews) {
//        // 按钮的index
//        NSInteger index = [self.subviews indexOfObject:btn];
//        
//        // 按钮的x，y
//        CGFloat x = w * (index % 4);
//        CGFloat y = H * (index / 4);
//        
//        btn.frame = CGRectMake(x, y, w, H);
//    }
//    self.height = (self.subviews.count / 4 + 1) * H;
}

- (void)addSquarBtn {
    
    // 按钮的宽度和高度
    CGFloat w = self.width / 4;
    CGFloat H = w;
    NSUInteger index = 0;
    
    for (int i = 0; i < self.meSquares.count; i++) {
        CWMeSquareButton *btn = [[CWMeSquareButton alloc] init];
        btn.meSquare = self.meSquares[i];
        [self addSubview:btn];
        
        index = i;
        
        // 按钮的x，y
        CGFloat x = w * (index % 4);
        CGFloat y = H * (index / 4);
        
         btn.frame = CGRectMake(x, y, w, H);
        
        [btn addTarget:self action:@selector(meSquareBtnDidclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
    UITableView *tableView = (UITableView *)[self superview];
    tableView.tableFooterView = self;
    // 布局按钮
//    [self layoutIfNeeded];
}

#pragma mark - 网络请求
- (void)loadMeSquares {
    // 显示弹框
    [SVProgressHUD show];
    
    // 请求参数;
    NSDictionary *dict = @{@"a": @"square", @"c": @"topic"};
    
    __weak typeof(self) weakSelf = self;
    // 发送请求
    [[CWHTTPSessionManager manager] GET:CWRequestURL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.meSquares = [CWMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
       // 隐藏弹框
        [SVProgressHUD dismiss];
        
        [responseObject writeToFile:@"/Users/cw/Desktop/a.plist" atomically:YES];
        
        // 添加子控件
        [weakSelf addSquarBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
    }];
}

#pragma mark - 监听
- (void)meSquareBtnDidclick:(CWMeSquareButton *)btn {
    NSString *url = btn.meSquare.url;
    
    // 链接处理
    if ([url hasPrefix:@"mod://"]) { // 特殊处理
        if ([url hasSuffix:@"BDJ_To_Check"]) {
            CWLog(@"跳转到“BDJ_To_Check”");
        }else if ([url hasSuffix:@"App_To_SearchUser"]) {
            CWLog(@"跳转到“BDJ_To_Check”");
        }else {
            CWLog(@"跳转到“BDJ_To_其它情况”");
        }
    }else if ([url hasPrefix:@"http://"]) { // 跳转到网页链接
        // 获取当前的导航控制器
        UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
        UINavigationController *currentNav = tabBarVC.selectedViewController;
        
        // 显示webView
        CWWebViewController *webVC = [[CWWebViewController alloc] init];
        webVC.url = url;
        webVC.view.backgroundColor = [UIColor redColor];
        // 导航栏文字
        webVC.navigationItem.title = btn.meSquare.name;
        
        [currentNav pushViewController:webVC animated:YES];
        
    }else { // 其它情况
        CWLog(@"其它情况的跳转");
    }
}
@end
