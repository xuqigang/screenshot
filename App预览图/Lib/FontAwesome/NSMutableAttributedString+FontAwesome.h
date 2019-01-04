//
//  NSMutableAttributedString+FontAwesome.h
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/18.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (FontAwesome)

+ (instancetype)stringWithIconIdentifier:(NSString*)identifier;
- (void)setFontSize:(CGFloat)fontSize;
//设置字体颜色
- (void)setForegroundColor:(UIColor*)color;
//设置背景色
- (void)setBackgroundColor:(UIColor*)color;

@end
