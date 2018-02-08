//
//  IMBApplicationManager.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-16.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBApplicationManager.h"
#import "IMBFileSystem.h"
#import "IMBZipHelper.h"
#import "IMBSession.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "IMBDeviceInfo.h"
#import "TempHelper.h"
@implementation IMBApplicationManager
static int fileCount = 0;
@synthesize appEntityArray = _appEntityArray;

- (id)initWithiPod:(IMBiPod*)iPod {
    self = [super init];
    if (self) {
        _iPod = iPod;
        _device = _iPod.deviceHandle;
//        _appConfig = [_iPod appConfig];
        nc = [NSNotificationCenter defaultCenter];
        logHandle = [IMBLogManager singleton];
        //_appEntityArray = [[self getIntalledAppArray] retain];
        _threadBreak = NO;
//        _softWareInfo = [IMBSoftWareInfo singleton];
        _transResult = [IMBResultSingleton singleton];
        _progressCounter = [IMBProgressCounter singleton];
        [_progressCounter reInit];
        [_transResult reInit];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThreadBreak:) name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
    }
    return self;
}

- (void)changeThreadBreak:(NSNotification *)notification
{
    _threadBreak = YES;
}

- (void)loadAppArray
{

     _appEntityArray = [[self getIntalledAppArray] retain];
   
}
- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]  removeObserver:self name:NOTIFY_PROGRESS_SHOULD_CLOSE object:nil];
    if (_appEntityArray != nil) {
        [_appEntityArray release];
        _appEntityArray = nil;
    }
    [super dealloc];
}

- (void) setListener:(id)listener {
    if (_listener != nil) {
        _listener = nil;
    }
    _listener = listener;
}

- (void) removeListener {
    if (_listener != nil) {
        _listener = nil;
    }
}

- (NSArray*) refreshAppEntityArray {
    if (_appEntityArray != nil) {
        [_appEntityArray release];
        _appEntityArray = nil;
    }
    _appEntityArray = [[self getIntalledAppArray] retain];
    return _appEntityArray;
}

//备份文件到本地
//TODO 1.进度信息没追加
//2.未把instalProxy放到最外层
- (bool) backupAppTolocal:(IMBAppEntity*)appEntity ArchiveType:(IMBAppTransferTypeEnum)archiveType LocalFilePath:(NSString*)LocalFilePath {
    
    if (![_iPod.fileSystem fileExistsAtPath:@"/ApplicationArchives"]) {
        [_iPod.fileSystem mkDir:@"/ApplicationArchives"];
    }
    
    AFCApplicationDirectory* appDir = [_device newAFCApplicationDirectory:appEntity.appKey];
    //如果一些默认的文件夹不存在的话，就创建。
    if (appDir != nil) {
        if (![appDir fileExistsAtPath:@"/Documents"]) {
            [appDir mkdir:@"/Documents"];
        }
        if (![appDir fileExistsAtPath:@"/Library"]) {
            [appDir mkdir:@"/Library"];
        }
        if (![appDir fileExistsAtPath:@"/tmp"]) {
            [appDir mkdir:@"/tmp"];
        }
        [appDir close];
    }
    
    bool result = false;
    AMInstallationProxy *instalProxy = [_device newAMInstallationProxyWithDelegate:self];
    
    //如果存在则删除备份
    NSString *archivedFilePath = [[@"/ApplicationArchives" stringByAppendingPathComponent:appEntity.appKey] stringByAppendingPathExtension:@"zip"];
    if ([_iPod.fileSystem fileExistsAtPath:archivedFilePath]) {
        [instalProxy removeArchive:appEntity.appKey];
    }
    
    //第一步
    [self setCurStep:1];
    switch (archiveType) {
        case AppTransferType_All:
            result = [instalProxy archive:appEntity.appKey container:true payload:true uninstall:false];
            break;
        case AppTransferType_DocumentsOnly:
            result = [instalProxy archive:appEntity.appKey container:true payload:false uninstall:false];
            break;
        case AppTransferType_ApplicationOnly:
            result = [instalProxy archive:appEntity.appKey container:false payload:true uninstall:false];
            break;
        default:
            result = [instalProxy archive:appEntity.appKey container:true payload:true uninstall:false];
            break;
    }
    if (result == true) {
        //第二步
        [self setCurStep:2];
        NSString *archivedFilePath = [[@"/ApplicationArchives" stringByAppendingPathComponent:appEntity.appKey] stringByAppendingPathExtension:@"zip"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:LocalFilePath] ) {
            [fm removeItemAtPath:LocalFilePath error:nil];
        }
        if ([_iPod.fileSystem fileExistsAtPath:archivedFilePath]) {
            [_iPod.fileSystem copyRemoteFile:archivedFilePath toLocalFile:LocalFilePath];
            //第三步
            [self setCurStep:3];
            [instalProxy removeArchive:appEntity.appKey];
            return true;
        }
    } else {
        NSLog(@"Archive failed");
    }
    return false;
}

- (bool) recursiveCopyFromLocal:(NSString*) localPath ToApp:(AFCApplicationDirectory*)appDir ToPath:(NSString*)remotePath {
    if (appDir != nil) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *tempArray = [fm contentsOfDirectoryAtPath:localPath error:nil];
        NSMutableDictionary *info = nil;
        if (tempArray != nil && [tempArray count] > 0) {
            NSString *temPath = @"";
            for (NSString *item in tempArray) {
                temPath = [localPath stringByAppendingPathComponent:item];
                NSDictionary *fileInfoDic = [fm attributesOfItemAtPath:temPath error:nil];
                if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                    NSString *fileType = [fileInfoDic objectForKey:NSFileType];
                    if ([NSFileTypeRegular isEqualToString:fileType]) {
                        info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                item, @"param1"
                                , nil];
                        NSString *remotingFilePath = [remotePath stringByAppendingPathComponent:item];
                        @try {
                            //[[iPod fileSystem] copyLocalFile:temPath toRemoteFile:remotingFilePath];
                            [appDir copyLocalFile:temPath toRemoteFile:remotingFilePath];
                        }
                        @catch (NSException *exception) {
                            return false;
                        }
                    } else if ([NSFileTypeDirectory isEqualToString:fileType]) {
                        NSString *newRemotingPath = nil;
                        newRemotingPath = [remotePath stringByAppendingPathComponent:item];
                        @try {
                            if (![appDir fileExistsAtPath:newRemotingPath]) {
                                [appDir mkdir:newRemotingPath];
                            }
                            [self recursiveCopyFromLocal:temPath ToApp:appDir ToPath:newRemotingPath];
                        }
                        @catch (NSException *exception) {
                            return false;
                        }
                    }
                }
            }
        }
    }
    return true;
}

