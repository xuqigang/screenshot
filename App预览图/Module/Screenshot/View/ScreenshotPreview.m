//
//  ScreenshotPreview.m
//  App预览图
//
//  Created by 韩肖杰 on 2019/1/3.
//  Copyright © 2019 xuqigang. All rights reserved.
//

#import "ScreenshotPreview.h"
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
