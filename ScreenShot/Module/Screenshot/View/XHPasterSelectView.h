//
//  XHPasterSelectView.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasterInfo.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^XHPasterSelectViewResultCallBack)(PasterInfo * _Nullable pasterInfo,NSError * _Nullable error);
@interface XHPasterSelectView : UIView
+ (instancetype)defaultView;
- (void)showInView:(UIView * _Nullable )view result:(XHPasterSelectViewResultCallBack) result;
- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
