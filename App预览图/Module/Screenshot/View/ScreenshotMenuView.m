//
//  ScreenshotMenuView.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ScreenshotMenuView.h"
@interface ScreenshotMenuView ()

@property (weak, nonatomic) IBOutlet UIView *backgroundMenuView;
@property (weak, nonatomic) IBOutlet UIView *textMenuView;
@property (weak, nonatomic) IBOutlet UIView *pasterMenuView;
@property (weak, nonatomic) IBOutlet UIView *shareMenuView;
@property (weak, nonatomic) IBOutlet UIView *revokeMenuView;

@end

@implementation ScreenshotMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addGesture];
   
}

- (void)addGesture{
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundMenuClicked:)];
    [self.backgroundMenuView addGestureRecognizer:backgroundTap];
    UITapGestureRecognizer *textTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textMenuClicked:)];
    [self.textMenuView addGestureRecognizer:textTap];
    UITapGestureRecognizer *pasterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pasterMenuClicked:)];
    [self.pasterMenuView addGestureRecognizer:pasterTap];
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMenuClicked:)];
    [self.shareMenuView addGestureRecognizer:shareTap];
    UITapGestureRecognizer *revokeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareMenuClicked:)];
    [self.revokeMenuView addGestureRecognizer:revokeTap];
}

- (void)backgroundMenuClicked:(UIGestureRecognizer*)ges{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *backgroundColor = [UIAlertAction actionWithTitle:@"设置背景色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewDidSelectedBackgroundColor:)]){
            [self.delegate screenshotMenuViewDidSelectedBackgroundColor:self];
        }
    }];
    UIAlertAction *addBackgroundImage = [UIAlertAction actionWithTitle:@"添加背景图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewDidSelectedBackgroundImage:)]){
            [self.delegate screenshotMenuViewDidSelectedBackgroundImage:self];
        }
    }];
    UIAlertAction *deleteBackgroundImage = [UIAlertAction actionWithTitle:@"清除背景图" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewDidDeleteBackgroundImage:)]){
            [self.delegate screenshotMenuViewDidDeleteBackgroundImage:self];
        }
    }];
    [alert addAction:backgroundColor];
    [alert addAction:addBackgroundImage];
    [alert addAction:deleteBackgroundImage];
    [alert addAction:cancle];
    if (self.delegate && [self.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController*)self.delegate;
         [vc presentViewController:alert animated:YES completion:nil];
    }
}

- (void)textMenuClicked:(UIGestureRecognizer*)ges{
    if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewDidSelectedTextMaterial:)]){
        [self.delegate screenshotMenuViewDidSelectedTextMaterial:self];
    }
}

- (void)pasterMenuClicked:(UIGestureRecognizer*)ges{
    if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewDidSelectedPasterMaterial:)]){
        [self.delegate screenshotMenuViewDidSelectedPasterMaterial:self];
    }
}

- (void)shareMenuClicked:(UIGestureRecognizer*)ges{
    if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewShare:)]){
        [self.delegate screenshotMenuViewShare:self];
    }
}

- (void)revokeMenuClicked:(UIGestureRecognizer*)ges{
    if(self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewRevoke:)]){
        [self.delegate screenshotMenuViewRevoke:self];
    }
}

@end
