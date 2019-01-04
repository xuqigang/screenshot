//
//  QGFileManager.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/21.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGFileManager.h"
#import "ZipArchive.h"
#import "QGDBManager.h"

@interface QGFileManager ()
{

    
}

@end
@implementation QGFileManager
+ (instancetype)manager{
    static QGFileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[QGFileManager alloc] init];
    });
//    fileManager = [[QGFileManager alloc] init];
    return fileManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _foreverDirectory = QGForeverDirectory;
        
        _foreverPicture = [_foreverDirectory stringByAppendingString:@"/Picture"];
        _foreverAudio = [_foreverDirectory stringByAppendingString:@"/Audio"];
        _foreverScreenshot = [_foreverDirectory stringByAppendingString:@"/Screenshot"];
        _foreverFile = [_foreverDirectory stringByAppendingString:@"/Other"];
        [self initDirectory];
        
    }
    return self;
}
- (void)initDirectory{
    [self createDirectory:_foreverPicture];
    [self createDirectory:_foreverAudio];
    [self createDirectory:_foreverScreenshot];
    [self createDirectory:_foreverFile];
}

- (void)createDirectory:(NSString*)directory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExist = [fileManager fileExistsAtPath:directory isDirectory:&isDir];
    
    if (directory && !(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:directory
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
        
        if(!bCreateDir){
            
            NSLog(@"Create Directory Failed.");
            
        }
    }
}





- (void)saveData:(NSData*)fileData toFilePath:(NSString*)filePath success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (filePath && fileData) {
            BOOL flag = [fileData writeToFile:filePath atomically:NO];
            if (flag) {
                if (success) {
                    success(filePath);
                    NSLog(@"path = %@",filePath);
                }
            } else {
                if (failure){
                    failure(nil);
                }
            }
        } else {
            if (failure){
                failure(nil);
            }
        }
    });
}

- (void)saveImageToForeverDirectory:(UIImage*)image imageName:(NSString*)imageName success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure{
    if (image && [image isKindOfClass:[UIImage class]]) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        // 获取沙盒目录
        NSString *fullPath = [_foreverPicture stringByAppendingPathComponent:imageName];
        [self saveData:imageData toFilePath:fullPath success:success failure:failure];
    } else {
        if (failure){
            failure(nil);
        }
    }
}

- (void)saveImageToDirectory:(NSString*)directory image:(UIImage*)image success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure{
    if (image && [image isKindOfClass:[UIImage class]]) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSString *pictureName = [NSString stringWithFormat:@"%.0f_%d.jpg",[NSDate date].timeIntervalSince1970 * 6,arc4random()%1000];
        // 获取沙盒目录
        NSString *fullPath = [directory stringByAppendingPathComponent:pictureName];
        [self saveData:imageData toFilePath:fullPath success:success failure:failure];
    } else {
        if (failure){
            failure(nil);
        }
    }
}

- (void)saveImageToForeverDirectory:(UIImage*)image success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure{
    [self saveImageToDirectory:_foreverPicture image:image success:success failure:failure];
}

- (void)removeFileWithName:(NSString*)fileName success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *foreverPath= [self->_foreverPicture stringByAppendingPathComponent:fileName];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:foreverPath error:&error];
        if (error && failure) {
            failure(error);
        } else if(error == nil && success){
            success(foreverPath);
        }
    });
}
- (void)moveItemToForeverDirectory:(NSString*)temPath success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure{
    NSError *error = nil;
    
    NSString *fileName = [temPath lastPathComponent];
    NSString *foreverPath= [_foreverPicture stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] moveItemAtPath:temPath toPath:foreverPath error:&error];
    if (error) {
        if (failure) {
            failure(nil);
        }
    } else {
        if (success) {
            success(foreverPath);
        }
    }
    
}

- (void)clearTemporaryDirectory{

}

