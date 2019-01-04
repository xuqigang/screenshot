//
//  ScreenshotEditVC.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ScreenshotEditVC.h"
#import "ScreenshotPreview.h"
#import "ScreenshotTextFiled.h"
#import "ScreenshotPasterView.h"
#import "ScreenshotMenuView.h"
#import "ColorSelectedView.h"
@interface ScreenshotEditVC ()<ScreenshotMenuViewDelegate>

@property (nonatomic, strong) ScreenshotPreview *screenshotPreview;
@property (nonatomic, strong) ScreenshotMenuView *screenshotMenuView;
@end

@implementation ScreenshotEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
   
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"设计快照";
    [self setRightButtonText:@"保存"];
    [self setRightSecondButtonText:@"预览"];
    [self.view addSubview:self.screenshotPreview];
    [self.view addSubview:self.screenshotMenuView];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat bottomHeight = 49;
    CGFloat topHeight = StatusBarHeight + 44;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        bottomHeight = bottomHeight + safeAreaInsets.bottom;
    }
    
    CGFloat screenshotPreviewHeight = self.view.xm_height - topHeight - bottomHeight - 80;
    CGFloat screenshotPreviewWidth = screenshotPreviewHeight * (9/16.0);
    self.screenshotPreview.frame = CGRectMake((self.view.xm_width - screenshotPreviewWidth)/2.0, topHeight + 40,screenshotPreviewWidth , screenshotPreviewHeight);
    self.screenshotMenuView.frame = CGRectMake(0, self.view.xm_height - bottomHeight, self.view.xm_width, bottomHeight);
}
#pragma mark -init
- (ScreenshotPreview*)screenshotPreview{
    if (!_screenshotPreview) {
        _screenshotPreview = [ScreenshotPreview instanceFromNib];
    }
    return _screenshotPreview;
}
- (ScreenshotMenuView*)screenshotMenuView{
    if (!_screenshotMenuView) {
        _screenshotMenuView = [ScreenshotMenuView instanceFromNib];
        _screenshotMenuView.delegate = self;
    }
    return _screenshotMenuView;
}

#pragma mark - ScreenshotMenuViewDelegate
- (void)screenshotMenuViewDidSelectedBackgroundColor:(ScreenshotMenuView*)screenshotMenuView{
    [[ColorSelectedView defaultView] showInView:self.view result:^(UIColor * _Nonnull color, NSString * _Nonnull hexColorString) {
        
    }];
}
- (void)screenshotMenuViewDidSelectedBackgroundImage:(ScreenshotMenuView*)screenshotMenuView{
    
}
- (void)screenshotMenuViewDidSelectedTextMaterial:(ScreenshotMenuView*)screenshotMenuView{
    ScreenshotTextFiled *textField = [[ScreenshotTextFiled alloc] initWithFrame:CGRectMake(40, 60, 150, 50)];
    [self.screenshotPreview addSubview:textField];
}
- (void)screenshotMenuViewDidSelectedPasterMaterial:(ScreenshotMenuView*)screenshotMenuView{
    
}
- (void)screenshotMenuViewShare:(ScreenshotMenuView*)screenshotMenuView{
    
}
- (void)screenshotMenuViewRevoke:(ScreenshotMenuView*)screenshotMenuView{
    
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
