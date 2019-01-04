//
//  HomeVC.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "HomeVC.h"
#import "ScreenshotEditVC.h"
@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"App Store屏幕快照设计";
    [self hiddenLeftButton];
}
- (IBAction)iPadButtonClicked:(UIButton *)sender {
    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
    PushViewController(vc);
}
- (IBAction)iPhoneButtonClicked:(UIButton *)sender {
    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
    PushViewController(vc);
}
- (IBAction)iPhoneXButtonClicked:(UIButton *)sender {
    ScreenshotEditVC *vc = [ScreenshotEditVC instanceFromNib];
    PushViewController(vc);
}


@end
