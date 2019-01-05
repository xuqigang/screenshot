//
//  UIColor+utils.m
//  App预览图
//
//  Created by Hanxiaojie on 2019/1/4.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import "UIColor+utils.h"

@implementation UIColor (utils)
+ (NSArray<NSNumber*>*)convertHexStringToRGB:(NSString*)hexString{
    //删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return @[@(255),@(255),@(255)];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return @[@(255),@(255),@(255)];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return @[@(r),@(g),@(b)];
}
+ (NSString*)convertRGBToHexStringWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue{
    
    NSString *redHex = @"";
    if (red > 255 || red < 0) {
        redHex = @"FF";
    } else {
        NSInteger hexRed = red << 16;
        redHex = [[NSString stringWithFormat:@"%.6lX",(long)hexRed] substringToIndex:2];
        
    }
    NSString *greenHex = @"";
    if (green > 255 || green < 0) {
        greenHex = @"FF";
    } else {
        NSInteger hexGreen = green << 8;
        greenHex = [[NSString stringWithFormat:@"%.4lX",(long)hexGreen] substringToIndex:2];
    }
    NSString *blueHex = @"";
    if (blue > 255 || blue < 0) {
        blueHex = @"FF";
    } else {
        blueHex = [NSString stringWithFormat:@"%.2lX",(long)blue];
    }
    return [NSString stringWithFormat:@"%@%@%@",redHex,greenHex,blueHex];
}
@end
