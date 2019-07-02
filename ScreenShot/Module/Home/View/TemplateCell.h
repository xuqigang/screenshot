//
//  TemplateCell.h
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHTemplateParameter.h"
NS_ASSUME_NONNULL_BEGIN

@interface TemplateCell : UICollectionViewCell

- (void)setupCellData:(XHTemplateParameter *_Nullable )data;

@end

NS_ASSUME_NONNULL_END
