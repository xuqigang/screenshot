//
//  TextStyleParameter.h
//  App预览图
//
//  Created by Hanxiaojie on 2019/1/6.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface TextStyleParameter : NSObject<NSCopying>

@property (nonatomic, strong) ColorInfo * _Nullable textColorInfo;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSInteger alignment; //10 左对齐 11 居中对齐 12 右对齐
@property (nonatomic, assign) BOOL overstriking;
@property (nonatomic, strong) ColorInfo * _Nullable backgroundColorInfo;
@property (nonatomic, strong) ColorInfo * _Nullable shaowColorInfo;
@property (nonatomic, assign) CGSize shaowSize;
@property (nonatomic, assign) BOOL horizontal; // 水平
@property (nonatomic, assign) BOOL vertical;   //垂直
@property (nonatomic, assign) CGFloat opacity;

@end

NS_ASSUME_NONNULL_END
