//
//  TextStyleEditView.h
//  App预览图
//
//  Created by Hanxiaojie on 2019/1/5.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextStyleParameter.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TextStyleEditViewResultCallBack)(TextStyleParameter *textStyleParameter);
@interface TextStyleEditView : UIView
+ (instancetype)defaultView;
- (void)showInView:(UIView*)view result:(TextStyleEditViewResultCallBack) result;
@end

NS_ASSUME_NONNULL_END
