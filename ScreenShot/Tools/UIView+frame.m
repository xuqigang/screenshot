//
//  UIView+frame.m
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)
- (void)setXm_x:(CGFloat)xm_x{
    CGRect frame = self.frame;
    frame.origin.x = xm_x;
    self.frame = frame;
}

- (CGFloat)xm_x{
    return self.frame.origin.x;
}

- (void)setXm_maxX:(CGFloat)xm_maxX{
    CGRect frame = self.frame;
    frame.origin.x = xm_maxX - self.xm_height;
    self.frame = frame;
}

- (CGFloat)xm_maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setXm_y:(CGFloat)xm_y{
    CGRect frame = self.frame;
    frame.origin.y = xm_y;
    self.frame = frame;
}

- (CGFloat)xm_y{
    return self.frame.origin.y;
}

- (void)setXm_maxY:(CGFloat)xm_maxY{
    CGRect frame = self.frame;
    frame.origin.y = self.xm_y - xm_maxY;
    self.frame = frame;
}

- (CGFloat)xm_maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)setXm_width:(CGFloat)xm_width{
    CGRect frame = self.frame;
    frame.size.width = xm_width;
    self.frame = frame;
}
- (CGFloat)xm_width{
    return self.bounds.size.width;
}
- (void)setXm_height:(CGFloat)xm_height{
    CGRect frame = self.frame;
    frame.size.height = xm_height;
    self.frame = frame;
}
- (CGFloat)xm_height{
    return self.frame.size.height;
}
- (void)setXm_size:(CGSize)xm_size{
    CGRect bounds = self.bounds;
    bounds.size = xm_size;
    self.bounds = bounds;
}
- (CGSize)xm_size{
    return self.bounds.size;
}

- (void)setXm_centerX:(CGFloat)xm_centerX{
    CGPoint center = self.center;
    center.x = xm_centerX;
    self.center = center;
}

- (CGFloat)xm_centerX{
    return self.center.x;
}

- (void)setXm_centerY:(CGFloat)xm_centerY{
    CGPoint center = self.center;
    center.y = xm_centerY;
    self.center = center;
}

- (CGFloat)xm_centerY{
    return self.center.y;
}

@end
