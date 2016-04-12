//
//  NSDate+CWExtension.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/12.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CWExtension)
/** @return :是否是今天 */
- (BOOL)isToday;

/** @return :是否是明天 */
- (BOOL)isTommorrow;

/** @return :是否是昨天 */
- (BOOL)isYesterday;

/** @return :是否是今年 */
- (BOOL)isThisYear;

@end
