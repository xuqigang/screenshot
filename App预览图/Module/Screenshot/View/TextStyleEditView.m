//
//  TextStyleEditView.m
//  App预览图
//
//  Created by Hanxiaojie on 2019/1/5.
//  Copyright © 2019年 xuqigang. All rights reserved.
//

#import "TextStyleEditView.h"
#import "ColorSelectedView.h"
@interface TextStyleEditView()
{
    UIButton *_selectedAlignmentButton;
    TextStyleParameter *_textStyleParameter;
}
@property (nonatomic, strong) TextStyleEditViewResultCallBack resultCallBack;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fontSizeUpButton;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeAdjustSlider;
@property (weak, nonatomic) IBOutlet UIButton *overstrikingButton;
@property (weak, nonatomic) IBOutlet UIView *textColorShowView;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorShowView;
@property (weak, nonatomic) IBOutlet UIView *shadowColorShowView;
@property (weak, nonatomic) IBOutlet UITextField *shadowWidthTextField;
@property (weak, nonatomic) IBOutlet UITextField *shadowHeightTextField;
@property (weak, nonatomic) IBOutlet UILabel *opacityLabel;
@property (weak, nonatomic) IBOutlet UISlider *opacityAdjustSlider;
@property (weak, nonatomic) IBOutlet UIButton *opacityUpButton;

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
    [self initTextStyleParameter];
    
}
- (void)initTextStyleParameter{
    _textStyleParameter = [[TextStyleParameter alloc] init];
    ColorInfo *textColor = [[ColorInfo alloc] initWithRed:55 green:55 blue:55 opacity:1];
    _textStyleParameter.textColorInfo = textColor;
    _textStyleParameter.fontSize = 16;
    _textStyleParameter.alignment = 11;
    _textStyleParameter.overstriking = NO;
    _textStyleParameter.backgroundColorInfo = nil;
    _textStyleParameter.shaowColorInfo = nil;
    _textStyleParameter.shaowSize = CGSizeMake(0, 0);
    _textStyleParameter.horizontal = NO;
    _textStyleParameter.vertical = NO;
    _textStyleParameter.opacity = 1;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *effectView = [self.contentView viewWithTag:1001];
    effectView.frame = self.contentView.bounds;
}
#pragma mark - 事件

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    if (_resultCallBack) {
        _resultCallBack(nil,[NSError new]);
    }
    [self hiddenView];
}
- (IBAction)enterButtonClicked:(UIButton *)sender {
    if (_resultCallBack) {
        _resultCallBack([_textStyleParameter copy],nil);
    }
    [self hiddenView];
}
- (IBAction)rotateResetButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 10:
            _textStyleParameter.horizontal = sender.selected;
            break;
            
        default:
            _textStyleParameter.vertical = sender.selected;
            break;
    }
    
}
- (IBAction)modifyTextColorButtonClicked:(UIButton *)sender {
    [self hiddenContentViewCompletion:^(BOOL finished) {
        [[ColorSelectedView defaultView] showInView:nil result:^(ColorInfo * _Nullable colorInfo, UIColor * _Nullable color, NSError * _Nullable error) {
            if (error == nil) {
                self.textColorShowView.backgroundColor = color;
                self->_textStyleParameter.textColorInfo = colorInfo;
            }
            [self showContentViewCompletion:nil];
        }];
    }];
}
- (IBAction)adjustTextFontSlider:(UISlider *)sender {
    _textStyleParameter.fontSize = sender.value;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%ldpt",(NSInteger)sender.value];
}
- (IBAction)upTextFontSizeButton:(UIButton *)sender {
    if (self.fontSizeAdjustSlider.maximumValue > self.fontSizeAdjustSlider.value) {
        self.fontSizeAdjustSlider.value = self.fontSizeAdjustSlider.value + 1;
        self.fontSizeLabel.text = [NSString stringWithFormat:@"%ldpt",(NSInteger)self.fontSizeAdjustSlider.value];
        _textStyleParameter.fontSize = self.fontSizeAdjustSlider.value;
    }
}
- (IBAction)alignmentButtonClicked:(UIButton *)sender {
    if (_selectedAlignmentButton) {
        _selectedAlignmentButton.selected = NO;
    }
    sender.selected = YES;
    _selectedAlignmentButton = sender;
    _textStyleParameter.alignment = sender.tag;
}
- (IBAction)overstrikingButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _textStyleParameter.overstriking = sender.selected;
}

- (IBAction)modifyBackgroundColorButtonClicked:(UIButton *)sender {
    [self hiddenContentViewCompletion:^(BOOL finished) {
        [[ColorSelectedView defaultView] showInView:nil result:^(ColorInfo * _Nullable colorInfo, UIColor * _Nullable color, NSError * _Nullable error) {
            if (error == nil) {
                self.backgroundColorShowView.backgroundColor = color;
                self->_textStyleParameter.backgroundColorInfo = colorInfo;
            }
            [self showContentViewCompletion:nil];
            
        }];
    }];
}
- (IBAction)modifyShadowColorButtonClicked:(id)sender {
    [self hiddenContentViewCompletion:^(BOOL finished) {
        [[ColorSelectedView defaultView] showInView:nil result:^(ColorInfo * _Nullable colorInfo, UIColor * _Nullable color, NSError * _Nullable error) {
            if (error == nil) {
                self.shadowColorShowView.backgroundColor = color;
                self->_textStyleParameter.shaowColorInfo = colorInfo;
            }
            [self showContentViewCompletion:nil];
        }];
    }];
}
- (IBAction)adjustOpacitySliderChanged:(UISlider *)sender {
    self.opacityLabel.text = [NSString stringWithFormat:@"%.2lf",sender.value];
    _textStyleParameter.opacity = sender.value;
    
}
- (IBAction)upOpacityButtonClicked:(UIButton *)sender {
    if (self.opacityAdjustSlider.maximumValue > self.opacityAdjustSlider.value) {
        self.opacityAdjustSlider.value = self.opacityAdjustSlider.value + 0.01;
        self.opacityLabel.text = [NSString stringWithFormat:@"%.2lf",self.opacityAdjustSlider.value];
        _textStyleParameter.opacity = self.opacityAdjustSlider.value;
    }
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
- (void)showContentViewCompletion:(void (^ __nullable)(BOOL finished))completion{
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
        
    }];
}
- (void)hiddenContentViewCompletion:(void (^ __nullable)(BOOL finished))completion{
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        completion(finished);
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
