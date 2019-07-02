//
//  XHScreenshotTextFiled.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/22.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHScreenshotPasterView;
@protocol XHScreenshotPasterViewDelegate <NSObject>
- (void)onPasterViewTap;
- (void)onRemovePasterView:(XHScreenshotPasterView*)pasterView;
@end

@interface XHScreenshotPasterView : UIView
@property (nonatomic, weak) id<XHScreenshotPasterViewDelegate> delegate;
@property (nonatomic, strong)    UIImageView *pasterImageView;
@property (nonatomic, assign)    CGFloat   rotateAngle;
@property (nonatomic, assign)    UIImage*  staticImage;
@property (nonatomic, assign) BOOL isEditing;  //正在编辑
- (void)setImageList:(NSArray<UIImage*> *)imageList imageDuration:(float)duration;
- (CGRect)pasterFrameOnView:(UIView*)view;
@end

