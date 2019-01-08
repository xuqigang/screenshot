//
//  ScreenshotPreview.m
//  App预览图
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

@end
@implementation ScreenshotPreview

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImageView.image = backgroundImage;
}
- (UIImage*)backgroundImage{
    return self.backgroundImage;
}
- (void)setShellImage:(UIImage *)shellImage{
    self.shellImageView.image = shellImage;
}
- (UIImage*)shellImage{
    return self.shellImage;
}

- (void)generateScreenshotImageCallback:(void(^)(UIImage*image))callback{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:ctx];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1242/UIScreen.mainScreen.scale, 2208/UIScreen.mainScreen.scale), NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, 1242/UIScreen.mainScreen.scale, 2208/UIScreen.mainScreen.scale)];
        UIImage* targetImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (callback) {
            callback(targetImage);
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

@end
