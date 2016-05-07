//
//  UIImage+CWCircleImage.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/31.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "UIImage+CWCircleImage.h"

@implementation UIImage (CWCircleImage)

- (instancetype)circleImage {
    // 开启一个图形上下文
//    UIGraphicsBeginImageContext(self.size);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 2);
    
    // 获取上下文
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    
    // 绘制路径
    CGRect rect = CGRectMake(0, 0, self.size.width , self.size.height);
    
    CGContextAddEllipseInRect(ctf, rect);
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    CGContextClip(ctf);
    
//    [path addClip];
    
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

//- (instancetype)circleImage
//{
//    // 开启图形上下文(目的:产生一个新的UIImage, 参数size就是新产生UIImage的size)
//    UIGraphicsBeginImageContext(self.size);
//    
//    // 获得上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 添加一个圆
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    CGContextAddEllipseInRect(context, rect);
//    
//    // 裁剪(根据添加到上下文中的路径进行裁剪)
//    // 以后超出裁剪后形状的内容都看不见
//    CGContextClip(context);
//    
//    // 绘制图片到上下文中
//    [self drawInRect:rect];
//    
//    // 从上下文中获得最终的图片
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 关闭图形上下文
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

+ (instancetype)circleImageNamed:(NSString *)imageName {

    return  [[self imageNamed:imageName] circleImage];
}
@end
