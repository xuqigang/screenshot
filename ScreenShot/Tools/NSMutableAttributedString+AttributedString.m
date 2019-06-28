//
//  NSMutableAttributedString+AttributedString.m
//  自定义富文本
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 徐其岗. All rights reserved.
//

#import "NSMutableAttributedString+AttributedString.h"

@implementation NSMutableAttributedString (AttributedString)
//设置字体
- (void)addFont:(UIFont *) font range:(NSRange)range
{
    [self addAttribute:NSFontAttributeName value:font range:range];
}
//设置字体颜色
- (void)addForegroundColor:(UIColor *) color range:(NSRange)range
{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}
//设置字体和颜色
- (void)addFont:(UIFont *) font ForegroundColor:(UIColor *) color range:(NSRange)range
{
    [self addAttribute:NSFontAttributeName value:font range:range];
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}
//设置字体背景色
- (void)addBackgroundColor:(UIColor *) color range:(NSRange)range
{
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}
//设置连字符
- (void)addLigature:(BOOL) flag range:(NSRange)range
{
    [self addAttribute:NSLigatureAttributeName value:@(flag) range:range];
}
//设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
- (void)addKern:(NSInteger) kern range:(NSRange)range
{
    [self addAttribute:NSKernAttributeName value:[NSNumber numberWithInteger:kern] range:range];
}
//设置删除线
- (void)addDeletelineStyle:(NSUnderlineStyle) deletelineStyle range:(NSRange)range
{
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(deletelineStyle) range:range];
}
//设置删除线颜色
- (void)addDeletelineColor:(UIColor *) color range:(NSRange)range
{
    [self addAttribute:NSStrikethroughColorAttributeName value:color range:range];
}
//设置下划线
- (void)addUnderlineStyle:(NSUnderlineStyle ) underlineStyle range:(NSRange)range
{
    [self addAttribute:NSUnderlineStyleAttributeName value:@(underlineStyle) range:range];
}
//设置下划线颜色
- (void)addUnderlineColor:(UIColor *) color range:(NSRange)range
{
    [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
}
//设置文字边线颜色
- (void)addStrokeColor:(UIColor *) color range:(NSRange)range
{
    [self addAttribute:NSStrokeColorAttributeName value:color range:range];
}
- (void) addlineSpacing:(CGFloat) lineSpaceing range:(NSRange ) range
{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpaceing;
    
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}
//设置首行缩进和行间距
- (void)addFirstLineHeadIndent:(CGFloat)indent lineSpacing:(CGFloat)lineSpaceing range:(NSRange )range{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     paragraphStyle.lineSpacing = lineSpaceing;
    paragraphStyle.firstLineHeadIndent = indent;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}
/*
 该值width改变笔画宽度（相对于字体 size 的百分比），负值填充效果，正值中空效果，默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为 3.0。
 同时设置了空心的两个属性，并且 NSStrokeWidthAttributeName 属性设置为整数，文字前景色就无效果了
 */
- (void)addStrokeWidth:(CGFloat) width range:(NSRange)range
{
    [self addAttribute:NSStrokeWidthAttributeName value:@(width) range:range];
}

@end
