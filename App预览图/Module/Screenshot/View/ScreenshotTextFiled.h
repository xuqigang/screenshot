//
//  ScreenshotTextFiled.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/22.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScreenshotTextFiled;

/**
 字幕输入view，进行文字输入，拖动，放大，旋转等
 */

@interface ScreenshotTextBubble
@property(nonatomic , strong) UIImage *image;
@property(nonatomic , assign) CGRect  textNormalizationFrame;
@end

@protocol ScreenshotTextFieldDelegate <NSObject>
- (void)onEditing:(ScreenshotTextFiled*)screenshotTextFiled;
- (void)onBubbleTap:(ScreenshotTextFiled*)screenshotTextFiled;
- (void)onTextInputBegin;
- (void)onTextInputDone:(NSString*)text;
- (void)onRemoveTextField:(ScreenshotTextFiled*)textField;
@end

@interface ScreenshotTextFiled : UIView

@property (nonatomic, weak) id<ScreenshotTextFieldDelegate> delegate;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, readonly) UIImage* textImage;             //生成字幕image
@property (nonatomic, strong) UILabel* textLabel;                 //文字输入Label
@property (nonatomic, assign) BOOL isEditing;  //正在编辑

- (void)updatePosition;
- (void)setTextBubbleImage:(UIImage *)image textNormalizationFrame:(CGRect)frame;

- (CGRect)textFrameOnView:(UIView*)view;

//关闭键盘
- (void)resignFirstResponser;

@end

