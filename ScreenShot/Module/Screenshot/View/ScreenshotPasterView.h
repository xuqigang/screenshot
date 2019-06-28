//
//  ScreenshotTextFiled.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/22.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScreenshotPasterView;
@protocol ScreenshotPasterViewDelegate <NSObject>
- (void)onPasterViewTap;
- (void)onRemovePasterView:(ScreenshotPasterView*)pasterView;
@end

@interface ScreenshotPasterView : UIView
@property (nonatomic, weak) id<ScreenshotPasterViewDelegate> delegate;
@property (nonatomic, strong)    UIImageView *pasterImageView;
@property (nonatomic, assign)    CGFloat   rotateAngle;
@property (nonatomic, assign)    UIImage*  staticImage;
@property (nonatomic, assign) BOOL isEditing;  //正在编辑
- (void)setImageList:(NSArray<UIImage*> *)imageList imageDuration:(float)duration;
- (CGRect)pasterFrameOnView:(UIView*)view;
@end

