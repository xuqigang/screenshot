//
//  ScreenshotPreview.m
//  ScreenShot
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ScreenshotPreview.h"
#import "ScreenshotTextFiled.h"
#import "UIView+Additions.h"
@interface ScreenshotPreview ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shellImageView;
@property (weak, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shellTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenshotHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shellHeightConstraint;

@end
@implementation ScreenshotPreview


- (void)awakeFromNib{
    [super awakeFromNib];
    self.screenshotType = ScreenshotType_Plus;
    UITapGestureRecognizer *screenshotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenshotImageViewTap:)];
    [self.screenshotImageView addGestureRecognizer:screenshotTap];
    self.screenshotImageView.userInteractionEnabled = YES;
}
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImageView.image = backgroundImage;
}
- (UIImage*)backgroundImage{
    return self.backgroundImageView.image;
}
- (void)setShellImage:(UIImage *)shellImage{
    self.shellImageView.image = shellImage;
}
- (UIImage*)shellImage{
    return self.shellImageView.image;
}
- (void)setShellTopScale:(CGFloat)shellTopScale{
    _shellTopScale = shellTopScale;
    [self setNeedsLayout];
}
- (void)setScreenshotImage:(UIImage *)screenshotImage{
    self.screenshotImageView.image = screenshotImage;
}
- (void)setScreenshotType:(ScreenshotType)screenshotType{
    _screenshotType = screenshotType;
    if (_screenshotType == ScreenshotType_X) {
        [self bringSubviewToFront:self.shellImageView];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.shellTopConstraint.constant = (self.frame.size.height - self.shellImageView.frame.size.height) * self.shellTopScale;
    switch (_screenshotType) {
        case ScreenshotType_Plus:
        {
            self.shellHeightConstraint.constant = self.shellImageView.xm_width * (1191/595.0);
            self.screenshotHeightConstraint.constant = self.screenshotImageView.xm_width * (2208/1242.0);
        }
            
            break;
        case ScreenshotType_X:
        {
            self.shellHeightConstraint.constant = self.shellImageView.xm_width * (1493/745.0);
            self.screenshotHeightConstraint.constant = self.screenshotImageView.xm_width * (2436/1125.0);
        }
            break;
        default:
            break;
    }
}


- (void)generateScreenshotImageCallback:(void(^)(UIImage*image))callback{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:ctx];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat width;
        CGFloat height;
        switch (self.screenshotType) {
            case ScreenshotType_Plus:
            {
                width = 1242.0/UIScreen.mainScreen.scale;
                height = 2208.0/UIScreen.mainScreen.scale;
            }
                
                break;
            case ScreenshotType_X:
            {
                width = 1242.0/UIScreen.mainScreen.scale;
                height = 2688.0/UIScreen.mainScreen.scale;
            }
                break;
            default:
                width = 1242;
                height = 2208;
                break;
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage* targetImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (callback) {
            callback([UIImage imageWithData:UIImagePNGRepresentation(targetImage)]);
        }
    });
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(screenshotPreviewEndEdited:)]) {
            [self.delegate screenshotPreviewEndEdited:self];
        }
        return nil;
    } else {
        return view;
    }
    
}
- (void)screenshotImageViewTap:(UIGestureRecognizer*)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenshotImagePreviewDidTap:)]) {
        [self.delegate screenshotImagePreviewDidTap:self];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

@end
