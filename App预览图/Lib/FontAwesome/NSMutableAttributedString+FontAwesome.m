//
//  NSMutableAttributedString+FontAwesome.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/18.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "NSMutableAttributedString+FontAwesome.h"
#import "NSString+FontAwesome.h"

@implementation NSMutableAttributedString (FontAwesome)
+ (instancetype)stringWithIconIdentifier:(NSString*)identifier{
    NSString *iconStr =[NSString fontAwesomeIconStringForIconIdentifier:identifier];
    return [[NSMutableAttributedString alloc] initWithString:iconStr];
}
- (void)setFontSize:(CGFloat)fontSize{
    UIFont *font = [UIFont fontAwesomeFontOfSize:fontSize];
    [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
}
//设置字体颜色
- (void)setForegroundColor:(UIColor*)color{
    [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
}
//设置背景色
- (void)setBackgroundColor:(UIColor*)color{
    [self addAttribute:NSBackgroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
}
@end
