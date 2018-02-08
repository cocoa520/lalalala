//
//  IMBConfigurationEntity.m
//  AnyTransiCloudDownload
//
//  Created by long on 16-10-10.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBConfigurationEntity.h"
#import <sys/socket.h>
#import "Device.h"
#import "SnapshotEx.h"
#import "IMBLogManager.h"
#import "IMBSocketServer.h"
@implementation IMBConfigurationEntity
@synthesize icloudClient = _icloudClient;
@synthesize snapshotAry = _snapshotAry;
@synthesize isStop = _isStop;
+ (IMBConfigurationEntity *)singleton {
    static IMBConfigurationEntity *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBConfigurationEntity alloc] init];
        }
    }
    return _singleton;
}

-(id)init{
    if ([super init]) {
        _icloudClient = [[iCloudClient alloc]init];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    if (_icloudClient != nil) {
        [_icloudClient release];
        _icloudClient = nil;
    }
    if (_dataDic != nil) {
        [_dataDic release];
        _dataDic = nil;
    }
}

- (void)needTwoStepAuth{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IMBLogManager singleton] writeInfoLog:@"_isTwoStepAuth fail"];
        _isTwoStepAuth = YES;
//        [_operationController loadViewController:self WithType:Clean_NoSelectStatus];
//        [_operationController loadNoSelectViewDataTitle:CustomLocalizedString(@"iCloud_DoubleCheck_Error", nil) WithBtnName:CustomLocalizedString(@"button_id_1", nil) WithImageName:@"restore_ipad_img"];
    });
    
}

//登陆
-(void)loginIcloud:(NSDictionary *)dic withConnectInt:(int)connectfd{
    [[IMBLogManager singleton] writeInfoLog:@"login Icloud start"];
    if (_dataDic != nil) {
        [_dataDic release];
        _dataDic = nil;
    }
    _isTwoStepAuth = NO;
    
    _dataDic = [[NSMutableDictionary alloc]init];
    _connectfd = connectfd;
    NSString *appleID = @"";
    if ([dic.allKeys containsObject:@"iCloudID"]) {
        appleID = [dic objectForKey:@"iCloudID"];
    }
    NSString *password = @"";
    if ([dic.allKeys containsObject:@"iCloudPassword"]) {
        password = [dic objectForKey:@"iCloudPassword"];
    }
    BOOL isRet = NO;
    BOOL isnetworkfail = NO;
    [_icloudClient setDelegate:self];
    @try {
        [[IMBLogManager singleton] writeInfoLog:@"Verify account password"];
        isRet = [_icloudClient auth:appleID withPassword:password];
    }
    
    @catch (NSException *exception) {
        [[IMBLogManager singleton] writeInfoLog:@"loginEorro"];
        isnetworkfail = YES;
        //        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"icloudLoginNetworkfail", @"MsgType", nil];
        //        NSString *str = [self dictionaryToJson:dic1];
        //        [self sendData:str];
    }
    if (!_isTwoStepAuth) {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"%d",isRet]];
        
        NSString *notificationName = @"";
        if (isnetworkfail) {
            notificationName = @"icloudLoginNetworkfail";
        }else{
            notificationName = @"icloudLogin";
        }
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:notificationName, @"MsgType",[NSString stringWithFormat:@"%d",isRet], @"loginSuccess", nil];
        NSString *str = [self dictionaryToJson:dic1];
        [[IMBSocketServer singleton] sendDataToClient:str];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"sendData login msg Json:%@",str]];
    }else{
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"isTwoStepAuthOpen", @"MsgType", nil];
        NSString *str = [self dictionaryToJson:dic1];
        [[IMBSocketServer singleton] sendDataToClient:str];
    }
     //    [[IMBLogManager singleton] writeInfoLog:@"sendData login msg"];
}

+ (NSDate*)getDateTimeFromTimeStamp2001:(double)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00"];
    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate] autorelease];
