//
//  ScreenshotTextFiled.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/22.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "ScreenshotPasterView.h"
#import "UIView+Additions.h"

@interface ScreenshotPasterView () <UITextViewDelegate, UITextFieldDelegate>
{
    UIView*         _borderView;                //用来显示边框或样式背景
    UIButton*       _deleteBtn;                 //删除铵钮
    UIButton*       _scaleRotateBtn;            //单手操作放大，旋转按钮
    UILabel*        _rotateAngleLabel;            //旋转角度
    CGRect          _initFrame;
}

@end

@implementation ScreenshotPasterView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _initFrame = frame;
        
        _pasterImageView = [[UIImageView alloc] init];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        singleTap.numberOfTapsRequired = 1;
        _pasterImageView.userInteractionEnabled = YES;
        [_pasterImageView addGestureRecognizer:singleTap];
        
        _borderView = [UIView new];
        _borderView.layer.borderWidth = 1;
        _borderView.layer.borderColor = ThemeColor.CGColor;
        _borderView.userInteractionEnabled = YES;
        _borderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_borderView];
    
        _rotateAngleLabel = [UILabel new];
        _rotateAngleLabel.text = @"0";
        _rotateAngleLabel.textColor = ThemeColor;
        _rotateAngleLabel.font = [UIFont systemFontOfSize:14];
        _rotateAngleLabel.numberOfLines = 1;
        _rotateAngleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rotateAngleLabel];
        
        _deleteBtn = [UIButton new];
        UIFont *font = [UIFont fontAwesomeFontOfSize:14];
        NSString *deleteTitle = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-times-circle"];
        _deleteBtn.titleLabel.font = font;
        [_deleteBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_deleteBtn setTitle:deleteTitle forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        
        _scaleRotateBtn = [UIButton new];
        NSString *rotateTitle = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-repeat"];
        _scaleRotateBtn.titleLabel.font = font;
        [_scaleRotateBtn setTitle:rotateTitle forState:UIControlStateNormal];
        [_scaleRotateBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        UIPanGestureRecognizer* panGensture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector (handlePanSlide:)];
        [self addSubview:_scaleRotateBtn];
        [_scaleRotateBtn addGestureRecognizer:panGensture];
        
        [_borderView  addSubview:_pasterImageView];
        
        UIPanGestureRecognizer* selfPanGensture = [[UIPanGestureRecognizer alloc] initWithTarget:self action: @selector (handlePanSlide:)];
        [self addGestureRecognizer:selfPanGensture];
        
        UIPinchGestureRecognizer* pinchGensture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGensture];

        UIRotationGestureRecognizer* rotateGensture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [self addGestureRecognizer:rotateGensture];
        _rotateAngle = 0.f;
        self.isEditing = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.width == 0 || self.height == 0) return;
    
    CGPoint center = [self convertPoint:self.center fromView:self.superview];

    _borderView.bounds = CGRectMake(0, 0, self.bounds.size.width - 25, self.bounds.size.height - 25);
    _borderView.center = center;

    _pasterImageView.frame = CGRectMake(0, 0, _borderView.bounds.size.width, _borderView.bounds.size.height);
    _deleteBtn.center = CGPointMake(_borderView.x, _borderView.y);
    _deleteBtn.bounds = CGRectMake(0, 0, 50, 50);

    _rotateAngleLabel.center = CGPointMake(_borderView.x, _borderView.bottom);
    _rotateAngleLabel.bounds = CGRectMake(0, 0, 50, 50);
    
    _scaleRotateBtn.center = CGPointMake(_borderView.right, _borderView.bottom);
    _scaleRotateBtn.bounds = CGRectMake(0, 0, 50, 50);
}

- (void)setImageList:(NSArray *)imageList imageDuration:(float)duration;
{
    if (imageList.count > 1) {
        _pasterImageView.animationImages = imageList;
        _pasterImageView.animationDuration = imageList.count / duration;
        [_pasterImageView startAnimating];
    }else if (imageList.count > 0){
        _pasterImageView.image = imageList[0];
    }
    if (_pasterImageView.image) {
        self.height = self.width * (_pasterImageView.image.size.height / _pasterImageView.image.size.width);
    }
}
- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (isEditing) {
        _borderView.layer.borderColor = ThemeColor.CGColor;
    } else {
        _borderView.layer.borderColor = UIColor.clearColor.CGColor;
    }
    _deleteBtn.hidden = !isEditing;
