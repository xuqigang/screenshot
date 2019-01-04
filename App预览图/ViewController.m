//
//  ViewController.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ViewController.h"
#import "ScreenshotPasterView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ScreenshotPasterView *pasterView = [[ScreenshotPasterView alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    UIImage *image = [UIImage imageNamed:@"1111_03"];
    [pasterView setImageList:@[image] imageDuration:0];
    [self.view addSubview:pasterView];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
