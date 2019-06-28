//
//  TextStyleParameter.m
//  ScreenShot
//
//  Created by Hanxiaojie on 2019/1/6.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import "TextStyleParameter.h"

@implementation TextStyleParameter
- (id)copyWithZone:(nullable NSZone *)zone{
    TextStyleParameter *parameter = [[TextStyleParameter allocWithZone:zone] init];
    parameter.textColorInfo = [self.textColorInfo copy];
    parameter.fontSize = self.fontSize;
    parameter.alignment = self.alignment;
    parameter.overstriking = self.overstriking;
    parameter.backgroundColorInfo = [self.backgroundColorInfo copy];
    parameter.shaowColorInfo = [self.shaowColorInfo copy];
    parameter.shaowSize = self.shaowSize;
    parameter.horizontal = self.horizontal;
    parameter.vertical = self.vertical;
    parameter.opacity = self.opacity;
    return parameter;
}
@end
