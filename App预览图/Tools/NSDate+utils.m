//
//  NSDate+utils.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/21.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "NSDate+utils.h"

@implementation NSDate (utils)

- (NSString *)stringFromDate:(NSString*)format{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    NSString* string=[dateFormat stringFromDate:self];
    return string;
}

@end
