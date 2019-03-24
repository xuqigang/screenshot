//
//  Define.h
//   
//
//  Created by Hanxiaojie on 2018/5/29.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#ifndef Define_h
#define Define_h


#endif /* Define_h */
//视图控制器推出
#define PushViewController(controller) [self.navigationController pushViewController:controller animated:YES]
#define PopViewController [self.navigationController popViewControllerAnimated:YES]
#define PopToRootViewController [self.navigationController popToRootViewControllerAnimated:YES]
#define PopToViewController(x) [self popToViewController:x]
#define ThemeColor [UIColor greenColor]
#define QGFont(x) [UIFont systemFontOfSize:x]
#define StatusBarHeight CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorForRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define UpdateThemeColorNotification @"UpdateThemeColorNotification"
