//
//  UIBarButtonItem+CWExtention.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CWExtention)
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

@end
