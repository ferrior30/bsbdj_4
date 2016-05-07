//
//  CWCommentViewController.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/30.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWTopic;

@interface CWCommentViewController : UIViewController
@property (strong, nonatomic) CWTopic *topic;
/** 所评论帖子的id */
@property (copy, nonatomic) NSString *data_id;
@end
