//
//  TemplateGroupModel.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHTemplateParameter.h"
NS_ASSUME_NONNULL_BEGIN

@interface TemplateGroupModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<XHTemplateParameter*> *list;

@end

NS_ASSUME_NONNULL_END
