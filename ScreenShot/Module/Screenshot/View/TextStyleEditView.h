//
//  TextStyleEditView.h
//  ScreenShot
//
//  Created by Hanxiaojie on 2019/1/5.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextStyleParameter.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TextStyleEditViewResultCallBack)(TextStyleParameter * _Nullable textStyleParameter,NSError * _Nullable error);
@interface TextStyleEditView : UIView
+ (instancetype)defaultView;
- (void)showInView:(UIView * _Nullable )view result:(TextStyleEditViewResultCallBack) result;
- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
