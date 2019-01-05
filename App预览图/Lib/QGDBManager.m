//
//  QGDBManager.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/22.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGDBManager.h"
#import "FMDB.h"
#import <objc/runtime.h>
@interface QGDBManager ()
{

    FMDatabaseQueue *_dbQueue;
    FMDatabase *_db;
   
}
@end

@implementation QGDBManager
+ (instancetype)defaultManager{
    static QGDBManager *fmdbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbManager = [[QGDBManager alloc] init];
    });
    return fmdbManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDataBase];
    }
    return self;
}

- (void)registerTableClass:(NSArray<NSString*>*)objects result:(void (^)(NSDictionary* response))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        self->_db = db;
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
        [objects enumerateObjectsUsingBlock:^(NSString *tableName, NSUInteger idx, BOOL * _Nonnull stop) {
            Class className = NSClassFromString(tableName);
            if (className) {
                //将类名作为表名，创建数据库表
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
                        NSString *msg = [NSString stringWithFormat:@"table %@ already exist",tableName];
                        [results addObject:msg];
                        break;
                    }
                }
                
                //如果不存在，则创建对应数据库表
                if (isExistTable == NO) {
                    BOOL flag = [self createTable:tableName dataBase:db];
                    if (flag) {
                        NSString *msg = [NSString stringWithFormat:@"table %@ created success",tableName];
                        [results addObject:msg];
                    } else {
                        NSString *msg = [NSString stringWithFormat:@"table %@ created fail",tableName];
                        [results addObject:msg];
                    }
                }
            } else {
                NSString *msg = [NSString stringWithFormat:@"Invalid class %@",className];
                [results addObject:msg];
            }
            
        }];
        if (result) {
            result(@{@"code":@"1",@"msg":results});
        }
    }];
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
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[DATABASEPATH stringByAppendingPathComponent:DATABASEName]];
}

- (BOOL)createTable:(NSString*)tableName dataBase:(FMDatabase*)db{
    Class modelClass = NSClassFromString(tableName);
    if (modelClass) {
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList(modelClass, &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE '%@' ('QG_Identifier' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ",tableName];
        for(NSUInteger i = 0; i < propertyCount; i ++){
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            NSString *typeString = [self getSqliteDataTypeForProperty:propertys[i]];
            [sql appendFormat:@",'%@' %@",propertyName,typeString];
        }
        [sql appendString:@")"];
        NSInteger flag = [db executeUpdate:sql];
        if (flag > 0) {
            NSLog(@"%@ table isCreated success !", tableName);
            return YES;
        } else {
            NSLog(@"%@ table isCreated failure !", tableName);
            return NO;
        }
    } else {
        NSLog(@"无法找到对应的类,创建%@表失败!",tableName);
        return NO;
    }
}
- (NSMutableArray *)selectData:(id)data{
    Class dataClass = [data class];
    NSString *tableName = NSStringFromClass(dataClass);
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(dataClass, &propertyCount);
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
    NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:20];
    for (NSInteger i = 0; i < propertyCount; i ++) {
        NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
        id value = [data valueForKey:propertyName];
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
            
            //                NSLog(@"%@ %@",propertyName, value);
        } else {
            //                NSLog(@"%@ %@",propertyName, value);
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
    FMResultSet *resultSet = [_db executeQuery:sql withArgumentsInArray:pragramers];
    while ([resultSet next]) {
        id model = [[dataClass alloc] init];
        [model setValuesForKeysWithDictionary:[resultSet resultDictionary]];
        [resultModels addObject:model];
    }
    return resultModels;
}
- (void)selectData:(id)data result:(void (^)(NSMutableArray *resultSet))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        Class dataClass = [data class];
        NSString *tableName = NSStringFromClass(dataClass);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList(dataClass, &propertyCount);
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
                
//                NSLog(@"%@ %@",propertyName, value);
            } else {
//                NSLog(@"%@ %@",propertyName, value);
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
            id model = [[dataClass alloc] init];
            [model setValuesForKeysWithDictionary:[resultSet resultDictionary]];
            [resultModels addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(resultModels);
            }
        });
        

    }];
}

