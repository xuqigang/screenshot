//
//  ColorSelectedView.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/4.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ColorSelectedView.h"
@interface ColorSelectedView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) ColorSelectedViewResultCallBack resultCallBack;
@property (weak, nonatomic) IBOutlet UISlider *redslider;
@property (weak, nonatomic) IBOutlet UISlider *greenslider;
@property (weak, nonatomic) IBOutlet UISlider *blueslider;
@property (weak, nonatomic) IBOutlet UISlider *opacityslider;
@property (weak, nonatomic) IBOutlet UIView *colorPreview;
@property (weak, nonatomic) IBOutlet UITextField *redTextField;
@property (weak, nonatomic) IBOutlet UITextField *greenTextField;
@property (weak, nonatomic) IBOutlet UITextField *blueTextField;
@property (weak, nonatomic) IBOutlet UITextField *opacityTextField;

@end
@implementation ColorSelectedView
+ (instancetype)defaultView{
    static ColorSelectedView * colorSelectedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSelectedView = [ColorSelectedView instanceFromNib];
    });
    return colorSelectedView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.frame.size.height;
    self.contentView.frame = contentViewFrame;
    [self layoutIfNeeded];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.tag = 1001;
    [self.contentView insertSubview:effectView atIndex:0];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = self.contentView.bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 点击

- (IBAction)rgbSliderChanged:(UISlider *)sender {
    [self updateColorPreview];
    self.redTextField.text = [NSString stringWithFormat:@"%.0f",self.redslider.value];
    self.greenTextField.text = [NSString stringWithFormat:@"%.0f",self.greenslider.value];
    self.blueTextField.text = [NSString stringWithFormat:@"%.0f",self.blueslider.value];
}
- (IBAction)opacitySlider:(UISlider *)sender {
    self.opacityTextField.text = [NSString stringWithFormat:@"%.0f\%",sender.value * 100];
    [self updateColorPreview];
}

- (void)updateColorPreview{
    UIColor *color = [UIColor colorWithRed:self.redslider.value/255.0 green:self.greenslider.value/255.0 blue:self.blueslider.value/255.0 alpha:self.opacityslider.value];
    self.colorPreview.backgroundColor = color;
}
- (void)showInView:(UIView*)view result:(void(^)(UIColor*color ,NSString* hexColorString)) result{
    self.resultCallBack = result;
    self.frame = view.bounds;
    [self updateColorPreview];
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
