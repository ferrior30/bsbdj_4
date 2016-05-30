//
//  CWPlayBackViewController.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/5/15.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWPlayerLayer.h"

@interface CWPlayBackViewController : UIViewController
@property (copy, nonatomic) NSURL *URL;
/** AVPlayer */
@property (readonly, nonatomic) AVPlayer *player;

@property (weak, nonatomic) IBOutlet CWPlayerLayer *playerLayer;
@end