- (void)existData:(id)condition result:(void (^)(BOOL isExist))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        Class dataClass = [condition class];
        NSString *tableName = NSStringFromClass(dataClass);
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList(dataClass, &propertyCount);
        NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
        NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i < propertyCount; i ++) {
            NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
            id value = [condition valueForKey:propertyName];
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
                
                //                NSLog(@"%@ %@",propertyName, value);
            } else {
                //                NSLog(@"%@ %@",propertyName, value);
            }
        }
        if([sql hasSuffix:@"and "]){
            [sql deleteCharactersInRange:NSMakeRange(sql.length - 4, 4)];
        }
        if (pragramers.count == 0) {
            result(NO);
        } else {
            [sql appendFormat:@"limit 1"];
            FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:pragramers];
            if (resultSet && result) {
                result([resultSet next]);
            } else if(result) {
                result(NO);
            }
        }
    }];
}
- (BOOL)existData:(id)condition{
    Class dataClass = [condition class];
    NSString *tableName = NSStringFromClass(dataClass);
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(dataClass, &propertyCount);
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
    NSMutableArray *pragramers = [NSMutableArray arrayWithCapacity:20];
    for (NSInteger i = 0; i < propertyCount; i ++) {
        NSString *propertyName = [NSString stringWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
        id value = [condition valueForKey:propertyName];
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
            
            //                NSLog(@"%@ %@",propertyName, value);
        } else {
            //                NSLog(@"%@ %@",propertyName, value);
        }
    }
    if([sql hasSuffix:@"and "]){
        [sql deleteCharactersInRange:NSMakeRange(sql.length - 4, 4)];
    }
    
    if (pragramers.count == 0) {
        
        return NO;
        
    } else {
        [sql appendFormat:@"limit 1"];
        FMResultSet *resultSet = [_db executeQuery:sql withArgumentsInArray:pragramers];
        if (resultSet) {
            return [resultSet next];
        } else {
            return NO;
        }
    }
    
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
            [sqlTab appendFormat:@"'%@',",propertyName];
            [sqlPra appendString:@"?,"];
            id value = [data valueForKey:propertyName];
            if (value) {
                [pragramers addObject:value];
            } else {
                [pragramers addObject:@""];
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
- (void)updateData:(id)data condition:(NSDictionary*)condition result:(void (^)(BOOL flag))result{
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        if(condition == nil || [[condition allKeys] count] == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    result(NO);
                }
            });
            return ;
        }
        
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
        NSMutableString *conditionStr = [[NSMutableString alloc] initWithCapacity:10];
        [condition enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [conditionStr appendFormat:@"%@ = ? and ",key];
            [pragramers addObject:obj];
        }];
        if ([conditionStr hasSuffix:@"and "]) {
            [conditionStr deleteCharactersInRange:NSMakeRange(conditionStr.length - 4, 4)];
        }
        [sql appendFormat:@"WHERE %@",conditionStr];
        BOOL flag = [db executeUpdate:sql withArgumentsInArray:pragramers];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(flag);
            }
        });
    }];
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
        return @"DATETIME";
    } else if([propertyType isEqualToString:@"@\"NSString\""]){
        return @"TEXT";
    } else {
        if (strcmp(rawPropertyType, @encode(CGFloat)) == 0) {
            //it's a float
            return @"FLOAT";
        } else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0) {
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

- (NSString*)handleCondition:(NSDictionary*)condition{
    NSMutableString *conditionStr = [[NSMutableString alloc] initWithCapacity:10];
    if (condition && [condition isKindOfClass:[NSDictionary class]]) {
        [condition enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [conditionStr appendFormat:@"%@ = ? and ",key];
        }];
        if ([conditionStr hasSuffix:@"and "]) {
            [conditionStr deleteCharactersInRange:NSMakeRange(conditionStr.length - 4, 4)];
        }
        
    } else {
        NSLog(@"condition is error");
    }
    return conditionStr;
}
@end
