//
//  CWRecommandTag.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/29.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWRecommandTag : NSObject
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
@end
