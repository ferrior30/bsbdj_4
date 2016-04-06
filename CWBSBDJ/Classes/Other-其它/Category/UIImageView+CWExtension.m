//
//  UIImageView+CWExtension.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/6.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "UIImageView+CWExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+CWCircleImage.h"

@implementation UIImageView (CWExtension)
- (void)cw_setDefaultIconWithURL:(NSURL *)url {
    
    [self cw_setCircleIconWithURL:url];
}

- (void)cw_setCircleIconWithURL:(NSURL *)url {
    
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return ;
        
        self.image = [image circleImage];
    }];
}

- (void)cw_setSquareIconWithURL:(NSURL *)url {
    
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end
