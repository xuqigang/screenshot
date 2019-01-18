//
//  PasterViewCell.h
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasterInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface PasterViewCell : UICollectionViewCell

- (void)setupCellData:(PasterInfo* _Nullable)cellData;

@end

NS_ASSUME_NONNULL_END
