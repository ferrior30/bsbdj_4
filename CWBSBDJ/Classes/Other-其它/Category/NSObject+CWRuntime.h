//
//  NSObject+CWRuntime.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/6.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CWRuntime)
/**
 *  打印所有的属性（包括父类）
 */
+ (void)logAllIvars;
/**
 *  打印所有的方法（包括父类）
 */
+ (void)logAllMethods;
@end
