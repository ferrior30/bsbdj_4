//
//  CWPlayerLayer.h
//  exe
//
//  Created by ChenWei on 16/5/15.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

@interface CWPlayerLayer : UIView
@property (weak, nonatomic) AVPlayer *player;
@property (weak, nonatomic,readonly) AVPlayerLayer *playerLayer;
@end
