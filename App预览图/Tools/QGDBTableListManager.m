//
//  QGDBTableListManager.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/22.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGDBTableListManager.h"

@implementation QGDBTableListManager

+ (NSArray<NSString*>*)tableList{
    return @[@"DBDiaryInfo",@"DBDiaryClassificationInfo"];
}

@end
@implementation DBBaseInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation DBDiaryInfo
@end
@implementation DBDiaryClassificationInfo
@end

