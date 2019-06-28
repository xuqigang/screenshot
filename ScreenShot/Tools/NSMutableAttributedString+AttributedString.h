//
//  NSMutableAttributedString+AttributedString.h
//  自定义富文本
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 徐其岗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (AttributedString)

//设置字体大小
- (void)addFont:(UIFont *) font range:(NSRange)range;
//设置字体颜色
- (void)addForegroundColor:(UIColor *) color range:(NSRange)range;
//设置字体和颜色
- (void)addFont:(UIFont *) font ForegroundColor:(UIColor *) color range:(NSRange)range;
//设置字体背景颜色
- (void)addBackgroundColor:(UIColor *) color range:(NSRange)range;
//设置连字符
- (void)addLigature:(BOOL) flag range:(NSRange)range;
//设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
- (void)addKern:(NSInteger) kern range:(NSRange)range;

/*deleteline取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
 */
//设置删除线
- (void)addDeletelineStyle:(NSUnderlineStyle ) deletelineStyle range:(NSRange)range;
//设置删除线颜色
- (void)addDeletelineColor:(UIColor *) color range:(NSRange)range;
//设置下划线
- (void)addUnderlineStyle:(NSUnderlineStyle ) underlineStyle range:(NSRange)range;
//设置下划线颜色
- (void)addUnderlineColor:(UIColor *) color range:(NSRange)range;
//设置文字边线颜色
- (void)addStrokeColor:(UIColor *) color range:(NSRange)range;
//设置文字边线宽度
- (void)addStrokeWidth:(CGFloat) width range:(NSRange)range;

#pragma ----------段落风格-----------
//设置行间距
- (void)addlineSpacing:(CGFloat)lineSpaceing range:(NSRange )range;
//设置首行缩进和行间距
- (void)addFirstLineHeadIndent:(CGFloat)indent lineSpacing:(CGFloat)lineSpaceing range:(NSRange )range;

@end
