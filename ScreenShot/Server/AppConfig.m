//
//  AppConfig.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/27.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "AppConfig.h"
@interface AppConfig ()
{
    UIColor *_appThemeColor;
    NSArray<UIColor*> *_themsColors;
}
@end
@implementation AppConfig

+ (instancetype)shareManager{
    static AppConfig *configManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[AppConfig alloc] init];
    });
    return configManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _themsColors = @[UIColorForRGB(0, 170, 238, 1),UIColorForRGB(40, 40, 40, 1),UIColorForRGB(255, 108, 0, 1),UIColorForRGB(154, 75, 255, 1),UIColorForRGB(255, 122, 223, 1),];
       
        NSInteger themeColorIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeColor"] == nil ? 2 : [[[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeColor"] integerValue];
        _appThemeColor = _themsColors[themeColorIndex];
        _gestureEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"GestureEnabled"];
        _fingerEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"FingerEnabled"];
        _productId = @"32924";
        
        _userId = [self getUserId];
        
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        _appName = app_Name;
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _version = version;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThemeColorNotification:) name:UpdateThemeColorNotification object:nil];
    }
    return self;
}

- (UIColor*)themeColor{
    return _appThemeColor;
}

- (void)setFingerEnabled:(BOOL)fingerEnabled{
    _fingerEnabled = fingerEnabled;
    [[NSUserDefaults standardUserDefaults] setBool:_fingerEnabled forKey:@"FingerEnabled"];
}
- (void)setGestureEnabled:(BOOL)gestureEnabled{
    _gestureEnabled = gestureEnabled;
    [[NSUserDefaults standardUserDefaults] setBool:_gestureEnabled forKey:@"GestureEnabled"];
}

- (NSString*)getUserId{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
    if ([NSString isEmpty:userId]){
        userId = [NSString stringWithFormat:@"%ld%d",((NSInteger)[NSDate date].timeIntervalSince1970) % 1000000, arc4random() % 100];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"UserId"];
    }
    return userId;
}
- (void)updateThemeColorNotification:(NSNotification*)notification{
    NSInteger themeColorIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeColor"] == nil ? 2 : [[[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeColor"] integerValue];
    _appThemeColor = _themsColors[themeColorIndex];
}
@end
