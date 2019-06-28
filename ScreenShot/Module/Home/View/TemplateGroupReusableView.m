//
//  TemplateGroupReusableView.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/2/11.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "TemplateGroupReusableView.h"
@interface TemplateGroupReusableView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation TemplateGroupReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupReusableViewData:(TemplateGroupModel*)groupModel{
    if (groupModel) {
        self.titleLabel.text = groupModel.title;
    } else {
        self.titleLabel.text = @"";
    }
}
@end
