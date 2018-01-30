//
//  IMBSqliteManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBSqliteManager.h"
//#import "IMBBackupManager.h"
#import "IMBNotificationDefine.h"
#import "TempHelper.h"
//#import "IMBBackupDecrypt.h"
@implementation IMBSqliteManager
@synthesize dbType = _dbType;
@synthesize dataAry = _dataAry;
@synthesize logManger = _logManger;
- (id)initWithAMDevice:(AMDevice *)device path:(NSString *)dataBasePath
{
    self = [super init];;
    if (self) {
        _device = [device retain];
        if (dataBasePath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:dataBasePath];
        }
       _logManger = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
    }
    return self;
    
}

//- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
//    if ([super init]) {
//        _iOSVersion = [type retain];
//        _logManger = [IMBLogManager singleton];
//        fm = [NSFileManager defaultManager];
//        _dataAry = [[NSMutableArray alloc]init];
//        _iCloudBackup = [iCloudBackup retain];
//    }
//    return self;
//}


//- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt
//{
//    self = [super init];
//    if (self) {
//        fm = [NSFileManager defaultManager];
//        _logManger = [IMBLogManager singleton];
////        NSString *str = [[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"decriptBackup"] stringByAppendingPathComponent:[backupfilePath lastPathComponent]];
////        if ([fm fileExistsAtPath:str]) {
////            [fm removeItemAtPath:str error:nil];
////        }
////        [fm copyItemAtPath:backupfilePath toPath:str error:nil];
//        _iOSVersion = [type retain];
//        _device = [dev retain];
//        _decrypt = decypt;
//
//        _dataAry = [[NSMutableArray alloc]init];
//     
////        IMBBackupManager *manager = [IMBBackupManager shareInstance];
////       NSString *sqlitePath = [manager copysqliteToApptempWithsqliteName:sqliteName backupfilePath:backupfilePath];
////        if (sqlitePath != nil) {
////             _databaseConnection = [[FMDatabase alloc] initWithPath:sqlitePath];
////        }
//    }
//    return self;
//}


- (void)querySqliteDBContent{

}

- (id)initWithAMDevice:(AMDevice *)dev
{
    self = [super init];
    if (self) {
        _device = [dev retain];
        _logManger = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
    }
    return self;
}

- (id)initWithAMDeviceByexport:(AMDevice *)dev
{
    self = [super init];
    if (self) {
        _device = [dev retain];
        _logManger = [IMBLogManager singleton];
        _threadBreak = NO;
        fm = [NSFileManager defaultManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThreadBreak:) name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
    }
    
    return self;
}

//+ (NSString *)getBackupFileFloatVersion:(NSString *)backupPath
//{
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
//    NSString *desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
//    if ([fileManager fileExistsAtPath:desfilePath]) {
//        
//        [fileManager removeItemAtPath:desfilePath error:nil];
//    }
//    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
//    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
//    NSDictionary *lockDic  = [mpDic objectForKey:@"Lockdown"];
//    NSString *productVersion = [lockDic objectForKey:@"ProductVersion"];
//    NSString *versionstrone = nil;
//    if (productVersion.length>=3) {
//        NSRange range;
//        NSString *str = [productVersion substringWithRange:NSMakeRange(2, 1)];
//        if ([str isEqualToString:@"."]) {
//            range.length = 4;
//            range.location = 0;
//        }else{
//            range.length = 3;
//            range.location = 0;
//        }
//        versionstrone = [productVersion substringWithRange:range];
//        return versionstrone;
//    }
//    return @"10.0";
//}


