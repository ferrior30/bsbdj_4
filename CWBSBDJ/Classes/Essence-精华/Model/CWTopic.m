//
//  CWTopic.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWTopic.h"
#import "NSDate+CWExtension.h"
#import "MJExtension.h"
#import "CWComment.h"

@implementation CWTopic
#pragma mark - MJExtension
/** 声明模型数组里放什么属性 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"top_cmt" : [CWComment class],
             };
}

/** 模型中属性对应JSON字典的key */
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{
//             @"small_image" : @"image0",
//              @"middle_image" : @"image2",
//              @"large_image" : @"image1",
//             };
//}

#pragma mark - 数据处理
/** 处理日期字符串 */
- (NSString *)created_at {
    // 根据字符串生成帖子的创建日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:_created_at];
    
 
    
    if ([createdAtDate isThisYear]) { // 今年
        if ([createdAtDate isToday]) { // 今天
            // 当前时间
            NSDate *nowDate = [NSDate date];
            // 日历对象
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar components:unit fromDate:createdAtDate toDate:nowDate options:0];
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",cmps.hour];
            }else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            }else {
                return @"刚刚";
            }
        }else if ([createdAtDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }else {
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
    }else { // 非今年
        return  _created_at;
    }
}
@end
