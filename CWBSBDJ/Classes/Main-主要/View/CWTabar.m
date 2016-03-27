//
//  CWTabar.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWTabar.h"

@interface CWTabar ()
@property (weak, nonatomic) UIButton *publishButton;
@end

@implementation CWTabar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        // 添加发布按钮
        UIButton *publishButton = [[UIButton alloc] init];
        
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publishButton sizeToFit];
        
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

/**
 *  布局子控件
 */

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // tabBar的尺寸
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    // 布局发布按钮
    self.publishButton.center = CGPointMake(w * 0.5, h * 0.5);
    
    NSUInteger index = 0;
    CGFloat tabBarButtonW = w / 5;
    CGFloat tabBarButtonH = h;
    CGFloat tabBarButtonY = 0;
    
    for (UIView *tabbarButton in self.subviews) {
        NSString *className = NSStringFromClass(tabbarButton.class);
        if (![className isEqualToString:@"UITabBarButton"]) continue;
        
        // 布局tabbarButton的位置
        CGFloat tabBarButtonX = tabBarButtonW * index;
        if (index >= 2) {
            tabBarButtonX += tabBarButtonW;
        }
        tabbarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);
        
        index++;
    }
    
}
@end
