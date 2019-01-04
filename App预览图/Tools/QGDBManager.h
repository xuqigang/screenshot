//
//  QGDBManager.h
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/22.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGDBTableListManager.h"
@interface QGDBManager : NSObject

+ (instancetype)shareManager;
+ (void)reloadDB;

- (void)selectData:(id)data result:(void (^)(NSMutableArray *resultSet))result;

//升序结果
- (void)selectData:(id)data orderBy:(NSString*)rowName ascResult:(void (^)(NSMutableArray *resultSet))result;
//降序结果
- (void)selectData:(id)data orderBy:(NSString*)rowName descResult:(void (^)(NSMutableArray *resultSet))result;
- (void)insertData:(id)data result:(void (^)(BOOL flag))result;
- (void)updateData:(id)data result:(void (^)(BOOL flag))result;
- (void)deleteData:(id)data result:(void (^)(BOOL flag))result;;
- (void)executeSQL:(NSString*)sql withArgumentsInArray:(NSArray*)arguments result:(void(^)(id response))result;

@end
