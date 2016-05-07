//
//  CWTopicCell.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWTopic;

@interface CWTopicCell : UITableViewCell
@property (strong, nonatomic) CWTopic *topic;

+ (instancetype)topicCell;
@end
