//
//  UIView+layerXib.m
//  IfengSmallScreenshot
//
//  Created by Hanxiaojie on 2017/11/14.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import "UIView+layerXib.h"


@implementation UIView (layerXib)
@dynamic borderColor,borderWidth,cornerRadius,shadowColor,shadowOffset,shadowRadius,shadowOpacity;

- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

@end
