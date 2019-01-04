//
//  ColorSelectedView.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
typedef void(^ColorSelectedViewResultCallBack)(UIColor*color ,NSString* hexColorString);
@interface ColorSelectedView : UIView

+ (instancetype)defaultView;
- (void)showInView:(UIView*)view result:(ColorSelectedViewResultCallBack) result;

@end

NS_ASSUME_NONNULL_END