- (bool)checkAllowInstall:(IMBAppEntity *)srcApp targetApp:(IMBAppEntity *)tarApp {
    if (srcApp != nil && srcApp.version!= nil) {
        NSLog(@"srcApp.minimunOSVerison %@",srcApp.minimunOSVerison);
        NSLog(@"_iPod.deviceInfo.productVersion %@",_iPod.deviceInfo.productVersion);
        
        if ([_iPod.deviceInfo.productVersion isVersionAscending:srcApp.minimunOSVerison]) {
            NSLog(@"MSG_IOS_Not_Support_The_App");
            return false;
        }
    }
    
    if (srcApp != nil) {
        //TODO productType is equal ? TODO 应该是iPad 到 iPhone
        //TODO 这里直接交给安装程序来搞定
        /*
        NSLog(@"uiDeviceFamily: %d", AppUIDeivceFamily_iPhone);
        NSLog(@"productType: %@", _iPod.deviceInfo.productType);
        NSLog(@"family: %d", srcApp.uiDeviceFamily);
        NSLog(@"_iPod.deviceInfo.productType: %d", [_iPod.deviceInfo.productType containsString:@"iPad"]);
        if (![_iPod.deviceInfo.productType containsString:@"iPad"] && srcApp.uiDeviceFamily == AppUIDeivceFamily_iPad) {
            NSLog(@"MSG_App_Not_Support_The_Device");
            return false;
        }
        */
    }
    //这里需要读入配置文件，得到是否需要Upgrade与downgrade
    //TODO App config可以先进行读取，作为属性给ApplicationManager
    if (tarApp != nil) {
        //先判断要导入的app是否大于等于设备上的App
        bool isGreater = [tarApp.version isVersionAscending:srcApp.version];
        bool isless = [srcApp.version isVersionAscending:tarApp.version];
        if (/*_appConfig.isAppUpgrade == false  && */isGreater == true) {
            NSLog(@"MSG_App_TransInfo_CancelsUpgrade");
            return false;
        }
        
        if (/*_appConfig.isAppDowngrade == false && */isless == true) {
            NSLog(@"MSG_App_TransInfo_CancelsDowngrade");
            return false;
        }
    }
    return true;
}