//- (NSString *)copysqliteToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray
//{
//    NSString *desfilePath = nil;
//    NSString *iosVersion = [IMBSqliteManager getBackupFileFloatVersion:backupfilePath];
//    if (recordArray.count > 0) {
//        NSFileManager *filemanager = [NSFileManager defaultManager];
//        for (IMBMBFileRecord *record in recordArray) {
//            NSString *filename = [record.path lastPathComponent];
//            if ([filename isEqualToString:sqliteName]) {
//                NSString *sourcefilePath = nil;
//                if ([iosVersion isVersionMajorEqual:@"10"]) {
//                    NSString *fd = @"";
//                    if (record.key.length > 2) {
//                        fd = [record.key substringWithRange:NSMakeRange(0, 2)];
//                    }
//                    sourcefilePath = [[backupfilePath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:record.key];
//                }else {
//                    sourcefilePath = [backupfilePath stringByAppendingPathComponent:record.key];
//                }
//                if ([filemanager fileExistsAtPath:sourcefilePath]) {
//                    
//                    desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:record.key];
//                    //假如该文件已经存在,则先删除
//                    if ([filemanager fileExistsAtPath:desfilePath]) {
//                        [filemanager removeItemAtPath:desfilePath error:nil];
//                    }
//                    BOOL success = [filemanager copyItemAtPath:sourcefilePath toPath:desfilePath error:nil];
//                    if (!success) {
//                        NSLog(@"数据库文件拷贝失败");
//                        return nil;
//                    }
//                    //找到即跳出循环
//                    break;
//                    
//                }else
//                {
//                    NSLog(@"该备份数据库文件已被删除");
//                    return nil;
//                }
//            }
//        }
//    }
//    return desfilePath;
//}


- (void)changeThreadBreak:(NSNotification *)notification
{
    _threadBreak = YES;
}

- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	
    return str;
}

//将秒数转换为标准时间格式
- (NSString *)getDateStrBySecond:(int)second
{
    
    
    int hour = second/3600.0;
    int min  = (second - hour*3600)/60.0;
    int se   = second - hour*3600 - min*60;
    
    NSString *hourstr = nil;
    NSString *minstr  = nil;
    NSString *sestr   = nil;
    
    if (hour<10) {
        hourstr = [NSString stringWithFormat:@"0%d",hour];
    }else
    {
        hourstr = [NSString stringWithFormat:@"%d",hour];
    }
    if (min<10) {
        minstr = [NSString stringWithFormat:@"0%d",min];
    }else
    {
        minstr = [NSString stringWithFormat:@"%d",min];
    }
    if (se<10) {
        sestr = [NSString stringWithFormat:@"0%d",se];
    }else
    {
        sestr = [NSString stringWithFormat:@"%d",se];
    }
    
    
    return [NSString stringWithFormat:@"%@:%@:%@",hourstr,minstr,sestr];
    
}

- (NSString *)createDifferentfileNameinfolder:(NSString *)folder filePath:(NSString *)filePath fileManager:(NSFileManager *)fileMan
{
    NSString *fileName = [filePath lastPathComponent];
    NSString *newfilePath = nil;
    NSArray *arr = [fileName componentsSeparatedByString:@"."];
    int i = 1;
    //没有扩展名
    if (arr.count == 1) {
        
        while (1) {
            newfilePath = [folder stringByAppendingFormat:@"/%@(%d)",fileName,i];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                break;
            }
            
            i++;
            
        }
        
        
    }else //有扩展名
    {
        NSString *filename = nil;
        NSString *extensionname = nil;
        if (arr.count>=2) {
            
            filename = [arr objectAtIndex:0];
            extensionname = [arr objectAtIndex:1];
            
        }
        
        while (1) {
            
            newfilePath = [folder stringByAppendingFormat:@"/%@(%d).%@",filename,i,extensionname];
            if (![fileMan fileExistsAtPath:newfilePath]) {
                
                break;
                
            }
            
            i++;
           
            
        }
    }
    
    return newfilePath;
    
}



- (BOOL)openDataBase {
    if ([_databaseConnection open]) {
        [_databaseConnection setShouldCacheStatements:NO];
        [_databaseConnection setTraceExecution:NO];
        return true;
    }
    return false;
}

- (void)closeDataBase {
    [_databaseConnection close];
}

- (void)dealloc
{
    if (_device != nil) {
        [_device release];
        _device = nil;
    }
    if (_databaseConnection != nil) {
        [_databaseConnection release];
        _databaseConnection = nil;
    }
    if (_dataAry != nil) {
        [_dataAry release];
        _dataAry = nil;
    }
    if (_iOSVersion != nil) {
        [_iOSVersion release];
        _iOSVersion = nil;
    }
//    if (_iCloudBackup != nil) {
//        [_iCloudBackup release];
//        _iCloudBackup = nil;
//    }
//    if (_backUpPath != nil) {
//        [_backUpPath release];
//        _backUpPath = nil;
//    }
//    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
    [super dealloc];
}



@end
