//
//  ScreenshotPreviewVC.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/7.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ScreenshotPreviewVC.h"

@interface ScreenshotPreviewVC ()
@property (weak, nonatomic) IBOutlet UIImageView *preImageView;

@end

@implementation ScreenshotPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快照预览";
    self.preImageView.image = self.preImage;
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    [self setNavigationBarColor:[UIColor clearColor]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarColor:[UIColor clearColor]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setNavigationBarColor:[UIColor colorWithRed:0/255.0 green:150/255.0 blue:255/255.0 alpha:1]];
}
- (void)tap:(UIGestureRecognizer*)ges{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