#if !__has_feature(objc_arc)
    if (dateFormatter != nil) [dateFormatter release]; dateFormatter = nil;
#endif
    return returnDate;
}

-(void)loadingData{
    [[IMBLogManager singleton] writeInfoLog:@"start icloud read information"];
    NSString *appTempPath;
    //    NSBundle *bundle = [NSBundle mainBundle];
    //    NSString *identifier = [bundle bundleIdentifier];
    //    NSString *appName = [[bundle infoDictionary] objectForKey:@"CFBundleName"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    appTempPath =[[[homeDocumentsPath  stringByAppendingPathComponent:@"com.imobie.AnyTrans"] stringByAppendingPathComponent:@"AnyTrans"] stringByAppendingPathComponent:@"iCloud"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appTempPath]) {
        [fileManager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _icloudClient.outputFolder = appTempPath;
    NSMutableDictionary *deviceSnapshotDict = nil;
    @try {
        deviceSnapshotDict = [_icloudClient queryBackupInfo];
    }
    @catch (NSException *exception) {
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"icloudLoginNetworkfail", @"MsgType", nil];
        NSString *str = [self dictionaryToJson:dic1];
        [self sendData:str];
    }
    
    _deviceSnapshotDict = deviceSnapshotDict;
    if (deviceSnapshotDict != nil && deviceSnapshotDict.count > 0) {
        NSEnumerator *iter = [deviceSnapshotDict keyEnumerator];
        Device *dev = nil;
        while (dev = [iter nextObject]) {
            NSArray *snapshots = [deviceSnapshotDict objectForKey:dev];
            for (int i = 0; i < snapshots.count; i++) {
                @autoreleasepool {
                    if (_isStop) {
                        return;
                    }
                    SnapshotEx *snapshot = [snapshots objectAtIndex:i];
                    NSString *deviceType = [dev deviceClass];
                    NSString *deviceName = [snapshot deviceName];
                    int64_t backupSize = [snapshot quotaUsed];
                    NSString *serialNumber = [dev serialNumber];
                    NSString *iOSVersion = [snapshot deviceIOSVersion];
                    NSString *uuid = [dev uuid];
                    NSString *backUpPath = [snapshot relativePath];
                    NSString *snapshotsInfo = [snapshot info];
                    CFTimeInterval timestamp;
                    @autoreleasepool {
                        NSMutableDictionary *snapshotTimestamp = [[[NSMutableDictionary alloc] init] autorelease];
                        NSMutableArray *snapshotIDs = [dev getSnapshots];
                        NSEnumerator *iterator = [snapshotIDs objectEnumerator];
                        SnapshotID *snapshotID = nil;
                        while (snapshotID = [iterator nextObject]) {
                            [snapshotTimestamp setObject:@([snapshotID timestamp]) forKey:[snapshotID iD]];
                        }
                        
                         timestamp = [snapshotTimestamp.allKeys containsObject:[snapshot name]] ? [[snapshotTimestamp objectForKey:[snapshot name]] doubleValue] : [snapshot modification];
                    }
                    [_dataDic setObject:dev forKey:backUpPath];

//                    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"snapshotsInfo:%@",snapshotsInfo]];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"downDataSuccess", @"MsgType",deviceType, @"deviceType",deviceName,@"deviceName",[NSNumber numberWithLongLong:backupSize],@"backupSize",serialNumber,@"serialNumber",iOSVersion,@"iOSVersion",[NSNumber numberWithLongLong:timestamp],@"lastModified",[NSNumber numberWithInt:i],@"count",uuid,@"uuid",backUpPath,@"relativePath", nil];
                    NSString *str = [self dictionaryToJson:dic];
                    [self sendData:str];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[IMBLogManager singleton] writeInfoLog:@"sendDataToMain"];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"downDataComple", @"MsgType", nil];
            NSString *str = [self dictionaryToJson:dic];
            [self sendData:str];
             [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"%@",str]];
        });
        
    }
    [[IMBLogManager singleton] writeInfoLog:@"end icloud read information"];
}

