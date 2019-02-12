//
//  PasterParameter.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/2/12.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasterParameter : NSObject

@property (nonatomic, strong) NSString *paster;
@property (nonatomic, assign) CGPoint position;  //中心点坐标
@property (nonatomic, strong) UIColor *backgroundColor;  //默认无色

@end

NS_ASSUME_NONNULL_END
