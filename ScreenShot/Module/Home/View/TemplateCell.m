//
//  TemplateCell.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "TemplateCell.h"
@interface TemplateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupCellData:(XHTemplateParameter*)data{
    
    if (data) {
//        self.titleLabel.text = data.title;
        self.previewImageView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        self.previewImageView.backgroundColor = [UIColor clearColor];
        self.previewImageView.image = [UIImage imageNamed:data.previewIcon];
    } else {
        self.previewImageView.backgroundColor = UIColorFromRGB(0x007AFF);
        self.previewImageView.image = nil;
        self.titleLabel.text = @"";
    }
}
@end
