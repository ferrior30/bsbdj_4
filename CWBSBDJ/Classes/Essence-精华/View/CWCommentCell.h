//
//  CWCommentCell.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/5.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWComment;

@interface CWCommentCell : UITableViewCell
/** 评论模型 */
@property (strong, nonatomic) CWComment *comment;
@end