//安装iPa,iPx到设备
//TODO 1.进度信息没追加
//2.支付iOS版本号与否未判断。
//3.支持iPad,iPhone与否。
- (bool) InstallApplication:(IMBAppTransferTypeEnum)archiveType LocalFilePath:(NSString*)localFilePath {
    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *appName = [localFilePath lastPathComponent];
//    NSString *appKey = @"";

    //ApplicationEntry currAppInfo = null;
    //ApplicationEntry existAppInfo = null;
    //检查应用程序是否允许安装此应用程序，主要是检查App的版本是否被设备版本所支持
    //TODO
    //CheckAppExist(appLocalPath, out currAppInfo, out existAppInfo);
    /*
    if (currAppInfo != null)
    {
        //AppName = currAppInfo.AppName;
        AppKey = currAppInfo.AppKey;
    }
    else
    { AppKey = "unknown"; }
    */
    
    IMBAppEntity *localApp = [self getAppInfoFromLocal:localFilePath];
    IMBAppEntity *deviceApp = nil;
    if (localApp != nil && localApp.appKey != nil) {
         deviceApp = [self getAppByAppKey:localApp.appKey];
    }
    if (archiveType == AppTransferType_DocumentsOnly) {
        if (deviceApp != nil) {
            //第一步
            [self setCurStep:1];
            NSString *unZipRootPath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:deviceApp.appKey];
            if (![fm fileExistsAtPath:unZipRootPath]) {
                [fm createDirectoryAtPath:unZipRootPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //TODO
            [IMBZipHelper unZipByFolder:localFilePath folderPath:@"Container" decFolderPath:unZipRootPath];
            AFCApplicationDirectory *appDir = [_device newAFCApplicationDirectory:deviceApp.appKey];
            if (appDir != nil) {
                [self recursiveCopyFromLocal:[unZipRootPath stringByAppendingPathComponent:@"Container"] ToApp:appDir ToPath:@"/"];
                [appDir close];
                NSLog(@"Copy App doc completely");
            }
            return true;
        }
        NSLog(@"App not exist");
        return false;
    } else {
        bool allowed = [self checkAllowInstall:localApp targetApp:deviceApp];
        if (allowed == false) {
            NSLog(@"Does not allow to install");
            return false;
        }
        if (![_iPod.fileSystem fileExistsAtPath:@"/PublicStaging"]) {
            [_iPod.fileSystem mkDir:@"/PublicStaging"];
        }
        NSString *deviceCachePath = [NSString stringWithFormat:@"/PublicStaging/%@.app", localApp.appName];
        //开始拷贝App
        //第一步
        [self setCurStep:1];
        [_iPod.fileSystem copyLocalFile:localFilePath toRemoteFile:deviceCachePath];
        //安装App
        AMInstallationProxy *instalProxy = [_device newAMInstallationProxyWithDelegate:self];
        //第二步
        [self setCurStep:2];
        BOOL installResult = [instalProxy install:deviceCachePath];
        if (installResult == false) {
            return installResult;
        }
//        if (_appConfig.isAppImportJustData == true) {
            NSString *unZipRootPath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:deviceApp.appKey];
            if (![fm fileExistsAtPath:unZipRootPath]) {
                [fm createDirectoryAtPath:unZipRootPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //TODO
            //第三步
            [self setCurStep:3];
            [IMBZipHelper unZipByFolder:localFilePath folderPath:@"Container" decFolderPath:unZipRootPath];
            AFCApplicationDirectory *appDir = [_device newAFCApplicationDirectory:localApp.appKey];
            if (appDir != nil) {
                [self recursiveCopyFromLocal:[unZipRootPath stringByAppendingPathComponent:@"Container"] ToApp:appDir ToPath:@"/"];
                [appDir close];
                NSLog(@"Copy App doc completely");
            }

//        }
        return true;
    }
    return true;
}

- (bool) InstallApplication:(IMBAppTransferTypeEnum)archiveType appEntity:(IMBAppEntity *)appEntity {
    NSFileManager *fm = [NSFileManager defaultManager];
    //    NSString *appName = [localFilePath lastPathComponent];
    //    NSString *appKey = @"";
    
    //ApplicationEntry currAppInfo = null;
    //ApplicationEntry existAppInfo = null;
    //检查应用程序是否允许安装此应用程序，主要是检查App的版本是否被设备版本所支持
    //TODO
    //CheckAppExist(appLocalPath, out currAppInfo, out existAppInfo);
    /*
     if (currAppInfo != null)
     {
     //AppName = currAppInfo.AppName;
     AppKey = currAppInfo.AppKey;
     }
     else
     { AppKey = "unknown"; }
     */
    
    IMBAppEntity *localApp = appEntity;
    IMBAppEntity *deviceApp = nil;
    NSString *localFilePath = localApp.srcFilePath;
    if (localApp != nil && localApp.appKey != nil) {
        deviceApp = [self getAppByAppKey:localApp.appKey];
    }
    if (archiveType == AppTransferType_DocumentsOnly) {
        if (deviceApp != nil) {
            //第一步
            [self setCurStep:1];
            NSString *unZipRootPath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:deviceApp.appKey];
            if (![fm fileExistsAtPath:unZipRootPath]) {
                [fm createDirectoryAtPath:unZipRootPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //TODO
            [IMBZipHelper unZipByFolder:localFilePath folderPath:@"Container" decFolderPath:unZipRootPath];
            AFCApplicationDirectory *appDir = [_device newAFCApplicationDirectory:deviceApp.appKey];
            if (appDir != nil) {
                [self recursiveCopyFromLocal:[unZipRootPath stringByAppendingPathComponent:@"Container"] ToApp:appDir ToPath:@"/"];
                [appDir close];
                NSLog(@"Copy App doc completely");
            }
            return true;
        }
        NSLog(@"App not exist");
        return false;
    } else {
        bool allowed = [self checkAllowInstall:localApp targetApp:deviceApp];
        if (allowed == false) {
            NSLog(@"Does not allow to install");
            return false;
        }
        if (![_iPod.fileSystem fileExistsAtPath:@"/PublicStaging"]) {
            [_iPod.fileSystem mkDir:@"/PublicStaging"];
        }
        NSString *deviceCachePath = [NSString stringWithFormat:@"/PublicStaging/%@.app", localApp.appName];
        //开始拷贝App
        //第一步
        [self setCurStep:1];
        [_iPod.fileSystem copyLocalFile:localFilePath toRemoteFile:deviceCachePath];
        //安装App
        AMInstallationProxy *instalProxy = [_device newAMInstallationProxyWithDelegate:self];
        //第二步
        [self setCurStep:2];
        BOOL installResult = [instalProxy install:deviceCachePath];
        if (installResult == false) {
            return installResult;
        }
//        if (_appConfig.isAppImportJustData == true) {
            NSString *unZipRootPath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:deviceApp.appKey];
            if (![fm fileExistsAtPath:unZipRootPath]) {
                [fm createDirectoryAtPath:unZipRootPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //TODO
            //第三步
            [self setCurStep:3];
            [IMBZipHelper unZipByFolder:localFilePath folderPath:@"Container" decFolderPath:unZipRootPath];
            AFCApplicationDirectory *appDir = [_device newAFCApplicationDirectory:localApp.appKey];
            if (appDir != nil) {
                [self recursiveCopyFromLocal:[unZipRootPath stringByAppendingPathComponent:@"Container"] ToApp:appDir ToPath:@"/"];
                [appDir close];
                NSLog(@"Copy App doc completely");
            }
            
//        }
        return true;
    }
    return true;
}


- (bool) removeApplication:(IMBAppEntity *)appEntity  {
    AMApplication *app = [_device installedApplicationWithId:appEntity.appKey];
    if (app == nil) {
        NSLog(@"App does not exist!");
        return false;
    }
    AMInstallationProxy *instalProxy = [_device newAMInstallationProxyWithDelegate:self];
    [instalProxy uninstall:appEntity.appKey];
    return true;
    
}

- (IMBAppEntity*) appEntityByAppKey:(NSString*)appKey{
    return nil;
}

- (AFCApplicationDirectory*) appDirectoryByAppKey:(NSString*)appKey{
    return nil;
}

- (AFCApplicationDirectory*) appDirectoryByDevice:(AMDevice*)device AppKey:(NSString*)appKey{
    return nil;
}

//GetAppExist


//1.这里需要得到本地APP的信息
//2.这里需要得到目标设备的App信息

- (IMBAppEntity*) getAppInfoFromLocal:(NSString*)filepath {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath]) {
        IMBAppEntity *appInfo = [[[IMBAppEntity alloc] init] autorelease];
        [appInfo setSrcFilePath:filepath];
        NSString *metaFolderPath = _iPod.session.sessionFolderPath;
        NSString *metaPlistPath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:@"/iTunesMetadata.plist"];
        NSString *infoPlistPath = nil;
        infoPlistPath = [_iPod.session.sessionFolderPath stringByAppendingPathComponent:@"/iTunesMetadata.plist"];
        
        [IMBZipHelper unzipByFile:filepath filePath:@"iTunesMetadata.plist" decFolderPath:metaFolderPath];
        if ([fm fileExistsAtPath:metaPlistPath]) {
            NSDictionary *metaDic = [[NSDictionary alloc] initWithContentsOfFile:metaPlistPath];
            //TODO 这个地方MinOS的版本号读不了。可能通过导入设备来。
            //NSLog(@"metaDic %@", [metaDic description]);
            if (metaDic != nil) {
                if ([metaDic objectForKey:@"softwareVersionBundleId"] != nil) {
                    appInfo.appKey = [metaDic objectForKey:@"softwareVersionBundleId"];
                }
                if ([metaDic objectForKey:@"playlistName"] != nil) {
                    appInfo.appName = [metaDic objectForKey:@"playlistName"];
                } else if ([metaDic objectForKey:@"itemName"]) {
                    appInfo.appName = [metaDic objectForKey:@"itemName"];
                }
                if ([metaDic objectForKey:@"bundleShortVersionString"] != nil) {
                    appInfo.version = [metaDic objectForKey:@"bundleShortVersionString"];
                } else if ([metaDic objectForKey:@"bundleVersion"] != nil) {
                    appInfo.version = [metaDic objectForKey:@"bundleVersion"];
                }
                
            }
        }
        return appInfo;
        
    }
    return nil;
}


- (IMBAppEntity *)getAppInfoAndCopySyncFileToLocal:(NSString*)filepath withAppTempPath:(NSString *)tmpPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    IMBAppEntity *appInfo = nil;
    if ([fm fileExistsAtPath:filepath]) {
        appInfo = [[[IMBAppEntity alloc] init] autorelease];
        [appInfo setSrcFilePath:filepath];
        NSString *metaPlistPath = [tmpPath stringByAppendingPathComponent:@"/iTunesMetadata.plist"];
        NSString *infoPlistPath = nil;
        infoPlistPath = [tmpPath stringByAppendingPathComponent:@"/info.plist"];
        
        NSArray *iconsArray = [IMBZipHelper unZipAppSyncFile:filepath tmpPath:tmpPath passWord:nil];
        if ([fm fileExistsAtPath:metaPlistPath]) {
            NSDictionary *metaDic = [[NSDictionary alloc] initWithContentsOfFile:metaPlistPath];
            //TODO 这个地方MinOS的版本号读不了。可能通过导入设备来。
            //NSLog(@"metaDic %@", [metaDic description]);
            if (metaDic != nil) {
                if ([metaDic objectForKey:@"softwareVersionBundleId"] != nil) {
                    appInfo.appKey = [metaDic objectForKey:@"softwareVersionBundleId"];
                }
                if ([metaDic objectForKey:@"playlistName"] != nil) {
                    appInfo.appName = [metaDic objectForKey:@"playlistName"];
                } else if ([metaDic objectForKey:@"itemName"]) {
                    appInfo.appName = [metaDic objectForKey:@"itemName"];
                } else {
                    appInfo.appName = @"";
                }
                if ([metaDic objectForKey:@"bundleShortVersionString"] != nil) {
                    appInfo.version = [metaDic objectForKey:@"bundleShortVersionString"];
                } else if ([metaDic objectForKey:@"bundleVersion"] != nil) {
                    appInfo.version = [metaDic objectForKey:@"bundleVersion"];
                } else {
                    appInfo.version = @"";
                }
            }
        }
        NSString *infoPath = [tmpPath stringByAppendingPathComponent:@"info.plist"];
        if (![fm fileExistsAtPath:infoPath]) {
            return nil;
        }
        NSArray *iconsList = nil;
        NSDictionary *infoObject = [NSDictionary dictionaryWithContentsOfFile:infoPath];
        BOOL isSupport = false;
        if(infoObject != nil){
            isSupport = [self checkDeviceSupportApp:infoObject];
        }
        if (!isSupport) {
//            NSString *name = [filepath lastPathComponent];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CURRENT_MESSAGE object:[NSString stringWithFormat:CustomLocalizedString(@"MSG_App_Not_Support_The_Device", nil),name]];
            return nil;
        }
        
        if ([infoObject.allKeys containsObject:@"CFBundleIconFiles"]) {
            iconsList = [infoObject objectForKey:@"CFBundleIconFiles"];
        }
        
        if (iconsArray.count > 0 && iconsList.count > 0) {
            for (NSString *item in iconsArray) {
                NSString *name = [item lastPathComponent];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",name];
                NSArray *result = [iconsList filteredArrayUsingPredicate:predicate];
                NSString *iconName = nil;
                if (result.count > 0) {
                    iconName = [result objectAtIndex:0];
                }
                if (iconName == nil) {
                    NSString *iconPath = [tmpPath stringByAppendingPathComponent:name];
                    if ([fm fileExistsAtPath:iconPath]) {
                        [fm removeItemAtPath:iconPath error:nil];
                    }
                }
            }
        }
        
        return appInfo;
        
    }
    return nil;

}

