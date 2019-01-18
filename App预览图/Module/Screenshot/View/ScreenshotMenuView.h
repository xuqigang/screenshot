//
//  ScreenshotMenuView.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ScreenshotMenuView;
@protocol ScreenshotMenuViewDelegate <NSObject>

- (void)screenshotMenuViewDidDeleteBackgroundImage:(ScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedBackground:(ScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedBackgroundImage:(ScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedTextMaterial:(ScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedPasterMaterial:(ScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewShare:(ScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewRevoke:(ScreenshotMenuView*)screenshotMenuView;

@end
@interface ScreenshotMenuView : UIView

@property (nonatomic, weak) id<ScreenshotMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
