//
//  NSString+FileSize.m
//  exerciseFileSize
//
//  Created by ChenWei on 16/4/9.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "NSString+FileSize.h"

@implementation NSString (FileSize)
- (unsigned long long)fileSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDictory = NO;
    
    BOOL exist = [manager fileExistsAtPath:self isDirectory:&isDictory];
    
    // 1.路径不存在
    if (!exist) return 0;
   
    // 2.是路径
    if (isDictory) {
        unsigned long long fileSize = 0;
        
        NSDirectoryEnumerator *dicEnumerator = [manager enumeratorAtPath:self];
        for (NSString *subPath in dicEnumerator) {
            // 完整的子路路径
            NSString *fullSubPath = [self stringByAppendingPathComponent:subPath];
            fileSize += [manager attributesOfItemAtPath:fullSubPath error:nil].fileSize;
        }
        return fileSize;
    }
    
    // 3.其它情况则是文件
    return [manager attributesOfItemAtPath:self error:nil].fileSize;
}
@end
