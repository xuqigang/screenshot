//
//  BackgroundFuctionPanelView.m
//  WangHuo
//
//  Created by 韩肖杰 on 2019/1/11.
//  Copyright © 2019 ifeng. All rights reserved.
//

#import "BackgroundFuctionPanelView.h"
@interface BackgroundFuctionPanelView ()
@property (weak, nonatomic) IBOutlet UIButton *backgroundImageButton;
@property (weak, nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation BackgroundFuctionPanelView
+ (instancetype)defaultView{
    BackgroundFuctionPanelView *panelView = [BackgroundFuctionPanelView instanceFromNib];
    return panelView;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.tag = 1001;
    [self.contentView insertSubview:effectView atIndex:0];
    [self layoutIfNeeded];
    UIFont *font = [UIFont fontAwesomeFontOfSize:40];
    NSString *backgroundColorTitle = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-adjust"];
    self.backgroundColorButton.titleLabel.font = font;
    [self.backgroundColorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backgroundColorButton setTitle:backgroundColorTitle forState:UIControlStateNormal];
    
    NSString *backgroundImageTitle = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-picture-o"];
    self.backgroundImageButton.titleLabel.font = font;
    [self.backgroundImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backgroundImageButton setTitle:backgroundImageTitle forState:UIControlStateNormal];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}
- (IBAction)sixinButtonClicked:(UIButton *)sender {
    [self hiddenView];
    if(self.delegate && [self.delegate respondsToSelector:@selector(backgroundFuctionPanelViewDidColorClicked:)]){
        [self.delegate backgroundFuctionPanelViewDidColorClicked:self];
    }
}
- (IBAction)lotteryDrawButtonClicked:(UIButton *)sender {
    [self hiddenView];
    if(self.delegate && [self.delegate respondsToSelector:@selector(backgroundFuctionPanelViewDidImageClicked:)]){
        [self.delegate backgroundFuctionPanelViewDidImageClicked:self];
    }
    
}
- (void)showInView:(UIView*)view{
    self.frame = view.bounds;
    if (view) {
        [view addSubview:self];
    } else {
        [UIApplication.sharedApplication.delegate.window addSubview:self];
    }
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    }];
}
- (void)hiddenView{
    if ([self superview] == nil) {
        return;
    }
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
    
    if (point.y < self.frame.size.height - self.contentView.frame.size.height) {
        [self hiddenView];
    }
}
@end
