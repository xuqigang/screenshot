//
//  SBJson.h
//  JSON转Model文件
//
//  Created by ma c on 15/10/22.
//  Copyright (c) 2015年 徐其岗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBJson : NSObject


@end


@interface NSString (JsonToDic)          //字符串分类,将Json串转化为字典

- (id) JSONValue;

@end


@interface NSDictionary (ObjectToJson)   //字典分类,将字典转化为Json串


- (NSString*) JSONRepresentation;

@end

@interface NSArray (ObjectToJson)   //字典分类,将字典转化为Json串


- (NSString*) JSONRepresentation;

@end