- (void)zipRootDirectorySuccess:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        ZipArchive * zipArchive = [ZipArchive new];
        NSString *destZipFile = [QGRootDirectory stringByAppendingPathComponent:QGBackupDataName];
        NSString * sourcePath = QGHomeDirectory;
        [zipArchive CreateZipFile2:destZipFile];
        NSArray *subPaths = [fileManager subpathsAtPath:sourcePath];// 关键是subpathsAtPath方法
        for(NSString *subPath in subPaths){
            NSString *fullPath = [sourcePath stringByAppendingPathComponent:subPath];
            BOOL isDir;
            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)// 只处理文件
            {
                [zipArchive addFileToZip:fullPath newname:subPath];
            }
        }
        
        if([zipArchive CloseZipFile2]){
            if (success) {
                success(destZipFile);
            }
        } else {
            if (failure) {
                failure(nil);
            }
        };
        
        
    });
    
}

- (void)clearZipRootDirectory{
    NSString *foreverPath= [QGRootDirectory stringByAppendingPathComponent:QGBackupDataName];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:foreverPath error:&error];
}

- (void)recoveryDataWithPath:(NSString*)backupFilePath success:(QGFileManagerSuccessCallBack) success failure:(QGFileManagerFailureCallBack)failure;{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *pathExtension = [QGBackupDataName pathExtension];
    if ([backupFilePath.pathExtension isEqualToString:pathExtension]) {
        NSString *unZipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Diary"];
        [self createDirectory:unZipPath];
        ZipArchive * zipArchive = [ZipArchive new];
        if([zipArchive UnzipOpenFile:backupFilePath]){
            
            BOOL flag = [zipArchive UnzipFileTo:unZipPath overWrite:YES];
            [zipArchive UnzipCloseFile];
            if (flag && [self checkBackupDataWithPath:unZipPath]) {
                
                //清空QGHomeDirectory文件夹
                NSError *error;
                [fileManager removeItemAtPath:QGHomeDirectory error:&error];
                error = nil;
                //将解压后的文件移动到QGHomeDirectory下
                [fileManager moveItemAtPath:unZipPath toPath:QGHomeDirectory error:&error];
                if (!error) {
                    [self updateDirectoryFile];
                    success(QGHomeDirectory);
                } else {
                    return failure(error);
                }
                
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.recoverydata" code:-1000 userInfo:@{@"message":@"压缩文件可能已经损坏"}];
                return failure(error);
            }
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"com.recoverydata" code:-1000 userInfo:@{@"message":@"这可能不是一个压缩文件"}];
            return failure(error);
        }
        
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.recoverydata" code:-1000 userInfo:@{@"message":@"文件格式有误"}];
        return failure(error);
    }
    
}

- (BOOL)checkBackupDataWithPath:(NSString*)backupFilePath{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray<NSString *> *contents = [fileManager contentsOfDirectoryAtPath:backupFilePath error:&error];
    __block BOOL flag = NO;
    [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"DB"]) {
            NSString *dbPath = [backupFilePath stringByAppendingPathComponent:@"DB"];
            NSError *error;
            NSArray<NSString *> *dbContents = [fileManager contentsOfDirectoryAtPath:dbPath error:&error];
            [dbContents enumerateObjectsUsingBlock:^(NSString * _Nonnull objdb, NSUInteger idxdb, BOOL * _Nonnull stopdb) {
                if ([objdb isEqualToString:@"diary.sqlite3"]) {
                    flag = YES;
                    *stopdb = YES;
                    *stop = YES;
                }
            }];
        }
    }];
    return flag;
}
- (void)updateDirectoryFile{
    [self initDirectory];
    [QGDBManager reloadDB];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTableViewDataSourceNotification" object:nil];
    NSError *error;
    NSString *tmpDir = NSTemporaryDirectory();
    [[NSFileManager defaultManager] removeItemAtPath:tmpDir error:&error];
    [self createDirectory:tmpDir];
}

@end
