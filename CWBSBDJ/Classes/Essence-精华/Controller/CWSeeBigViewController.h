//
//  CWSeeBigViewController.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWTopic;

@interface CWSeeBigViewController : UIViewController
/** 帖子模型 */
@property (strong, nonatomic) CWTopic *topic;
@end
