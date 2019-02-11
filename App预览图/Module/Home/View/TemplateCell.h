//
//  TemplateCell.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateParameter.h"
NS_ASSUME_NONNULL_BEGIN

@interface TemplateCell : UICollectionViewCell

- (void)setupCellData:(TemplateParameter *_Nullable )data;

@end

NS_ASSUME_NONNULL_END
