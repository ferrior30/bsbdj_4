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

@implementation CWMeFootView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        self.height = 300;
        // 请求数据
        [self loadMeSquares];
        CWLogFunc;
//        // 初始化子控件
//        [self setupUI];
    }
    
    return self;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 按钮的宽度和高度
    CGFloat w = self.width / 4;
    CGFloat H = w;
    
    for (CWMeSquareButton *btn in self.subviews) {
        // 按钮的index
        NSInteger index = [self.subviews indexOfObject:btn];
        
        // 按钮的x，y
        CGFloat x = w * (index % 4);
        CGFloat y = H * (index / 4);
        
        btn.frame = CGRectMake(x, y, w, H);
    }
}

- (void)addSquarBtn {
    
//    // 按钮的宽度和高度
//    CGFloat w = self.width / 4;
//    CGFloat H = w;
//    NSUInteger index = 0;
    
    for (int i = 0; i < self.meSquares.count; i++) {
        CWMeSquareButton *btn = [[CWMeSquareButton alloc] init];
        btn.meSquare = self.meSquares[i];
        [self addSubview:btn];
        
//        index = i;
        
//        // 按钮的x，y
//        CGFloat x = w * (index % 4);
//        CGFloat y = H * (index / 4);
//        
//         btn.frame = CGRectMake(x, y, w, H);
        
        [btn addTarget:self action:@selector(meSquareBtnDidclick:) forControlEvents:UIControlEventTouchUpInside];
        
        //
        btn.backgroundColor = CWRandomColor;;
    }
    
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
        
        CWLogFunc;
        // 添加子控件
        [weakSelf addSquarBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
    }];
}

#pragma mark - 监听
- (void)meSquareBtnDidclick:(CWMeSquareButton *)btn {
    CWLogFunc;
}
@end
