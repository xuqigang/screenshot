//
//  ColorInfo.h
//  ScreenShot
//
//  Created by Hanxiaojie on 2019/1/5.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorInfo : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger red;
@property (nonatomic, assign) NSInteger green;
@property (nonatomic, assign) NSInteger blue;
@property (nonatomic, assign) CGFloat opacity;

- (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)b opacity:(CGFloat)o;

@end

NS_ASSUME_NONNULL_END
