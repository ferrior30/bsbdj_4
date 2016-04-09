//
//  NSString+FileSize.h
//  exerciseFileSize
//
//  Created by ChenWei on 16/4/9.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileSize)
/** 获取文件大小 */
- (unsigned long long)fileSize;
@end
