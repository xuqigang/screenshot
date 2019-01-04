//
//  UIScrollView+blankView.h
//  IfengSmallScreenshot
//
//  Created by Hanxiaojie on 2017/12/1.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISVBlankView;
@protocol ISVBlankViewDelegate <NSObject>

- (void)blankViewDidClicked:(ISVBlankView*)blankView;

@end

@interface ISVBlankView : UIView

@property (nonatomic, assign) BOOL hiddenButton;
@property (nonatomic, strong) NSString *iconIdentifier;
@property (nonatomic, strong) NSString *desText;
@property (nonatomic, strong) NSString *actionText;
@property (nonatomic, weak) id<ISVBlankViewDelegate> delegate;


@end

@interface UIScrollView (blankView)

@property (nonatomic, strong) ISVBlankView *xm_blankView;

- (void)layoutBlankViewIfNeed;

@end

@interface UITableView (blankView)


- (void)showBlankViewIfNeed;

@end
