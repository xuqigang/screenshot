//
//  TemplateCell.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "TemplateCell.h"
@interface TemplateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation TemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupCellData:(TemplateParameter*)data{
    
    if (data) {
        self.previewImageView.backgroundColor = [UIColor clearColor];
        self.previewImageView.image = [UIImage imageNamed:data.previewIcon];
    } else {
        self.previewImageView.backgroundColor = UIColorFromRGB(0x007AFF);
        self.previewImageView.image = nil;
    }
}
@end
