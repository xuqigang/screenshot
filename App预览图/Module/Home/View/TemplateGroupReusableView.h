//
//  TemplateGroupReusableView.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TemplateGroupReusableView : UICollectionReusableView
- (void)setupReusableViewData:(TemplateGroupModel*)groupModel;
@end

NS_ASSUME_NONNULL_END
