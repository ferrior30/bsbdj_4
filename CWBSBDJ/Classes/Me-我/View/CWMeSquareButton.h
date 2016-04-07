//
//  CWMeSquareButton.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/7.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWMeSquare;

@interface CWMeSquareButton : UIButton
/** 【我的】模型 */
//@property (strong, nonatomic) NSArray<CWMeSquare *> *meSquares;
@property (strong, nonatomic) CWMeSquare *meSquare;

@end
