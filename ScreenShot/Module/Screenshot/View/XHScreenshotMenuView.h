//
//  XHScreenshotMenuView.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XHScreenshotMenuView;
@protocol XHScreenshotMenuViewDelegate <NSObject>

- (void)screenshotMenuViewDidDeleteBackgroundImage:(XHScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedBackground:(XHScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedBackgroundImage:(XHScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedTextMaterial:(XHScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewDidSelectedPasterMaterial:(XHScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewShare:(XHScreenshotMenuView*)screenshotMenuView;
- (void)screenshotMenuViewRevoke:(XHScreenshotMenuView*)screenshotMenuView;

@end
@interface XHScreenshotMenuView : UIView

@property (nonatomic, weak) id<XHScreenshotMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
