//
//  TextStyleEditView.m
//  App预览图
//
//  Created by Hanxiaojie on 2019/1/5.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import "TextStyleEditView.h"
@interface TextStyleEditView()
@property (nonatomic, strong) TextStyleEditViewResultCallBack resultCallBack;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
@implementation TextStyleEditView
+ (instancetype)defaultView{
    static TextStyleEditView * textStyleEditView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textStyleEditView = [TextStyleEditView instanceFromNib];
    });
    return textStyleEditView;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    [self layoutIfNeeded];
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.frame.size.height;
    self.contentView.frame = contentViewFrame;
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.tag = 1001;
    [self.contentView insertSubview:effectView atIndex:0];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = self.contentView.bounds;
}
- (void)showInView:(UIView*)view result:(TextStyleEditViewResultCallBack) result{
    self.resultCallBack = result;
    self.frame = view.bounds;
    if (view) {
        [view addSubview:self];
    } else {
        [UIApplication.sharedApplication.delegate.window addSubview:self];
    }
    [self layoutIfNeeded];
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    }];
}
- (void)hiddenView{
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self]; //
    
    if (point.y < self.frame.size.height - 340) {
        [self hiddenView];
    }
}

@end
