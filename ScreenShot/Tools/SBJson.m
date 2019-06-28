//
//  SBJson.m
//  JSON转Model文件
//
//  Created by ma c on 15/10/22.
//  Copyright (c) 2015年 徐其岗. All rights reserved.
//

#import "SBJson.h"

@implementation SBJson

@end

@implementation NSString (JsonToDic)

- (id) JSONValue
{

    NSData * theData = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions  error:&error];
    if(error != nil)
    {
        NSLog(@"%@",error);
        return nil;
    }
    return dic;
    
}

@end

@implementation NSDictionary (ObjectToJson)


- (NSString*) JSONRepresentation
{
    __autoreleasing NSError* error = nil;
    
    //    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

@end

@implementation NSArray (ObjectToJson)


- (NSString*) JSONRepresentation
{
    __autoreleasing NSError* error = nil;
    
    //    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

@end


