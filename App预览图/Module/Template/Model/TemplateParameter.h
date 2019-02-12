//
//  TemplateParameter.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/18.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextPatameter.h"
#import "PasterParameter.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ScreenshotType){
    ScreenshotType_Unkonwn = 0,
    ScreenshotType_Plus = 1,
    ScreenshotType_X    = 2
};
@interface TemplateParameter : NSObject

@property (nonatomic, assign) ScreenshotType screenshotType;
@property (nonatomic, strong) NSString * _Nullable previewIcon;
@property (nonatomic, assign) CGFloat shellTopScale;  //手机壳的位置比例
@property (nonatomic, assign) CGFloat screenshotScale; //屏幕快照宽高比
@property (nonatomic, strong) NSString * shellImage;  //手机壳对应的图片
@property (nonatomic, strong) UIImage *screenshotImage; //屏幕快照对应的图片//一般是从相册中选则
@property (nonatomic, strong) UIColor * _Nullable backgroundColor; //背景色，默认白色
@property (nonatomic, strong) NSString * _Nullable backgroundImage; //背景图，默认无
@property (nonatomic, strong) NSArray<TextPatameter*> *textPatameters;
@property (nonatomic, strong) NSArray<PasterParameter*> *stickerPatameters;

@end

NS_ASSUME_NONNULL_END
