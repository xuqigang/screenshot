//
//  UIColor+utils.h
//  App预览图
//
//  Created by Hanxiaojie on 2019/1/4.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (utils)
+ (NSArray<NSNumber*>*)convertHexStringToRGB:(NSString*)hexString;
+ (NSString*)convertRGBToHexStringWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
@end

NS_ASSUME_NONNULL_END
