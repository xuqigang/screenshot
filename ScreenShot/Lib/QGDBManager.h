//
//  QGDBManager.h
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/22.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 宏定义数据库的存放路径以及名字

 @param instancetype 无
 @return 无
 */
#define DATABASEPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DB"]
#define DATABASEName @"mydatabase.sqlite3"
@interface QGDBManager : NSObject

+ (instancetype)defaultManager;

/**
 注册数据库表，该方法建议写在APP启动时- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法中。

 @param objects 需要创建的数据库表对应的类对象，默认创建QG_Identifier字段，object 应该直接继承NSObject类。
 @param result 创建结果回调
 */
- (void)registerTableClass:(NSArray<NSString *>*)objects result:(void (^)(NSDictionary* response))result;

/**
 查询数据

 @param data 要查询的对象
 @param result result 查询的结果
 */
- (void)selectData:(id)data result:(void (^)(NSMutableArray *resultSet))result;

/**
 查询数据,非线程安全
 
 @param data 要查询的对象
 */
- (NSMutableArray *)selectData:(id)data;
/**
 判断符合condition的数据是否存在，线程安全
 
 @param condition 条件
 */
- (void)existData:(id)condition result:(void (^)(BOOL isExist))result;
/**
 判断符合condition的数据是否存在，非线程安全
 @param condition 条件
 */
- (BOOL)existData:(id)condition;
/**
 插入一条数据

 @param data 要插入的对象，data对象建议不要给id字段赋值
 @param result 插入的结果，flag == NO 表示插入失败
 */
- (void)insertData:(id)data result:(void (^)(BOOL flag))result;

/**
 修改数据

 @param data 要修改的数据，
 @param condition 条件字典，key一定要是data的成员属性
 @param result 插入的结果，flag == NO 表示修改失败
 */
- (void)updateData:(id)data condition:(NSDictionary*)condition result:(void (^)(BOOL flag))result;

/**
 删除数据

 @param data 要删除的数据，其中data中的id字段不能为空，因为删除操作是以id为关键字
 @param result 删除的结果，flag == NO 表示删除失败
 */
- (void)deleteData:(id)data result:(void (^)(BOOL flag))result;

/**
 执行一条原生的sql语句

 @param sql sql语句
 @param arguments 传入的参数
 @param result 结果回调，response可能是一个数组、字典、BOOL
 */
- (void)executeSQL:(NSString*)sql withArgumentsInArray:(NSArray*)arguments result:(void(^)(id response))result;

@end
