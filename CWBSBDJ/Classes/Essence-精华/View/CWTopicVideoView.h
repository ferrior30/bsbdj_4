//
//  CWTopicVideoView.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWTopic;

@interface CWTopicVideoView : UIView
/** 帖子模型 */
@property (strong, nonatomic) CWTopic *topic;

+ (instancetype)videoView;
@end
