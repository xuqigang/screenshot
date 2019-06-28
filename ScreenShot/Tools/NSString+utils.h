//
//  NSString+utils.h
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (utils)

+ (BOOL)isEmpty:(NSString*)str;
+ (BOOL)isAllChinese:(NSString *)str;
- (NSInteger)stringChinaLength;

- (CGFloat)stringWidthForFont:(UIFont*)font;
- (CGFloat)stringHeightForFont:(UIFont*)font maxWidth:(CGFloat)maxWidth lineSpaceing:(CGFloat)lineSpaceing;
+ (NSString*)string:(NSString*)str removeKeywords:(NSArray<NSString*>*)keywords;
- (NSDate*)stringToDate;

@end