-(void)downIcloudData:(NSDictionary*)dic{
    [[IMBLogManager singleton] writeInfoLog:@"start icloud down backup"];
    int downcount = 0;
    if ([dic.allKeys containsObject:@"downCountID"]) {
        downcount = [[dic objectForKey:@"downCountID"] intValue];
    }
    NSString *backupDate = @"";
    if ([dic.allKeys containsObject:@"backupDate"]) {
        backupDate = [dic objectForKey:@"backupDate"];
    }
    //    SnapshotEx *snapshot = [_snapshotAry objectAtIndex:downcount];
    Device *device = [_dataDic objectForKey:backupDate];
    NSArray *snapshots = [_deviceSnapshotDict objectForKey:device];
    NSMutableArray *domains = [[[NSMutableArray alloc] initWithObjects:@"HomeDomain", @"MediaDomain", @"CameraRollDomain", @"AppDomainGroup-group.com.apple.notes", @"AppDomain-com.apple.mobilesafari", nil] autorelease];
   
    //    NSString *iCloudDownloadPath = [TempHelper getiCloudLocalPath];
    //    _icloudClient.outputFolder = icloudLocalPath;
    SnapshotEx *snapshot = [snapshots objectAtIndex:downcount];
    @try {
        cancel = NO;
        NSString *iOSVersion = [snapshot deviceIOSVersion];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"snapshot:%@ %d iosVersion:%@", snapshot.info,downcount,iOSVersion]];
        [_icloudClient downloadWithDevice:device withSnapshot:snapshot withDomains:domains withCancel:&cancel];
        [[IMBLogManager singleton] writeInfoLog:@"_icloudClient device down backup end"];
    }
    @catch (NSException *exception) {
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"icloudLoginNetworkfail",nil];
        NSString *str = [self dictionaryToJson:dic1];
        [self sendData:str];
    }

    [[IMBLogManager singleton] writeInfoLog:@"end icloud down backup"];
}

- (void)stopDownIcloud{
    cancel = YES;
}


- (void)downloadProgress:(uint64_t)totalSize withCompleteSize:(uint64_t)completeSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        NSDictionary *dic = [notification userInfo];
        long totalsize = totalSize;
        long downloadsize = completeSize;
        //        if (downloadsize > _downloadedTotalSize) {
        //            _downloadedTotalSize = downloadsize;
        //        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"downiCloudDataProess", @"MsgType",[NSNumber numberWithLong:totalsize],@"totalsize",[NSNumber numberWithLong:downloadsize],@"downloadsize", nil];
        NSString *str = [self dictionaryToJson:dic];
        [self sendData:str];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"icloud down backupdownloadsize:%ld totalsize:%ld",downloadsize,totalsize]];
        //        _totalSize = totalsize;
        //        [_iCloudInfoTableView reloadData];
    });
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        NSLog(@"(completeSize / (double)totalSize) ==== %@", [NSString stringWithFormat:@"%.2f%%", (completeSize / (double)totalSize) * 100]);
    //    });
}
- (void)downloadComplete {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"downiCloudDataProessComplete",@"MsgType", nil];
    NSString *str = [self dictionaryToJson:dic];
    [self sendData:str];
    [[IMBLogManager singleton] writeInfoLog:@"icloud down downiCloudDataProessComplete"];
}

//向client发送消息
- (void)sendData:(NSString *)str {
    const char *sendline = [str UTF8String];
    if (send(_connectfd, sendline, strlen(sendline), 0) < 0) {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"send msg error: %s(errno: %d)",strerror(errno),errno]];
        NSLog(@"error");
    }
}

- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSString *jsonStr = nil;
    if (dic != nil) {
        [[IMBLogManager singleton] writeInfoLog:@"JSONObject"];
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
            jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"jsonStr:%@",jsonStr);
        }
        [[IMBLogManager singleton] writeInfoLog:@"JSONObject end"];
    }
    return jsonStr;
}
@end
