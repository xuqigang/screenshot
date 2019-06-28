//
//  PasterViewCell.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "PasterViewCell.h"

@interface PasterViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation PasterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupCellData:(PasterInfo*_Nullable)cellData{
    if (cellData) {
        self.iconImageView.image = [UIImage imageNamed:cellData.icon];
    } else {
        self.iconImageView.image = nil;
    }
}
@end
