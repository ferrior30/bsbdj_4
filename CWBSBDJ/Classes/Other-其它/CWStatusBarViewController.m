//
//  CWStatusBarViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/7.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWStatusBarViewController.h"

@interface CWStatusBarViewController ()<NSCopying>

@end

static UIWindow *window_;
static CWStatusBarViewController *shareInstance_;
@implementation CWStatusBarViewController
#pragma mark - 单例实现
+ (instancetype)shareInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [super allocWithZone:zone];
    });
    return shareInstance_;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return shareInstance_;
}

#pragma mark - 状态栏
- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    
    // 刷新状态栏 (内部会重新调用prefersStatusBarHidden和preferredStatusBarStyle方法)
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

#pragma mark - 相关方法
+ (void)show {
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [UIColor clearColor];
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    
    window_ .hidden = NO;
    window_.windowLevel = UIWindowLevelAlert;
    window_.rootViewController = [[self alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:keyWindow];
    
}

- (void)searchScrollViewInView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        [self searchScrollViewInView:subView];
    }
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        
        CGRect rect = [scrollView convertRect:scrollView.bounds toView:nil];
        if (CGRectIntersectsRect(rect, scrollView.window.bounds)) { // 在窗口上：滚动到顶部
            CGPoint offSet = scrollView.contentOffset;
            offSet.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offSet animated:YES];
        }
    }else return; // 不在窗口上：退出检查下一下

}
@end
