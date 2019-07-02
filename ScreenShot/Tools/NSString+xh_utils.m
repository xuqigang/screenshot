//
//  NSString+xh_utils.m
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "NSString+xh_utils.h"

@implementation NSString (xh_utils)

+ (BOOL)isEmpty:(NSString*)str{
    return str == nil || str.length == 0 ? YES : NO;
}
+ (BOOL)isAllChinese:(NSString *)str{
    NSInteger count = str.length;
    NSInteger result = 0;
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff)//判断输入的是否是中文
        {
            result++;
        }
    }
    if (count == result) {//当字符长度和中文字符长度相等的时候
        return YES;
    }
    return NO;
}
- (CGFloat)stringWidthForFont:(UIFont*)font {
    NSDictionary *dic = @{NSFontAttributeName:font};  //指定字号
    CGRect rect = [self boundingRectWithSize:CGSizeMake(0, 20)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (CGFloat)stringHeightForFont:(UIFont*)font maxWidth:(CGFloat)maxWidth lineSpaceing:(CGFloat)lineSpaceing{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpaceing;
    
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};  //指定字号以及行间距
    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, 0)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

+ (NSString*)string:(NSString*)str removeKeywords:(NSArray<NSString*>*)keywords{
    if ([self isEmpty:str]) {
        return @"";
    } else {
        for (NSString* key in keywords) {
            str = [str stringByReplacingOccurrencesOfString:key withString:@""];
        }
        return str;
    }
}

- (NSInteger)stringChinaLength{
    int count = 0;
    int count1 =0;
    for (int i =0; i<self.length; i ++){
             unichar c = [self characterAtIndex:i];
             if (c >=0x4E00 && c <=0x9FA5)
             {
                 count ++;
                 
             }
             else
             {
                 count1 ++;
                 
             }
         }
         
         return count + count1/2;
}
- (NSDate*)stringToDate{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat dateFromString:self];
}
@end