- (BOOL)checkDeviceSupportApp:(NSDictionary *)infoDics{
    NSString *minVersion = @"";
    if ([infoDics.allKeys containsObject:@"MinimumOSVersion"]) {
        minVersion = [infoDics objectForKey:@"MinimumOSVersion"] != nil ? [infoDics objectForKey:@"MinimumOSVersion"] : @"";
    }
    BOOL availableResult = YES;
    if ([infoDics.allKeys containsObject:@"UIDeviceFamily"]) {
        NSArray *deviceFamily = [infoDics objectForKey:@"UIDeviceFamily"];
        NSMutableArray *idList = [NSMutableArray array];
        if (deviceFamily != nil && deviceFamily.count > 0){
            for (NSString* identifier in deviceFamily) {
                [idList addObject:[NSNumber numberWithInt:[identifier intValue]]];
            }
            NSArray *supportDeviceIDList = idList;
            @try {
                availableResult = [self checkAppAvailable:supportDeviceIDList];
            }
            @catch (NSException *exception) {
                availableResult = false;
            }
        }
    }
    
    if (availableResult) {
        BOOL versionResult = false;
        if ([self version:minVersion lessthan:_iPod.deviceInfo.productVersion]) {
            versionResult = YES;
        }
        else{
            versionResult = true;
        }
        return versionResult;
    }
    else{
        return false;
    }
    
}

