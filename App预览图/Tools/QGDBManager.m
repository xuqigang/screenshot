//
//  QGDBManager.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/22.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGDBManager.h"
#import <objc/runtime.h>
#define DATABASEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Diary/DB"]

static QGDBManager *fmdbManager = nil;

@interface QGDBManager ()
{

    FMDatabaseQueue *_dbQueue;
   
}
@end

@implementation QGDBManager
+ (instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbManager = [[QGDBManager alloc] init];
    });
    return fmdbManager;
}
+ (void)reloadDB{
    fmdbManager = [[QGDBManager alloc] init];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataBase];
        [self initDBTable];
    }
    return self;
}

- (void)initDataBase{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExist = [fileManager fileExistsAtPath:DATABASEPATH isDirectory:&isDir];
    
    if (DATABASEPATH && !(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:DATABASEPATH
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
        
        if(!bCreateDir){
            
            NSLog(@"Create Directory Failed.");
            
        }
    }
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[DATABASEPATH stringByAppendingString:@"/diary.sqlite3"]];
}
- (void)initDBTable{
    NSArray<NSString*> *tableNameList = [QGDBTableListManager tableList];
    for (NSString *tableName in tableNameList) {
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='%@';",tableName];;
            FMResultSet *set = [db executeQuery:sql];
            BOOL isExistTable = NO;
            while ([set next])
            {
                // just print out what we've got in a number of formats.
                NSInteger count = [set intForColumn:@"count"];
                
                if (count != 0)
                {
                    NSLog(@"%@ isTableOK", tableName);
                    isExistTable = YES;
                    [set close]; //关闭结果集
                    break;
                }
            }
            if (isExistTable == NO) {
                [self createTable:tableName dataBase:db];
            }
        }];
    }
}
- (void)createTable:(NSString*)tableName dataBase:(FMDatabase*)db{
    Class modelClass = NSClassFromString(tableName);
    if (modelClass) {
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList(modelClass, &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ",tableName];
        for(NSUInteger i = 0; i < propertyCount; i ++){
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            if ([propertyName isEqualToString:@"id"]) {
                continue;
            }
            NSString *typeString = [self getSqliteDataTypeForProperty:propertys[i]];
            [sql appendFormat:@",'%@' %@",propertyName,typeString];
        }
        [sql appendString:@")"];
        NSInteger flag = [db executeUpdate:sql];
        if (flag > 0) {
            NSLog(@"%@ table isCreated success !", tableName);
        } else {
            NSLog(@"%@ table isCreated failure !", tableName);
        }
    } else {
        NSLog(@"无法找到对应的类,创建%@表失败!",tableName);
    }
}

- (void)selectData:(id)data result:(void (^)(NSMutableArray *resultSet))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = NSStringFromClass([data class]);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([data class], &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            id value = [data valueForKey:propertyName];
            NSLog(@"%@",value);
            if (value) {
                
                if ([value isKindOfClass:[NSNumber class]]) {
                    if (strcmp([value objCType], @encode(NSInteger)) == 0) {
                        
                        NSInteger intValue = [value integerValue];
                        if (intValue != 0) {
                            [sql appendFormat:@"%@ = ? and ",propertyName];
                            [pragramers addObject:value];
                        }
                        
                    } else {
                        CGFloat intValue = [value floatValue];
                        if (intValue != 0) {
                            [sql appendFormat:@"%@ = ? and ",propertyName];
                            [pragramers addObject:value];
                        }
                    }
                    
                } else {
                    [sql appendFormat:@"%@ = ? and ",propertyName];
                    [pragramers addObject:value];
                }
                
                NSLog(@"%@ %@",propertyName, value);
            } else {
                NSLog(@"%@ %@",propertyName, value);
            }
        }
        if([sql hasSuffix:@"and "]){
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 4, 4)];
        }
        
        if (pragramers.count == 0) {
            
            if([sql hasSuffix:@"WHERE "]){
                [sql deleteCharactersInRange:NSMakeRange(sql.length - 6, 6)];
            }
            
        }
        NSMutableArray *resultModels = [NSMutableArray arrayWithCapacity:1];
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:pragramers];
        while ([resultSet next]) {
            [resultModels addObject:[resultSet resultDictionary]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(resultModels);
            }
        });
        

    }];
}

