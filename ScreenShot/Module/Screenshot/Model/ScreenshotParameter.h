//
//  ScreenshotParameter.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,screenshotType) ;

@interface TextMaterial : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGRect *frame;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;  //默认无色

@end

@interface PasterMaterial : NSObject

@property (nonatomic, strong) NSString *paster;
@property (nonatomic, assign) CGRect *frame;
@property (nonatomic, strong) UIColor *backgroundColor;  //默认无色

@end

@interface ScreenshotParameter : NSObject

@property (nonatomic, strong) NSArray<TextMaterial*> *textMaterials;
@property (nonatomic, strong) NSArray<PasterMaterial*> *stickerMaterial;
@property (nonatomic, strong) NSString *screenshotType;  //快照类型类型
@property (nonatomic, strong) NSString *screenshotName;  //截屏快照
@property (nonatomic, readonly) NSString *shellName;  //手机壳对应的图片名字
@property (nonatomic, strong) UIColor *backgroundColor; //背景色，默认白色
@property (nonatomic, strong) UIImage *backgroundImage; //背景图，默认无

@end

NS_ASSUME_NONNULL_END
