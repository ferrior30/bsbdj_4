//
//  CWRecommendUser.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/29.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWRecommendUser : NSObject
/**
 *     "uid": "8918517",
         "screen_name": "泡面来了",
         "introduction": "",
         "fans_count": "9021",
         "tiezi_count": 17,
         "header": "http:%/%/img.spriteapp.cn%/profile%/large%/2014%/10%/22%/544712a631641_mini.jpg",
         "gender": 2,
         "is_follow": 0
 */

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *screen_name;
@property (copy, nonatomic) NSString *fans_count;
@property (copy, nonatomic) NSString *header;
@property (assign, nonatomic) NSInteger tiezi_count;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) NSInteger is_follow;
@end
