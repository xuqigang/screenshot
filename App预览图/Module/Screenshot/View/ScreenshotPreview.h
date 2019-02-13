//
//  ScreenshotPreview.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateParameter.h"
NS_ASSUME_NONNULL_BEGIN
@class ScreenshotPreview;
@protocol ScreenshotPreviewDelegate <NSObject>

- (void)screenshotPreviewEndEdited:(ScreenshotPreview*)screenshotPreview;
- (void)screenshotImagePreviewDidTap:(ScreenshotPreview*)screenshotPreview;

@end
@interface ScreenshotPreview : UIView

@property (nonatomic, weak) id<ScreenshotPreviewDelegate> delegate;
@property (nonatomic, strong) UIImage * _Nullable backgroundImage;
@property (nonatomic, strong) UIImage * _Nullable shellImage;
@property (nonatomic, strong) UIImage * _Nullable screenshotImage;
@property (nonatomic, assign) CGFloat shellTopScale;  //手机壳顶部约束比例
@property (nonatomic, assign) ScreenshotType screenshotType;
- (void)generateScreenshotImageCallback:(void(^)(UIImage*image))callback;

@end

NS_ASSUME_NONNULL_END
