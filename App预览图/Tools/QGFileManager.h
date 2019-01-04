//
//  QGFileManager.h
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/21.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QGRootDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define QGHomeDirectory [QGRootDirectory stringByAppendingPathComponent:@"Diary"]

#define QGForeverDirectory [QGHomeDirectory stringByAppendingPathComponent:@"File"]

#define QGForeverPicture [QGForeverDirectory stringByAppendingString:@"/Picture"]
#define QGForeverAudio [QGForeverDirectory stringByAppendingString:@"/Audio"]
#define QGForeverScreenshot [QGForeverDirectory stringByAppendingString:@"/Screenshot"]
#define QGForeverFile [QGForeverDirectory stringByAppendingString:@"/File"]

#define QGBackupDataName @"minediary.zip"

typedef void(^QGFileManagerSuccessCallBack)(NSString *filePath) ;
typedef void(^QGFileManagerFailureCallBack)(NSError *error) ;

@interface QGFileManager : NSObject

@property (nonatomic, copy) NSString *foreverDirectory;

@property (nonatomic, copy) NSString *foreverPicture;
@property (nonatomic, copy) NSString *foreverAudio;
@property (nonatomic, copy) NSString *foreverScreenshot;
@property (nonatomic, copy) NSString *foreverFile;

+ (instancetype)manager;

- (void)saveImageToForeverDirectory:(UIImage*)image success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure;
- (void)saveImageToForeverDirectory:(UIImage*)image imageName:(NSString*)imageName success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure;
- (void)removeFileWithName:(NSString*)fileName success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure;
- (void)zipRootDirectorySuccess:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure;
- (void)clearZipRootDirectory;

- (void)recoveryDataWithPath:(NSString*)backupFilePath success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure;

@end
