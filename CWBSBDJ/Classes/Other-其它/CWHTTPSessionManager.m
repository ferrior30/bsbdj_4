//
//  CWHTTPSessionManager.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/7.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWHTTPSessionManager.h"

@implementation CWHTTPSessionManager
+ (instancetype)manager {
    CWHTTPSessionManager *mgr = [super manager];
    return mgr;
}

+ (instancetype)shareManager {
    return [self manager];
}

+ (instancetype)defaultManager {
    return [self manager];
}
@end
