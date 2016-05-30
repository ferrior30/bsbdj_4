//
//  CWPlayerLayer.m
//  exe
//
//  Created by ChenWei on 16/5/15.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWPlayerLayer.h"


@implementation CWPlayerLayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (void)setPlayer:(AVPlayer *)player {
    self.playerLayer.player = player;
}

- (AVPlayer *)player {
    return self.playerLayer.player;
}

@end