//    _styleBtn.hidden = !isEditing;
    _scaleRotateBtn.hidden = !isEditing;
    _rotateAngleLabel.hidden = !isEditing;
}

- (CGRect)pasterFrameOnView:(UIView *)view
{
    CGRect frame = CGRectMake(_borderView.x, _borderView.y, _borderView.bounds.size.width, _borderView.bounds.size.height);
    
    if (![view.subviews containsObject:self]) {
        [view addSubview:self];
        CGRect rc = [self convertRect:frame toView:view];
        [self removeFromSuperview];
        return rc;
    }
    
    return [self convertRect:frame toView:view];
}


#pragma mark - GestureRecognizer handle
- (void)onTap:(UITapGestureRecognizer*)recognizer
{
    [self setIsEditing:YES];
    [self.delegate onPasterViewTap];
}

- (void)handlePanSlide:(UIPanGestureRecognizer*)recognizer
{
    if(self.isEditing == NO){
        return;
    }
    //拖动
    if (recognizer.view == self) {
        CGPoint translation = [recognizer translationInView:self.superview];
        CGPoint center = CGPointMake(recognizer.view.center.x + translation.x,
                                     recognizer.view.center.y + translation.y);
        if (center.x < 0) {
            center.x = 0;
        }
        else if (center.x > self.superview.width) {
            center.x = self.superview.width;
        }
        
        if (center.y < 0) {
            center.y = 0;
        }
        else if (center.y > self.superview.height) {
            center.y = self.superview.height;
        }
        
        recognizer.view.center = center;
        
        [recognizer setTranslation:CGPointZero inView:self.superview];
        
        
    }
    else if (recognizer.view == _scaleRotateBtn) {
        CGPoint translation = [recognizer translationInView:self];
        
        //放大
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGFloat delta = translation.x;
            CGFloat height = (self.bounds.size.width + delta) * (self.bounds.size.height / self.bounds.size.width);
            self.bounds = CGRectMake(0, 0, self.bounds.size.width + delta, height);
        }
        [recognizer setTranslation:CGPointZero inView:self];
        
        //旋转
        CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        CGPoint anthorPoint = _pasterImageView.center;
        CGFloat height = newCenter.y - anthorPoint.y;
        CGFloat width = newCenter.x - anthorPoint.x;
        CGFloat angle1 = atan(height / width);
        height = recognizer.view.center.y - anthorPoint.y;
        width = recognizer.view.center.x - anthorPoint.x;
        CGFloat angle2 = atan(height / width);
        CGFloat angle = angle1 - angle2;
        
        self.transform = CGAffineTransformRotate(self.transform, angle);
        _rotateAngle += angle;
        _rotateAngleLabel.text = [NSString stringWithFormat:@"%.0lf°",_rotateAngle * (180.0 / M_PI)];
    }
    
}

//双手指放大
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    if (self.isEditing == NO) {
        return;
    }
    self.bounds = CGRectMake(0, 0, self.bounds.size.width * recognizer.scale, self.bounds.size.height * recognizer.scale);
    recognizer.scale = 1;
}

////双手指旋转
- (void)handleRotate:(UIRotationGestureRecognizer*)recognizer
{
    if (self.isEditing == NO) {
        return;
    }
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);

    _rotateAngle += recognizer.rotation;
    recognizer.rotation = 0;
}

//如果是静态贴纸，生成静态贴纸图片
- (UIImage*)staticImage
{
    _borderView.layer.borderWidth = 0;
    [_borderView setNeedsDisplay];
    CGRect rect = _borderView.bounds;
    UIView *rotatedViewBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width , rect.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(_rotateAngle);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, 0.f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(context, _rotateAngle);
    
    //[_textLabel drawTextInRect:CGRectMake(-rect.size.width / 2, -rect.size.height / 2, rect.size.width, rect.size.height)];
    [_borderView drawViewHierarchyInRect:CGRectMake(-rect.size.width / 2, -rect.size.height / 2, rect.size.width, rect.size.height) afterScreenUpdates:YES];
    UIImage *rotatedImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    _borderView.layer.borderWidth = 1;
    _borderView.layer.borderColor = UIColorFromRGB(0x0accac).CGColor;
    
    return rotatedImg;
}


- (void)onDeleteBtnClicked:(UIButton*)sender
{
    [self.delegate onRemovePasterView:self];
    [self removeFromSuperview];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

