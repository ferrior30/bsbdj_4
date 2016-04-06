//
//  NSObject+CWRuntime.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/6.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "NSObject+CWRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (CWRuntime)
+ (void)logAllIvars {
    Class c = [self class];
    while (c) {
        unsigned int outCount = 0;
        Ivar *ivarList = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivarList[i];
            CWLog(@"ivarName = %s, ivarType = %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
        }
        free(ivarList);
        
        c = class_getSuperclass(c);
    }
}

+ (void)logAllMethods{
    Class c = [self class];
    while (c) {
        unsigned int outCount = 0;
        Method *methodList = class_copyMethodList(c, &outCount);
        
        for (int i = 0; i < outCount; i++) {
            Method method = methodList[i];
            CWLog(@"methodName = %s, methodType = %s", sel_getName(method_getName(method)) ,  method_getTypeEncoding(method));
        }
        free(methodList);
        
        c = class_getSuperclass(c);
    }
}
@end
