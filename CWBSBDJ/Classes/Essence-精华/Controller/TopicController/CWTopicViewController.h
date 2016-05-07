//
//  CWTopicViewController.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTopic.h"

@interface CWTopicViewController : UITableViewController
//@property (strong, nonatomic) CWTopic *topic;
/** 帖子类型 */
- (CWTopicType)topicType;
/** 请求参数a */
- (NSString *)parameterA;
@end
