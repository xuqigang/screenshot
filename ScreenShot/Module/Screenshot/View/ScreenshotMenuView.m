//
//  ScreenshotMenuView.m
//  ScreenShot
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
@property (weak, nonatomic) IBOutlet UILabel *backgroundIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *textIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *pasterIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *revokeIconLabel;

@end

@implementation ScreenshotMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
    [self addGesture];
   
}
- (void)setupUI{
    
    UIFont *font = [UIFont fontAwesomeFontOfSize:15];
    self.backgroundIconLabel.font = font;
    NSString *backgroundIconStr = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-square"];
    self.backgroundIconLabel.text = backgroundIconStr;
    
    self.textIconLabel.font = font;
    NSString *textIconStr = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pencil"];
    self.textIconLabel.text = textIconStr;
    
    self.pasterIconLabel.font = font;
    NSString *pasterIconStr = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-magic"];
    self.pasterIconLabel.text = pasterIconStr;
    
    self.shareIconLabel.font = font;
    NSString *shareIconStr = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-share-square-o"];
    self.shareIconLabel.text = shareIconStr;
    
    self.revokeIconLabel.font = font;
    NSString *revokeIconStr = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-reply"];
    self.revokeIconLabel.text = revokeIconStr;

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
    UITapGestureRecognizer *revokeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(revokeMenuClicked:)];
    [self.revokeMenuView addGestureRecognizer:revokeTap];
}

- (void)backgroundMenuClicked:(UIGestureRecognizer*)ges{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenshotMenuViewDidSelectedBackground:)]) {
        [self.delegate screenshotMenuViewDidSelectedBackground:self];
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
