//
//  CWUser.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/14.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWUser : NSObject
/** 用户名 */
@property (copy, nonatomic) NSString *username;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
@end
