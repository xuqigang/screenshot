//
//  AppConfig.h
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/27.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+ (instancetype)shareManager;

@property (nonatomic,readonly,strong) NSString *version;
@property (nonatomic,readonly,strong) NSString *appName;
@property (nonatomic,readonly,strong) UIColor *themeColor;
@property (nonatomic,assign) BOOL gestureEnabled; //手势开启
@property (nonatomic,assign) BOOL fingerEnabled;  //指纹、faceID开启
@property (nonatomic,strong) NSString *productId; //问题反馈ID
@property (nonatomic,strong) NSString *userId;  //用户ID

@end
