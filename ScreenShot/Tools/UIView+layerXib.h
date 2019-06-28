//
//  UIView+layerXib.h
//  IfengSmallScreenshot
//
//  Created by Hanxiaojie on 2017/11/14.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (layerXib)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;

@end
