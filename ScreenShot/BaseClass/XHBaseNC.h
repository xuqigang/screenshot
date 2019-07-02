//
//  XHBaseNC.h
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBaseNC : UINavigationController
- (void) setTitle:(NSString*) title andImage:(NSString * ) img andSelectedImage:(NSString*) selectedImg;
- (void)updateThemeColor;

@end
