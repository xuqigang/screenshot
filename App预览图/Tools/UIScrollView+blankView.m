//
//  UIScrollView+blankView.m
//  IfengSmallScreenshot
//
//  Created by Hanxiaojie on 2017/12/1.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import "UIScrollView+blankView.h"
#import <objc/runtime.h>
#define blankViewKey @"blankViewKey"

@interface ISVBlankView()

@property (nonatomic, strong) UILabel *pictureLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *button;

- (void)showInView:(UIView*)view;
- (void)showInView:(UIView*)view image:(UIImage*)image;
- (void)hiddenView;

@end

@implementation ISVBlankView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.hidden = YES;
    
    [self addSubview:self.tipLabel];
    self.tipLabel.bounds = CGRectMake(0, 0, self.xm_width, 20);
    self.tipLabel.center = self.center;
    
    [self addSubview:self.pictureLabel];
    self.pictureLabel.bounds = CGRectMake(0, 0, self.xm_width*0.5, self.xm_width*0.5);
    self.pictureLabel.center = self.tipLabel.center;
    self.pictureLabel.xm_y = self.tipLabel.xm_y - 10 - self.pictureLabel.xm_height;
    
    [self addSubview:self.button];
    self.button.center = CGPointMake(self.tipLabel.xm_centerX, self.tipLabel.xm_centerY + 45);
    
    
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(0);
//        make.centerX.mas_equalTo(0);
//        make.width.mas_lessThanOrEqualTo(320);
//    }];
//
//    [self addSubview:self.imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.imageView.mas_height).multipliedBy(1);
//        make.centerX.mas_equalTo(0);
//        make.top.mas_equalTo(self.mas_top).mas_offset(0);
//        make.bottom.mas_equalTo(-50);
//    }];
    
}

- (void)showInView:(UIView*)view{
    [self showInView:view image:[UIImage imageNamed:@""]];
}

- (void)showInView:(UIView*)view image:(UIImage*)image {
    [view insertSubview:self atIndex:0];
    
}

- (void)setIconIdentifier:(NSString *)iconIdentifier{
    NSString *icon = [NSString fontAwesomeIconStringForIconIdentifier:iconIdentifier];
    self.pictureLabel.font = [UIFont fontAwesomeFontOfSize:100];
    self.pictureLabel.text = icon;
}

- (void)setActionText:(NSString *)actionText{
    CGFloat width = [actionText stringWidthForFont:[UIFont systemFontOfSize:15]];
    self.button.xm_size = CGSizeMake(width + 20, 40);
    [self.button setTitle:actionText forState:UIControlStateNormal];
}

- (void)setDesText:(NSString *)desText{
    self.tipLabel.text = desText;
}


- (void)hiddenView {
    
}

- (UIButton*)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.cornerRadius = 5;
        _button.borderWidth = 0.75;
        _button.borderColor = [UIColor lightGrayColor];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _button.clipsToBounds = YES;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel*)pictureLabel {
    if (!_pictureLabel) {
        _pictureLabel = [[UILabel alloc] init];
        _pictureLabel.textColor = [UIColor lightGrayColor];
        _pictureLabel.textAlignment = NSTextAlignmentCenter;
        _pictureLabel.numberOfLines = 1;
    }
    return _pictureLabel;
}

- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"空空如也～";
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:18];
        _tipLabel.numberOfLines = 1;
    }
    return _tipLabel;
}

- (void)buttonClicked:(UIButton*)button{
    if (_delegate && [_delegate respondsToSelector:@selector(blankViewDidClicked:)]) {
        [_delegate blankViewDidClicked:self];
    }
}

- (void)setHiddenButton:(BOOL)hiddenButton{
    _hiddenButton = hiddenButton;
    self.button.hidden = hiddenButton;
}


@end

@implementation UIScrollView (blankView)

- (void)setXm_blankView:(ISVBlankView *)xm_blankView {
    ISVBlankView *blankView = (ISVBlankView*)objc_getAssociatedObject(self, blankViewKey);
    if (blankView) {
        [blankView removeFromSuperview];
    }
    [xm_blankView showInView:self];
    objc_setAssociatedObject(self, blankViewKey, blankView,OBJC_ASSOCIATION_RETAIN);
}

- (ISVBlankView*)xm_blankView {
    ISVBlankView *blankView = (ISVBlankView*)objc_getAssociatedObject(self, blankViewKey);
    if (!blankView) {
        blankView = [[ISVBlankView alloc] initWithFrame:CGRectMake(0, 0, self.xm_width * 0.75, self.xm_width * 0.75)];
        blankView.center = CGPointMake(self.xm_centerX, self.xm_centerY - 20);
        objc_setAssociatedObject(self, blankViewKey, blankView,OBJC_ASSOCIATION_RETAIN);
        [blankView showInView:self];
    }
    return blankView;
}

- (void)layoutBlankViewIfNeed{
    self.xm_blankView.center = CGPointMake(self.xm_centerX, self.xm_centerY - 20);
}
@end

@implementation UITableView (blankView)

- (void)showBlankViewIfNeed{
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        self.xm_blankView.hidden = YES;
    } else {
        self.xm_blankView.hidden = NO;
    }
}

@end

