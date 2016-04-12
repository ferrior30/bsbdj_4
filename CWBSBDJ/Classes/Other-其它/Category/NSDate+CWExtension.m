//
//  NSDate+CWExtension.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/12.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "NSDate+CWExtension.h"

@implementation NSDate (CWExtension)
- (BOOL)isToday {
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 生成日期组件（即想从日期中提取哪些组件信息）
    NSDateComponents *selfComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
     NSDateComponents *nowComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return selfComps.year == nowComps.year
    && selfComps.month == nowComps.month
    && selfComps.day == nowComps.day;
}

- (BOOL)isTommorrow {
   // 日期格式（生成只有年，月，日的日期对象）
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 转换日期对象：即去掉时，分，秒
    /// self日期转换
    NSString *selfString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfString];
    
    /// 当前日期转换
    NSString *nowString = [formatter stringFromDate:self];
    NSDate *nowDate = [formatter dateFromString:nowString];
    
    // 比较差值 selfDate -> nowdate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0
    && components.month == 0
    && components.day == -1;
}

- (BOOL)isYesterday {
    // 日期格式（生成只有年，月，日的日期对象）
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 转换日期对象：即去掉时，分，秒
    /// self日期转换
    NSString *selfString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfString];
    
    /// 当前日期转换
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [formatter dateFromString:nowString];
    
    // 比较差值 selfDate -> nowdate
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0
    && components.month == 0
    && components.day == 1;
}

- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSComparisonResult comps = [calendar compareDate:self toDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear];
    
    return comps == NSOrderedSame;
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
//    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
//    return selfYear == nowYear;
}
@end