- (BOOL)version:(NSString *)_oldver lessthan:(NSString *)_newver //系统api
{
    if ([_oldver compare:_newver options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}


- (BOOL)checkAppAvailable:(NSArray *)deviceFamilyList{
    BOOL result = false;
    BOOL supportIPad = false;
    BOOL supportIPod = false;
    if (deviceFamilyList == nil || deviceFamilyList.count == 0) {
        supportIPad = YES;
        supportIPod = YES;
        result = YES;
    }
    else{
        for (NSNumber *number in deviceFamilyList) {
            int i = [number intValue];
            if (i == 1){
                supportIPad = YES;
                supportIPod = YES;
            }
            else if(i == 2){
                supportIPad = YES;
            }
        }
    }
    if ([_iPod.deviceInfo.productType.lowercaseString containsString:@"iphone"] || [_iPod.deviceInfo.productType.lowercaseString containsString:@"ipod"]) {
        result = supportIPod;
    }
    else if([_iPod.deviceInfo.productType.lowercaseString containsString:@"ipad"]){
        result = supportIPad;
    }
    else{
        result = false;
    }
    return result;
}

//GetAppExist

- (NSArray*) getIntalledAppArray {
    if (_device != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [logHandle writeInfoLog:[NSString stringWithFormat:@"get installed app strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        NSArray *apps = [_device installedApplications];
        NSMutableArray *appInfos = nil;
        if (apps != nil && apps.count > 0) {
            appInfos = [[[NSMutableArray alloc] init] autorelease];
            AMSpringboardServices *springBoard = [[_iPod.deviceHandle newAMSpringboardServices] retain];
            // 取出所有的App信息的东西
            AMInstallationProxy *instalProxy = [_iPod.deviceHandle newAMInstallationProxyWithDelegate:self];
            
            NSArray *allAppsInfo = [[instalProxy getAllAppsInfo] retain];
            for (AMApplication *app in apps) {
                [appInfos addObject:[self wrapAppInfo:app allAppsInfo:allAppsInfo withSpringBoard:springBoard]];
            }
            [allAppsInfo release];
            allAppsInfo = nil;
            [springBoard release];
            springBoard = nil;
            [logHandle writeInfoLog:[NSString stringWithFormat:@"get installed app end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
            return appInfos;
        }
        [logHandle writeInfoLog:[NSString stringWithFormat:@"get installed app end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        [dateFormatter release];
        dateFormatter = nil;
    }
    return nil;
}

- (NSArray *)getSystemApplication
{
    if (_device != nil) {
        return [_device getSystemApplications];
    }else{
        return nil;
    }
}


- (IMBAppEntity*) wrapAppInfo:(AMApplication *)amApp allAppsInfo:(NSArray *)allAppsInfo withSpringBoard:(AMSpringboardServices *)springBoard {
    IMBAppEntity *appInfo = [[[IMBAppEntity alloc] init] autorelease];
    appInfo.appKey = amApp.bundleid;
    appInfo.appName = amApp.appname;
    NSDictionary *appInfoDic = amApp.info;
    
    if ([appInfoDic objectForKey:@"MinimumOSVersion"] != nil) {
        appInfo.minimunOSVerison = [NSString stringWithFormat:@"%@",[appInfoDic objectForKey:@"MinimumOSVersion"]];
    }
    
    if ([appInfoDic objectForKey:@"CFBundleShortVersionString"] != nil) {
        appInfo.version = [NSString stringWithFormat:@"%@",[appInfoDic objectForKey:@"CFBundleShortVersionString"] ];
    } else if ([appInfoDic objectForKey:@"CFBundleVersion"] != nil) {
        appInfo.version = [NSString stringWithFormat:@"%@",[appInfoDic objectForKey:@"CFBundleVersion"] ];
    }

    if ([appInfoDic objectForKey:@"DTPlatformName"] != nil) {
        appInfo.dtplatformName = [NSString stringWithFormat:@"%@",[appInfoDic objectForKey:@"DTPlatformName"]];
    }
    
    if ([appInfoDic objectForKey:@"Entitlements"] != nil) {
        NSMutableArray *ary = [[appInfoDic objectForKey:@"Entitlements"] objectForKey:@"com.apple.security.application-groups"];
        if (ary != nil) {
            appInfo.groupArray = ary;
        }
    }
    
    if ([appInfoDic objectForKey:@"UIDeviceFamily"] != nil) {
        NSArray *familyArray = [appInfoDic objectForKey:@"UIDeviceFamily"];
        bool isSptiPhone = [familyArray containsObject:[NSNumber numberWithInt:1]];
        bool isSptiPad = [familyArray containsObject:[NSNumber numberWithInt:2]];
        if (isSptiPhone && isSptiPad) {
            appInfo.uiDeviceFamily = AppUIDeviceFamily_All;
        } else if (isSptiPhone == false &&  isSptiPad == true) {
            appInfo.uiDeviceFamily = AppUIDeivceFamily_iPad;
        } else {
            appInfo.uiDeviceFamily = AppUIDeivceFamily_iPhone;
        }
    }
    
    if (springBoard != nil) {
        NSImage *icoImage = [springBoard getIcon:appInfo.appKey];
        if (icoImage != nil) {
            appInfo.appIconImage = icoImage;
        }
    }
    

    /*NSString *appIconPath = [self getAppIconPath:amApp.bundleid];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:appIconPath]) {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:appIconPath];
        appInfo.appIconImage = image;
        [image release];
    } else {
        appInfo.appIconImage = [StringHelper imageNamed:@"NSApplicationIcon"];

    }*/
    
    NSDictionary *appDic = nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSDictionary *dic = (NSDictionary *)evaluatedObject;
        NSArray *keys = [dic allKeys];
        NSString *appbundle = nil;
        if ([keys containsObject:@"CFBundleIdentifier"]) {
            appbundle = [dic objectForKey:@"CFBundleIdentifier"];
        }
        if ([appInfo.appKey isEqualToString:appbundle]) {
            return YES;
        } else {
            return NO;
        }
    }];
    NSArray *tmpArray = [allAppsInfo filteredArrayUsingPredicate:pre];
    if (tmpArray != nil && tmpArray.count > 0) {
        appDic = [tmpArray objectAtIndex:0];
    }
    
    if (allAppsInfo != nil && allAppsInfo.count > 0) {
        long long appSize = 0;
        long long fileSize = 0;
        if (appInfoDic != nil) {
            NSArray *appAttrKey = [appDic allKeys];
            if (appAttrKey != nil && appAttrKey.count > 0) {
                if ([appAttrKey containsObject:@"StaticDiskUsage"]) {
                    appSize = [[appDic objectForKey:@"StaticDiskUsage"] longLongValue];
                }
                if ([appAttrKey containsObject:@"DynamicDiskUsage"]) {
                    fileSize = [[appDic objectForKey:@"DynamicDiskUsage"] longLongValue];
                    
                }
            }
        }
        appInfo.appSize = appSize;
        appInfo.documentSize = fileSize;
    }
    
    return appInfo;
}

-  (NSString*) getAppIconPath:(NSString*)bundleid {
    //这里需要用appkey来打开链接。
        //得到app的image
    NSString *tmpPath = [_iPod.session sessionFolderPath];
    NSString *appImagePath = [[tmpPath stringByAppendingPathComponent:bundleid] stringByAppendingPathExtension:@"jpg"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:appImagePath]){
        AFCApplicationDirectory *appDir = [_device newAFCApplicationDirectory:bundleid];
        if ([appDir fileExistsAtPath:@"/iTunesArtwork"]) {
            //需要删除一下已经存在的icon
            [appDir copyRemoteFile:@"/iTunesArtwork" toLocalFile:appImagePath];
        }
        [appDir close];
    }
    return appImagePath;
}

- (IMBAppEntity*) getAppByAppKey:(NSString*)appKey {
    if (_device != nil) {
        AMApplication *amApp = [_device installedApplicationWithId:appKey];
        if (amApp != nil) {
            return [self wrapAppInfo:amApp allAppsInfo:nil withSpringBoard:nil];
        }
    }
    return nil;
}
/*
 NSString *_appName;
 NSString *_appStoreID;
 long long _appSize;
 NSImage *_appIconImage;
 //App bundle ID
 NSString *_appKey;
 NSString *_version;
 NSString *_minimunOSVerison;
 //这个地方需要读取平台的版本号吗
 NSString *_dtplatformName;
 //
 NSString *_purchaseDate;
 NSString *_copyright;
*/
    
            


- (void)copyDocBetweenDevice:(IMBAppEntity *)srcApp srcDevice:(AMDevice *)srcDevice {
    AFCApplicationDirectory *tarDir = [_device newAFCApplicationDirectory:srcApp.appKey];
    AFCApplicationDirectory *srcDir = [srcDevice newAFCApplicationDirectory:srcApp.appKey];
    //Todo 这个地方需要删除吗
    if ( tarDir != nil) {
        [tarDir recursiveCopyFile:@"/Library" sourcAFCDir:srcDir toPath:@"/Library"];
        
        [tarDir recursiveCopyFile:@"/Documents" sourcAFCDir:srcDir toPath:@"/Documents"];
        [tarDir recursiveCopyFile:@"/tmp" sourcAFCDir:srcDir toPath:@"/tmp"];
    }
    [srcDir close];
    [tarDir close];
}

/*
 AppTrans[10019:303] App: {
 ApplicationDSID = 1376604222;
 ApplicationType = User;
 BuildMachineOSBuild = 11C74;
 CFBundleDisplayName = "\U73a9\U673a\U5b9d\U5178";
 CFBundleExecutable = helper;
 CFBundleIconFiles =     (
 "Icon.png",
 "Icon@2x.png"
 );
 CFBundleIcons =     {
 CFBundlePrimaryIcon =         {
 CFBundleIconFiles =             (
 "Icon.png",
 "Icon@2x.png"
 );
 UIPrerenderedIcon = 1;
 };
 };
 CFBundleIdentifier = "com.fljt.helper";
 CFBundleInfoDictionaryVersion = "6.0";
 CFBundleName = "\U73a9\U673a\U5b9d\U5178";
 CFBundlePackageType = APPL;
 CFBundleResourceSpecification = "ResourceRules.plist";
 CFBundleShortVersionString = "3.0";
 CFBundleSignature = "????";
 CFBundleSupportedPlatforms =     (
 iPhoneOS
 );
 CFBundleURLTypes =     (
 {
 CFBundleTypeRole = Editor;
 CFBundleURLName = "feiliu.com";
 CFBundleURLSchemes =             (
 fauth
 );
 }
 );
 CFBundleVersion = "3.0";
 Container = "/private/var/mobile/Applications/BABF8006-387E-4420-BD83-9BFE8268AF39";
 DTCompiler = "com.apple.compilers.llvm.clang.1_0";
 DTPlatformBuild = 9A334;
 DTPlatformName = iphoneos;
 DTPlatformVersion = "5.0";
 DTSDKBuild = 9A334;
 DTSDKName = "iphoneos5.0";
 DTXcode = 0420;
 DTXcodeBuild = 4D199;
 Entitlements =     {
 "application-identifier" = "CDXFB7UU57.com.fljt.helper";
 "aps-environment" = production;
 "keychain-access-groups" =         (
 "CDXFB7UU57.com.fljt.helper"
 );
 };
 EnvironmentVariables =     {
 "CFFIXED_USER_HOME" = "/private/var/mobile/Applications/BABF8006-387E-4420-BD83-9BFE8268AF39";
 HOME = "/private/var/mobile/Applications/BABF8006-387E-4420-BD83-9BFE8268AF39";
 TMPDIR = "/private/var/mobile/Applications/BABF8006-387E-4420-BD83-9BFE8268AF39/tmp";
 };
 IsUpgradeable = 1;
 LSRequiresIPhoneOS = 1;
 MinimumOSVersion = "4.0";
 NSMainNibFile = MainWindow;
 Path = "/private/var/mobile/Applications/BABF8006-387E-4420-BD83-9BFE8268AF39/helper.app";
 SequenceNumber = 13;
 SignerIdentity = "Apple iPhone OS Application Signing";
 UIDeviceFamily =     (
 1
 );
 UIPrerenderedIcon = 1;
 UISupportedInterfaceOrientations =     (
 UIInterfaceOrientationPortrait
 );
 }

 */


- (bool)installAppBetweenDevice:(IMBAppTransferTypeEnum)archiveType AppEntity:(IMBAppEntity*)srcApp SrciPod:(IMBiPod*)srciPod {
    AMDevice* srcDevice = [srciPod deviceHandle];
    AMApplication *app = [srcDevice installedApplicationWithId:srcApp.appKey];
    if (app == nil) {
        NSLog(@"App in source does not exist!");
        return false;
    }
    
    IMBAppEntity *tarApp = [self getAppByAppKey:srcApp.appKey];
    if (archiveType == AppTransferType_DocumentsOnly) {
        if (tarApp != nil) {
            //第一步
            [self setCurStep:1];
            [self copyDocBetweenDevice:srcApp srcDevice:srcDevice];
            return true;
        } else {
            NSLog(@"MSG_App_NotExist");
            return false;
        }
    } else {
        //1.先开始安装App
        //1.archive 2.copy zip to path 3.install
        bool allowtoInstall = [self checkAllowInstall:srcApp targetApp:tarApp];
        if (allowtoInstall == false) {
            NSLog(@"does not allow to install");
            return allowtoInstall;
        }
        //先archeive当前的App
        //第一步
        if (![srciPod.fileSystem fileExistsAtPath:@"/ApplicationArchives"]) {
            [_iPod.fileSystem mkDir:@"/ApplicationArchives"];
        }
        [self setCurStep:1];
        AMInstallationProxy *srcInstallProxy = [srcDevice newAMInstallationProxyWithDelegate:self];
        
        //如果存在则删除备份
        NSString *archivedFilePath = [[@"/ApplicationArchives" stringByAppendingPathComponent:srcApp.appKey] stringByAppendingPathExtension:@"zip"];
        if ([srciPod.fileSystem fileExistsAtPath:archivedFilePath]) {
            [srcInstallProxy removeArchive:srcApp.appKey];
        }
        
        _alreadyArchived = FALSE;
        bool archiveSucced = [srcInstallProxy archive:srcApp.appKey container:NO payload:YES uninstall:NO];
        if (archiveSucced == false && _alreadyArchived == FALSE) {
            NSLog(@"archive failed");
            return false;
        }
        //第二步 拷贝
        [self setCurStep:2];
        if (![_iPod.fileSystem fileExistsAtPath:@"/PublicStaging"]) {
            [_iPod.fileSystem mkDir:@"/PublicStaging"];
        }
        NSString *deviceCachePath = [NSString stringWithFormat:@"/PublicStaging/%@.app", srcApp.appKey];
        if ([_iPod.fileSystem fileExistsAtPath:deviceCachePath]) {
            [_iPod.fileSystem unlink:deviceCachePath];
        }
        if ([srciPod.fileSystem fileExistsAtPath:archivedFilePath]) {
            [_iPod.fileSystem copyFileBetweenDevice:archivedFilePath sourDriverLetter:srciPod.fileSystem.driveLetter targFileName:deviceCachePath targDriverLetter:_iPod.fileSystem.driveLetter sourDevice:srciPod];
            [srcInstallProxy removeArchive:srcApp.appKey];
            NSLog(@"APP:%@ copyed.", srcApp.appName );
            if ([_iPod.fileSystem fileExistsAtPath:deviceCachePath]) {
                //第三步 安装
                [self setCurStep:3];
                AMInstallationProxy *tarInstallProxy = [_device newAMInstallationProxyWithDelegate:self];
                bool installed = [tarInstallProxy install:deviceCachePath];
                if ([_iPod.fileSystem fileExistsAtPath:deviceCachePath]) {
                    [_iPod.fileSystem unlink:deviceCachePath];
                }
                if (installed == false) {
                    NSLog(@"APP:%@ install failed.", srcApp.appName );
                    return false;
                }
            } else {
                NSLog(@"APP:%@ copy failed.", srcApp.appName );
                return false;
            }
            
//            if (_appConfig.isAppImportJustData ) {
                //第三步 导入Doc
                [self setCurStep:4];
                [self copyDocBetweenDevice:srcApp srcDevice:srcDevice];
                NSLog(@"File copied.");
//            }
        }
        //2.如果是All的话，就拷贝文档
    }
    return true;
    //如果是只是document的导入的话，两边都存在的话，直接导入，不存在的话 就failed
}


// A new current operation is beginning.
-(void)operationStarted:(NSDictionary*)info {
    //App的操作开始了
    /*
     2013-07-03 18:55:17.396 iMobieTrans[14267:303] Archive start: {
     ApplicationIdentifier = "Herofox.JP300Free";
     ClientOptions =     {
     ArchiveType = All;
     SkipUninstall = 1;
     };
     Command = Archive;
     }
    */
    //如果是Archive的话，做Archive的相关操作
    //[nc postNotificationName:NOTIFY_CURRENT_MESSAGE object: [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Analyzing_File_With_Name",nil),track.title] userInfo:nil];
    /*
    NSString *appKey = [info objectForKey:@"ApplicationIdentifier"];
    AMApplication *app = [_device installedApplicationWithId:appKey];
    NSString *appName = @"";
    if (app != nil) {
        appName = app.appname;
    }
    NSString *commandStr = [info objectForKey:@"Command"];
    [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object: [NSString stringWithFormat:@"Start to %@ App %@", [commandStr lowercaseString], appName ] userInfo:nil];
    */
    if (_listener && [_listener respondsToSelector:@selector(operationStarted:)]) {
        [_listener operationStarted:info];
    }
    
}

/// The current operation is continuing.
-(void)operationContinues:(NSDictionary*)info {
    if ([info objectForKey:@"Error"] != nil) {
        NSString *error = [NSString stringWithFormat:@"%@",[info objectForKey:@"Error"]]; ;
        if ([@"AlreadyArchived" isEqualToString:error]) {
            _alreadyArchived = true;
        }
        
    }
    
    //App的操作完成
    /*
    2013-07-03 18:55:17.410 iMobieTrans[14267:303] Archive reply: {
        PercentComplete = 0;
        Status = TakingInstallLock;
    }
    2013-07-03 18:55:17.413 iMobieTrans[14267:303] Archive reply: {
        PercentComplete = 2;
        Status = EmptyingApplication;
    }
    */
    /*
    NSString *status = [info objectForKey:@"Status"];
    int percentComplete = [(NSNumber*)[info objectForKey:@"PercentComplete"] intValue];
    //TODO这里不知道操作的类型 如install，UNinstall等
    [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:status userInfo:nil];
        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithLong:0], @"TotalTime",
                                   [NSNumber numberWithDouble:0], @"SpendTime",
                                   [NSNumber numberWithInt:percentComplete], @"CurProgress",
                                   [NSNumber numberWithInt:percentComplete], @"TotalProgress"
                                   , nil];
    [nc postNotificationName:NOTIFY_TRANSFILEPROGRESS object:nil userInfo:params];
    */
    if (_listener && [_listener respondsToSelector:@selector(operationContinues:)]) {
        [_listener operationContinues:info];
    }
}

-(void)setCurStep:(int)curStep{
    //App的操作完成
    if (_listener && [_listener respondsToSelector:@selector(setCurStep:)]) {
        [_listener setCurStep:curStep];
    }
    
}

/// The current operation finished (one way or the other)
-(void)operationCompleted:(NSDictionary*)info {
    //App的操作开始了
    //[nc postNotificationName:NOTIFY_TRANSFILEPROGRESS object:nil userInfo:params];
    if (_listener && [_listener respondsToSelector:@selector(operationCompleted:)]) {
        [_listener operationCompleted:info];
    }
}
//luolei add
- (SimpleNode *)getAPPDocument:(AFCApplicationDirectory *)directMediaAccess path:(NSString *)path fileName:(NSString *)fileName
{

    SimpleNode *node = [[[SimpleNode alloc] initWithName:fileName] autorelease];
    NSArray *appDocuArray = [directMediaAccess directoryContents:path];
    for (int i=0; i<[appDocuArray count]; i++) {
        SimpleNode *childNode = nil;
        NSString *fileName = [appDocuArray objectAtIndex:i];
        NSString *filePath = nil;
        if ([path isEqualToString:@"/"]) {
            
            filePath = [NSString stringWithFormat:@"%@%@",path,fileName];
        }else{
            filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
        }
        
        NSArray *childrenArr = [directMediaAccess directoryContents:filePath];
        if (childrenArr != nil) {
            childNode = [self getAPPDocument:directMediaAccess path:filePath fileName:fileName];
            childNode.container = YES;
            childNode.path = filePath;
            NSImage *appleImage = [[NSWorkspace sharedWorkspace] iconForFile:[TempHelper getAppSupportPath]];
            [appleImage setSize:NSMakeSize(64, 64)];
//            NSImage *image = [StringHelper imageNamed:@"folder_new"];
//            [image setSize:NSMakeSize(66, 52)];
            childNode.image = appleImage;
            [node.childrenArray addObject:childNode];
        }else
        {
            childNode = [[SimpleNode alloc] initWithName:fileName];
            childNode.path = filePath;
            childNode.container = NO;
            [node.childrenArray addObject:childNode];
            NSString *extension = [childNode.path pathExtension];
            NSWorkspace *workSpace = [[NSWorkspace alloc] init];
            NSImage *icon = [workSpace iconForFileType:extension];
            [icon setSize:NSMakeSize(56, 52)];
            childNode.image = icon;
            [childNode release];
        }
    }
    return node;
}

- (void)exploreAPPDocumentToMac:(NSString *)desPath node:(NSArray *)nodeArr  affApplicationDirectory:(AFCApplicationDirectory *)afcmediaDir
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
//    [nc postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//    [nc postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Export_id_1", nil) userInfo:nil];
    
    int successNum = 0;
    for (int i=0;i<[nodeArr count];i++) {
        
        SimpleNode *node = [nodeArr objectAtIndex:i];
//        int currItemIndex = i+1;
//        BOOL IsNeedAnimation = YES;
//        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     node.fileName,@"Message",
//                                     [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                     [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                     [NSNumber numberWithInteger:[nodeArr count]], @"TotalItemCount",
//                                     nil];
        
//        [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
//        [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:node.fileName];
        
        NSString *dedestinationPath = [NSString stringWithFormat:@"%@/%@",desPath,node.fileName];
        if ([fm fileExistsAtPath:dedestinationPath]) {
            
            dedestinationPath = [NSString stringWithFormat:@"%@/%@",desPath,[StringHelper createDifferentfileName:node.fileName]];
        }
        if (node.container) {
            
            [fm createDirectoryAtPath:dedestinationPath withIntermediateDirectories:NO attributes:nil error:nil];
            [self copyAppDocumentToMac:dedestinationPath node:node.childrenArray  affApplicationDirectory:afcmediaDir];
            successNum++;
        }else
        {
           if ([afcmediaDir fileExistsAtPath:node.path]) {
                
                [afcmediaDir copyRemoteFile:node.path toLocalFile:dedestinationPath];
               successNum++;
            }
        }
       

    }
    
//    NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:successNum] ,@"successNum",[NSNumber numberWithInt:AppResultTypeIcon],@"transferType",nil];
//    [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
}

- (void)copyAppDocumentToMac:(NSString *)desPath node:(NSArray *)nodeArr  affApplicationDirectory:(AFCApplicationDirectory *)afcmediaDir
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    for (int i=0;i<[nodeArr count];i++) {
        
        SimpleNode *node = [nodeArr objectAtIndex:i];
        NSString *dedestinationPath = [NSString stringWithFormat:@"%@/%@",desPath,node.fileName];
        if ([fm fileExistsAtPath:dedestinationPath]) {
            
            dedestinationPath = [NSString stringWithFormat:@"%@/%@",desPath,[StringHelper createDifferentfileName:node.fileName]];
        }
        if (node.container) {
            
            [fm createDirectoryAtPath:dedestinationPath withIntermediateDirectories:NO attributes:nil error:nil];
            [self copyAppDocumentToMac:dedestinationPath node:node.childrenArray  affApplicationDirectory:afcmediaDir];
            
        }else
        {
            
            if ([afcmediaDir fileExistsAtPath:node.path]) {
                
                [afcmediaDir copyRemoteFile:node.path toLocalFile:dedestinationPath];
                
            }
        }
    }
}

- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path  appBundle:(NSString *)appBundle
{
    AFCApplicationDirectory *afcAppmd = [_iPod.deviceHandle newAFCApplicationDirectory:appBundle];
    NSArray *nodeArray = [self getFirstContent:path afcMedia:afcAppmd];
    [afcAppmd close];
    return nodeArray;
}

- (NSArray *)getFirstContent:(NSString *)path afcMedia:(AFCApplicationDirectory *)afcAppmd
{
    NSMutableArray *nodeArray = [NSMutableArray array];
    NSArray *array = [afcAppmd directoryContents:path];
    for (NSString *fileName in array) {
        NSString *filePath = nil;
        if ([path isEqualToString:@"/"]) {
            filePath = [NSString stringWithFormat:@"/%@",fileName];
        }else {
            filePath = [path stringByAppendingPathComponent:fileName];
        }
        
        SimpleNode *node = [[SimpleNode alloc] initWithName:fileName];
        node.path = filePath;
        node.parentPath = path;
        NSDictionary *fileDic = [afcAppmd getFileInfo:filePath];
        NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
        if ([fileType isEqualToString:@"S_IFDIR"]) {
            
            node.container = YES;
            OSType code = UTGetOSTypeFromString((CFStringRef)@"fldr");
            NSImage *picture = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(code)];
            [picture setSize:NSMakeSize(66, 58)];
            node.image = picture;
        }else
        {
            
            node.container = NO;
            NSString *extension = [node.path pathExtension];
            NSWorkspace *workSpace = [[NSWorkspace alloc] init];
            NSImage *icon = [workSpace iconForFileType:extension];
            [icon setSize:NSMakeSize(56, 52)];
            node.image = icon;
            [workSpace release];
        }
        [nodeArray addObject:node];
        [node release];
    }
    
    return nodeArray;
}

- (void)exploreAPPDocumentToMac:(NSString *)FolderPath withNodeArray:(NSArray *)nodeArray fileManger:(NSFileManager *)fileManger afcMedia:(AFCApplicationDirectory *)afcMedia
{
    _threadBreak = NO;
    int successNum = 0;
    int currItemIndex = 0;
    fileCount = 0;
//    int totalCount = [self caculateTotalFileCount:nodeArray afcMedia:afcMedia];
    BOOL isOutOfCount = NO;//[IMBHelper determinWhetherIsOutOfTransferCount];
    if (!isOutOfCount) {
//        [nc postNotificationName:PARSINGNOTIFICATION object:[NSNumber numberWithInt:PCImage]];
//        [nc postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//        [nc postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Export_id_1", nil) userInfo:nil];
        for (int i=0;i<[nodeArray count];i++) {
            if (_threadBreak == YES) {
                break;
            }
            SimpleNode *node = [nodeArray objectAtIndex:i];
            
            
            NSString *destinationPath = [FolderPath stringByAppendingPathComponent:node.fileName];
            if ([fileManger fileExistsAtPath:destinationPath]) {
                
                destinationPath = [FolderPath stringByAppendingPathComponent:[StringHelper createDifferentfileName:node.fileName]];
                
            }
            if (node.container) {
                
                [fileManger createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
                NSArray *arr = [self getFirstContent:node.path afcMedia:afcMedia];
                [self copyAPPDocumentToMac:destinationPath withNodeArray:arr fileManger:fileManger afcMedia:afcMedia currentIndex:&currItemIndex successCount:&successNum];
            }else
            {
                
                if ([afcMedia fileExistsAtPath:node.path]) {
//                    currItemIndex++;
//                    BOOL IsNeedAnimation = YES;
//                    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                 node.fileName,@"Message",
//                                                 [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                                 [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                                 [NSNumber numberWithInt:totalCount], @"TotalItemCount",
//                                                 nil];
                    
//                    [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
//                    
//                    [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:node.fileName];
                    
                    BOOL success = [afcMedia copyRemoteFile:node.path toLocalFile:destinationPath];
                    if (success) {
                        successNum++;
                        [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
                        [_transResult recordMediaResult:node.fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
                        _progressCounter.prepareAnalysisSuccessCount++;
                        //传输限制
//                        BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                        if (isOutOfCount) {
//                            break;
//                        }
                    }else
                    {
                        [_transResult setMediaFaildCount:([_transResult mediaFaildCount] + 1)];
                        [_transResult recordMediaResult:node.fileName resultStatus:TransFailed messageID:@"MenuItem_id_58"];
                        continue;
                    }
                }
                

            }
            
        }

        
    }
//    if (_softWareInfo != nil && _softWareInfo.isNeedRegister&&_softWareInfo.isRegistered == false) {
//        [_softWareInfo addLimitCount:_transResult.mediaSuccessCount];
//    }

    sleep(2);
//    NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:successNum],@"successNum",[NSNumber numberWithInt:AppResultTypeIcon],@"transferType",nil];
//    [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
    _threadBreak = NO;

}

- (void)copyAPPDocumentToMac:(NSString *)FolderPath withNodeArray:(NSArray *)nodeArray fileManger:(NSFileManager *)fileManger afcMedia:(AFCApplicationDirectory *)afcMedia currentIndex:(int *)currentIndex successCount:(int *)successCount
{
    
    for (int i=0;i<[nodeArray count];i++) {
        
        SimpleNode *node = [nodeArray objectAtIndex:i];
        
        NSString *destinationPath = [FolderPath stringByAppendingPathComponent:node.fileName];
        if ([fileManger fileExistsAtPath:destinationPath]) {
            
            destinationPath = [FolderPath stringByAppendingPathComponent:[StringHelper createDifferentfileName:node.fileName]];
            
        }
        if (node.container) {
            
            [fileManger createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSArray *arr = [self getFirstContent:node.path afcMedia:afcMedia];
            [self copyAPPDocumentToMac:destinationPath withNodeArray:arr fileManger:fileManger afcMedia:afcMedia currentIndex:currentIndex successCount:successCount];
        }else
        {
            if ([afcMedia fileExistsAtPath:node.path]) {
                
                (*currentIndex)++;
//                BOOL IsNeedAnimation = YES;
//                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                             node.fileName,@"Message",
//                                             [NSNumber numberWithInt:*currentIndex], @"CurItemIndex",
//                                             [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                             [NSNumber numberWithInt:fileCount], @"TotalItemCount",
//                                             nil];
//                
//                [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
//                
//                [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:node.fileName];
                
                BOOL success = [afcMedia copyRemoteFile:node.path toLocalFile:destinationPath];
                if (success) {
                    (*successCount)++;
                    [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
                    [_transResult recordMediaResult:node.fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
                    _progressCounter.prepareAnalysisSuccessCount++;
                    //传输限制
//                    BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                    if (isOutOfCount) {
//                        break;
//                    }
                }else
                {
                    [_transResult setMediaFaildCount:([_transResult mediaFaildCount] + 1)];
                    [_transResult recordMediaResult:node.fileName resultStatus:TransFailed messageID:@"MenuItem_id_58"];
                    continue;
                }

            }
            
        }
    }
}
    
- (int)caculateTotalFileCount:(NSArray *)nodeArray afcMedia:(AFCApplicationDirectory *)afcMedia
    {
        
        for (SimpleNode *node in nodeArray) {
            
            if (!node.container) {
                fileCount++;
            }else
            {
                NSArray *arr = [self getFirstContent:node.path afcMedia:afcMedia];
                [self caculateTotalFileCount:arr afcMedia:afcMedia];
            }
            
        }
        return fileCount;
    }


@end