//升序结果
- (void)selectData:(id)data orderBy:(NSString*)rowName ascResult:(void (^)(NSMutableArray *resultSet))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = NSStringFromClass([data class]);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([data class], &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            id value = [data valueForKey:propertyName];
            NSLog(@"%@",value);
            if (value) {
                
                if ([value isKindOfClass:[NSNumber class]]) {
                    if (strcmp([value objCType], @encode(NSInteger)) == 0) {
                        
                        NSInteger intValue = [value integerValue];
                        if (intValue != 0) {
                            [sql appendFormat:@"%@ = ? and ",propertyName];
                            [pragramers addObject:value];
                        }
                        
                    } else {
                        CGFloat intValue = [value floatValue];
                        if (intValue != 0) {
                            [sql appendFormat:@"%@ = ? and ",propertyName];
                            [pragramers addObject:value];
                        }
                    }
                    
                } else {
                    [sql appendFormat:@"%@ = ? and ",propertyName];
                    [pragramers addObject:value];
                }
                
                NSLog(@"%@ %@",propertyName, value);
            } else {
                NSLog(@"%@ %@",propertyName, value);
            }
        }
        if([sql hasSuffix:@"and "]){
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 4, 4)];
        }
        
        if (pragramers.count == 0) {
            
            if([sql hasSuffix:@"WHERE "]){
                [sql deleteCharactersInRange:NSMakeRange(sql.length - 6, 6)];
            }
            
        }
        
        [sql appendFormat:@" order by %@ asc",rowName];
        NSMutableArray *resultModels = [NSMutableArray arrayWithCapacity:1];
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:pragramers];
        while ([resultSet next]) {
            [resultModels addObject:[resultSet resultDictionary]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(resultModels);
            }
        });
        
        
    }];
}
//降序结果
- (void)selectData:(id)data orderBy:(NSString*)rowName descResult:(void (^)(NSMutableArray *resultSet))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = NSStringFromClass([data class]);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([data class], &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            id value = [data valueForKey:propertyName];
            NSLog(@"%@",value);
            if (value) {
                
                if ([value isKindOfClass:[NSNumber class]]) {
                    if (strcmp([value objCType], @encode(NSInteger)) == 0) {
                        
                        NSInteger intValue = [value integerValue];
                        if (intValue != 0) {
                            [sql appendFormat:@"%@ = ? and ",propertyName];
                            [pragramers addObject:value];
                        }
                        
                    } else {
                        CGFloat intValue = [value floatValue];
                        if (intValue != 0) {
                            [sql appendFormat:@"%@ = ? and ",propertyName];
                            [pragramers addObject:value];
                        }
                    }
                    
                } else {
                    [sql appendFormat:@"%@ = ? and ",propertyName];
                    [pragramers addObject:value];
                }
                
                NSLog(@"%@ %@",propertyName, value);
            } else {
                NSLog(@"%@ %@",propertyName, value);
            }
        }
        if([sql hasSuffix:@"and "]){
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 4, 4)];
        }
        
        if (pragramers.count == 0) {
            
            if([sql hasSuffix:@"WHERE "]){
                [sql deleteCharactersInRange:NSMakeRange(sql.length - 6, 6)];
            }
            
        }
        
        [sql appendFormat:@" order by %@ desc",rowName];
        NSMutableArray *resultModels = [NSMutableArray arrayWithCapacity:1];
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:pragramers];
        while ([resultSet next]) {
            [resultModels addObject:[resultSet resultDictionary]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(resultModels);
            }
        });
        
        
    }];
}

