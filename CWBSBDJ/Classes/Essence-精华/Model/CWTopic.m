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
#import "CWUser.h"

@implementation CWTopic
#pragma mark - MJExtension
/** 声明模型数组里放什么属性 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"top_cmt" : [CWComment class],
             };
}

/** 模型中属性对应JSON字典的key */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"small_image" : @"image0",
             @"middle_image" : @"image2",
             @"large_image" : @"image1",
             };
}

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

//- (CGRect)centerViweFrame {
//    // 中间控件的x值
//    CGFloat centerViewX = CWMargin;
//    
//    // text_label的frame
//    // y值（头像高度35+topMargin 10 + bottomMargin 10)
//    CGFloat textY = 55;
//    // 最大宽度
//    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * CWMargin;
//    // 高度
//    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textMaxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
//    
//    // 中间控件的y值
//    CGFloat centerViewY = textY + textH + CWMargin;
//    
//    // 中间控件的宽度
//    CGFloat centerViewW = textMaxW;
//    
//    // 中间控件的高度
//    CGFloat centerViewH = self.height * centerViewW / self.width;
//    
//    // 是否是大图
//    if (centerViewH >= [UIScreen mainScreen].bounds.size.height) {
//        self.isBigPicture = YES;
//        centerViewH = 200;
//    }else {
//        self.isBigPicture = NO;
//    }
//   
//    return CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
//}

- (CGFloat)cellHeight {
    // 如果先前已经计算过了，就直接返回
    if (_cellHeight) return _cellHeight;
    
    // text_label的y值
    CGFloat textY = 55;
    // 最大宽度
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * CWMargin;
    // 高度
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textMaxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
    
    _cellHeight = textY + textH + CWMargin;
    
    // 有中间内容
    if (self.type != CWTopicTypeWord) { // 有中间内容
        // 中间控件的x值
        CGFloat centerViewX = CWMargin;
        // 中间控件的y值
        CGFloat centerViewY = textY + textH + CWMargin;
        // 中间控件的宽度
        CGFloat centerViewW = textMaxW;
        // 中间控件的高度
        CGFloat centerViewH = self.height * centerViewW / self.width;
        
        // 是否是大图
        if (centerViewH >= [UIScreen mainScreen].bounds.size.height) {
            self.isBigPicture = YES;
            centerViewH = 200;
        }else {
            self.isBigPicture = NO;
        }
        
         // 中间内容的frame
        _centerViweFrame = CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
        
        _cellHeight += centerViewH + CWMargin;
    }
    
    // 有最热评论
    if (self.top_cmt.count) {
        // 最热评论的高度
        CGFloat topCmtTitleH = 20;
        NSString *text = [NSString stringWithFormat:@"%@: %@", self.top_cmt.firstObject.user.username, self.top_cmt.firstObject.content];
        
        CGFloat topCmtTextH = [text boundingRectWithSize:CGSizeMake(textMaxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
        
        _cellHeight += topCmtTitleH + topCmtTextH + CWMargin;
    }
    
    // 底部工具条
    CGFloat toolBarH = 35;
    _cellHeight += toolBarH + CWMargin;
    
    return _cellHeight;
}
@end
