//
//  XHColorSelectedView.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorInfo.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^XHColorSelectedViewResultCallBack)(ColorInfo*_Nullable colorInfo ,UIColor* _Nullable color,NSError * _Nullable error);
@interface XHColorSelectedView : UIView

+ (instancetype)defaultView;
- (void)showInView:(UIView*_Nullable)view result:(XHColorSelectedViewResultCallBack _Nullable) result;

@end

NS_ASSUME_NONNULL_END
