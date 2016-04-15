//
//  CWComment.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/14.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CWUser;

@interface CWComment : NSObject
/** 发表这条评论的人 */
@property (strong, nonatomic) CWUser *user;
/** 评论内容 */
@property (copy, nonatomic) NSString *content;
@end
