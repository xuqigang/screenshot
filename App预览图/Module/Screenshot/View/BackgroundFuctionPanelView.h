//
//  BackgroundFuctionPanelView.h
//  WangHuo
//
//  Created by 韩肖杰 on 2019/1/11.
//  Copyright © 2019 ifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BackgroundFuctionPanelView;

@protocol BackgroundFuctionPanelViewDelegate <NSObject>

- (void)backgroundFuctionPanelViewDidColorClicked:(BackgroundFuctionPanelView*)functionPanelView;
- (void)backgroundFuctionPanelViewDidImageClicked:(BackgroundFuctionPanelView*)functionPanelView;

@end
@interface BackgroundFuctionPanelView : UIView

@property (nonatomic, weak) id<BackgroundFuctionPanelViewDelegate> delegate;

+ (instancetype)defaultView;
- (void)showInView:(UIView*)view;
- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
