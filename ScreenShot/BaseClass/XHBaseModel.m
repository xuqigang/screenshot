//
//  XHBaseModel.m
//   
//
//  Created by Hanxiaojie on 2018/5/30.
//  Copyright © 2018年 凤凰新媒体. All rights reserved.
//

#import "XHBaseModel.h"

@implementation XHBaseModel
- (instancetype)initWithDictionary:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
