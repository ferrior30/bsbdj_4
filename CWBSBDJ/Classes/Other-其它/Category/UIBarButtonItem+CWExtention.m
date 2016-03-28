//
//  UIBarButtonItem+CWExtention.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "UIBarButtonItem+CWExtention.h"

@implementation UIBarButtonItem (CWExtention)
/**
 *  生成自定义的UIBarButtonItem实例对象
 *
 *  @param imageName            普通状态下的图片名
 *  @param highlightedImageName 高亮状态下的图片名
 *  @param title                标题
 *
 *  @return 自定义的UIBarButtonItem实例对象
 */
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
