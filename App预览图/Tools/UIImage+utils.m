//
//  UIImage+utils.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/26.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "UIImage+utils.h"

@implementation UIImage (utils)

-(UIImage*)imageWithScaledSize:(CGSize)size{
    UIGraphicsBeginImageContext (size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
