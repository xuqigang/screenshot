//
//  XHBaseVC.h
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBaseVC : UIViewController

+ (instancetype)instanceFromNib;

- (void)setNavigationBarColor:(UIColor *)color;

//设置左按钮
- (void)setLeftButtonText:(NSString *)text;
- (void)setLeftButtonImage:(UIImage *)image;
- (void)setLeftButtonWithImageName:(NSString *)imageName;
- (void)leftButtonClicked:(UIButton *)button;  //需要时，在子类重写
- (void)hiddenLeftButton;  //隐藏左按钮

//设置右按钮
- (void)setRightButtonText:(NSString *)text;
- (void)setRightButtonText:(NSString *)text selectedText:(NSString*)seletedText;
- (void)setRightButtonImage:(UIImage *)image;
- (void)setRightButtonWithImagename:(NSString * )image;
- (void)rightButtonClicked:(UIButton *)button; //需要时，在子类重写
- (void)hiddenRightButton; //隐藏右按钮

//设置右边第二个按钮
- (void)setRightSecondButtonText:(NSString *)text;
- (void)setRightSecondButtonText:(NSString *)text selectedText:(NSString*)seletedText;
- (void)setRightSecondButtonImage:(UIImage *)image;
- (void)setRightSecondButtonWithImagename:(NSString * )image;
- (void)rightSecondButtonClicked:(UIButton *)button; //需要时，在子类重写
@end