- (void)insertData:(id)data result:(void (^)(BOOL flag))result{
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = NSStringFromClass([data class]);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([data class], &propertyCount);
        NSMutableString *sqlTab = [NSMutableString stringWithFormat:@"INSERT INTO '%@' (",tableName];
        NSMutableString *sqlPra = [NSMutableString stringWithString:@") values ("];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:propertyCount];
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            if ([propertyName isEqualToString:@"id"]) {
                continue;
            }
            [sqlTab appendFormat:@"'%@',",propertyName];
            [sqlPra appendString:@"?,"];
            id value = [data valueForKey:propertyName];
            if (value) {
                [pragramers addObject:value];
            } else {
                [pragramers addObject:[NSNull null]];
            }
        }
        if ([sqlTab hasSuffix:@","]) {
            [sqlTab deleteCharactersInRange:NSMakeRange(sqlTab.length - 1, 1)];
        }
        if ([sqlPra hasSuffix:@","]) {
            [sqlPra deleteCharactersInRange:NSMakeRange(sqlPra.length - 1, 1)];
        }
        [sqlPra appendString:@")"];
        NSString *sql = [sqlTab stringByAppendingString:sqlPra];
        BOOL flag = [db executeUpdate:sql withArgumentsInArray:pragramers];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                NSLog(@"%@ insert %@",tableName,flag ? @"success" : @"failure");
                result(flag);
            }
        });
    }];
    return ;
}
- (void)updateData:(id)data result:(void (^)(BOOL flag))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = NSStringFromClass([data class]);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([data class], &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE '%@' SET ",tableName];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:propertyCount];
        
        id valueId ;
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            if ([propertyName isEqualToString:@"id"]) {
                valueId = [data valueForKey:propertyName];
                continue;
            } else if([data valueForKey:propertyName]){
                [sql appendFormat:@"%@ = ? ,",propertyName];
                [pragramers addObject:[data valueForKey:propertyName]];
            }
            
        }
        if (valueId == nil) {
            NSLog(@"id 不能为空");
            return;
        }
        if ([sql hasSuffix:@","]) {
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
        }
        [sql appendFormat:@"WHERE id = ?"];
        [pragramers addObject:valueId];
        
        BOOL flag = [db executeUpdate:sql withArgumentsInArray:pragramers];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(flag);
            }
        });
    }];

}
- (void)deleteData:(id)data result:(void (^)(BOOL flag))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *tableName = NSStringFromClass([data class]);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([data class], &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM '%@' WHERE ",tableName];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:propertyCount];
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            id value = [data valueForKey:propertyName];
            if (value &&  [value isKindOfClass:[NSNumber class]]) {
                if ([value integerValue] != 0 || [value floatValue] != 0) {
                    [sql appendFormat:@"%@ = ? and ",propertyName];
                    [pragramers addObject:value];
                }
            } else if(value){
                [sql appendFormat:@"%@ = ? and ",propertyName];
                [pragramers addObject:value];
            }
        
        }
        if ([sql hasSuffix:@"and "]) {
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 4, 4)];
        }
        BOOL flag = NO;
        if([pragramers count]>0){
            flag = [db executeUpdate:sql withArgumentsInArray:pragramers];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(flag);
            }
        });
    }];
}

- (void)executeSQL:(NSString*)sql withArgumentsInArray:(NSArray*)arguments result:(void(^)(id response))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([sql hasPrefix:@"select"] || [sql hasPrefix:@"SELECT"]) {
            NSMutableArray *resultModels = [NSMutableArray arrayWithCapacity:1];
            FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:arguments];
            while ([resultSet next]) {
                [resultModels addObject:[resultSet resultDictionary]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    result(resultModels);
                }
            });
        } else {
            NSInteger flag = [db executeUpdate:sql withArgumentsInArray:arguments];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    result(@(flag));
                }
            });
        }
    }];
}

#pragma mark -------------内部方法-------------
- (NSString*)getSqliteDataTypeForProperty:(objc_property_t) property{
    const char * type = property_getAttributes(property);
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if ([propertyType isEqualToString:@"@\"NSDate\""]) {
        return @"TIMESTAMP";
    } else if([propertyType isEqualToString:@"@\"NSString\""]){
        return @"TEXT";
    } else {
        if (strcmp(rawPropertyType, @encode(CGFloat)) == 0) {
            //it's a float
            return @"FLOAT";
        }else if (strcmp(rawPropertyType, @encode(NSTimeInterval)) == 0) {
            return @"DOUBLE";
            //it's an int
        }else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0) {
            return @"INTEGER";
            //it's an int
        } else if (strcmp(rawPropertyType, @encode(char)) == 0) {
            return @"VARCHAR";
            //it's an int
        } else {
            return @"TEXT";
        }
    }

}

@end
