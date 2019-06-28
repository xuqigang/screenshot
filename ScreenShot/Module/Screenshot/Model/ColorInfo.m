//
//  ColorInfo.m
//  ScreenShot
//
//  Created by Hanxiaojie on 2019/1/5.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import "ColorInfo.h"

@implementation ColorInfo
- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)b opacity:(CGFloat)o{
    if (self = [super init]) {
        self.red = red;
        self.green = green;
        self.blue = b;
        self.opacity = o;
    }
    return self;
}
- (id)copyWithZone:(nullable NSZone *)zone{
    ColorInfo *colorInfo = [[ColorInfo allocWithZone:zone] init];
    colorInfo.red = self.red;
    colorInfo.green = self.green;
    colorInfo.blue = self.blue;
    colorInfo.opacity = self.opacity;
    return colorInfo;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
