//
//  TemplateParameter.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/18.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TemplateParameter : NSObject

@property (nonatomic, strong) NSString *previewIcon;
@property (nonatomic, assign) CGFloat shellTopScale;  //手机壳的位置比例
@property (nonatomic, strong) NSString * shellImage;  //手机壳对应的图片


@end

NS_ASSUME_NONNULL_END
