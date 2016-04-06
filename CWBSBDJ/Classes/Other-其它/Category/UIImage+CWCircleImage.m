//
//  UIImage+CWCircleImage.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/31.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "UIImage+CWCircleImage.h"

@implementation UIImage (CWCircleImage)
//+ (instancetype)circleImage:(NSString *)imageName {
//    CGContextRef ctf = UIGraphicsGetCurrentContext();
//    
////    UIBezierPath *path = [uibe]
//    
//}
- (instancetype)circleImage {
    // 开启一个图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 获取上下文
//    CGContextRef ctf = UIGraphicsGetCurrentContext();
    
    // 绘制路径
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [path addClip];
    
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)circleImageNamed:(NSString *)imageName {
//    UIImage *image = [[[UIImage alloc] init] circleImage];;
//
//    return image;
//    return [UIImage circleImageNamed:imageName];
    return  [[self imageNamed:imageName] circleImage];
}
@end
