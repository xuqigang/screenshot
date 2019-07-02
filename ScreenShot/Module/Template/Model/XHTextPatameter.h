//
//  XHTextPatameter.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/2/12.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHTextPatameter : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGPoint position;  //中心点坐标
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;  //默认无色

@end

NS_ASSUME_NONNULL_END
