//
//  CWMeFootView.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/7.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWMeSquare;

@interface CWMeFootView : UIView
/** 【我的方块】模型数组 */
@property (copy, nonatomic) NSArray<CWMeSquare *> *meSquares;
@end
