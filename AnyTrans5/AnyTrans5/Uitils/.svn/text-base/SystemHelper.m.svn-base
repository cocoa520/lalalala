//
//  SystemHelper.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "SystemHelper.h"
#import "NSString+Category.h"
#import "IMBLogManager.h"
#import "IMBHelper.h"
#import "IMBSoftWareInfo.h"
#import "IMBSocketClient.h"
#include <objc/runtime.h>
#import "IMBChooseBrowserWindowController.h"
#import "TempHelper.h"
#import "ATTracker.h"

@implementation SystemHelper
+ (NSString *)userHomePath{
    NSString *path = NSHomeDirectoryForUser(NSUserName()); //NSSearchPathForDirectoriesInDomains(, NSUserDomainMask, YES);
    return path;
}

+ (NSString *)userDeskTopPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)applicationPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSSystemDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userApplicationPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)applicationUtilityPath{
    NSString *format = @"%@/Utilities";
    return [NSString stringWithFormat:format,[self applicationPath]];
}

+ (NSString *)userLibrary {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userApplicationSupportPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *baseDir = (paths.count > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userMoviePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userMusicPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userPicturePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userDownlodsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return baseDir;
}

+ (NSString *)userPreferencesPath {
    NSString *baseDir = [NSString stringWithFormat:@"%@/Preferences", [self userLibrary]];
    return baseDir;
}

+ (NSString *)appDockIconPlistPath{
    NSString *format = @"%@/Library/Preferences/com.apple.dock.plist";
    return [NSString stringWithFormat:format,[self userHomePath]];
}

+ (uint64_t)getDiskFreeSizeByPath:(NSString *)path {
    NSDictionary * fsattrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:nil];
    uint64_t diskFreeSize = [[fsattrs objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    return diskFreeSize;
}

+ (uint64_t)getDiskTotalSizeByPath:(NSString *)path {
    NSDictionary * fsattrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:nil];
    uint64_t diskTotalSize = [[fsattrs objectForKey:NSFileSystemSize] unsignedLongLongValue];
    return diskTotalSize;
}

+(NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints {
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@" %.0f%@", (double)totalSize,CustomLocalizedString(@"MSG_Size_B", nil)];
    } else {
        if (mbSize > 1024) {
            double gbSize = (double)totalSize / 1073741824;
            return [self Rounding:gbSize reserved:1 capacityUnit:CustomLocalizedString(@"MSG_Size_GB", nil)];
        } else if (kbSize > 1024) {
            return [self Rounding:mbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_MB", nil)];
        } else {
            return [self Rounding:kbSize reserved:decimalPoints capacityUnit:CustomLocalizedString(@"MSG_Size_KB", nil)];
        }
    }
}

+(NSString*)Rounding:(double)numberSize reserved:(int)decimalPoints capacityUnit:(NSString*)unit {
    switch (decimalPoints) {
        case 1:
            return [NSString stringWithFormat:@" %.1f %@", numberSize, unit];
            break;
            
        case 2:
            return [NSString stringWithFormat:@" %.2f %@", numberSize, unit];
            break;
            
        case 3:
            return [NSString stringWithFormat:@" %.3f %@", numberSize, unit];
            break;
            
        case 4:
            return [NSString stringWithFormat:@" %.4f %@", numberSize, unit];
            break;
            
        default:
            return [NSString stringWithFormat:@" %.2f %@", numberSize, unit];
            break;
    }
}

+ (BOOL)isImageFile:(NSString *)filePath{
    @autoreleasepool {
        NSArray *array = [NSArray arrayWithObjects:@"jpeg",@"jpg",@"png",@"gif",nil];
        NSString*fileExtention = [filePath pathExtension].lowercaseString;
        if ([array containsObject:fileExtention]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isVideoFile:(NSString*)filePath {
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"m4v" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"mp4" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"mov" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"wmv" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    return NO;
}

+ (NSString*)getRandomFileName:(int)length {
    char charArr[length + 1];
    srandom((unsigned int)time((time_t *)NULL));
    for (int i = 0; i < length; i++) {
        long num = random();
        charArr[i] = (int)num % 52;
        if (charArr[i] < 26) {
            charArr[i] += (91 - 26);
        } else {
            charArr[i] += (123 - 52);
        }
    }
    charArr[length] ='\0';
    return [NSString stringWithCString:charArr encoding:NSUTF8StringEncoding];
}

+ (unsigned long long )folderOrfileSize:(NSString *)filePath {
    unsigned long long  folderSize = 0;
    NSDictionary *atti = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSString *fileType = [atti objectForKey:NSFileType];
    if (fileType == NSFileTypeDirectory) {
        
        NSArray *contents = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:filePath error:nil];
        NSEnumerator *contentsEnumurator = [contents objectEnumerator];
        NSString *file;
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[filePath stringByAppendingPathComponent:file] error:nil];
            folderSize += [[fileAttributes objectForKey:NSFileSize] longLongValue];
        }
    }else
    {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath  error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] longLongValue];
    }
    return folderSize;
}

+ (NSString*)getSystemLastNumberString {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *systemVersion = processInfo.operatingSystemVersionString;
    NSArray *array = [systemVersion componentsSeparatedByString:@"."];
    NSString *lastStr = @"0";
    if (array.count >= 2) {
        lastStr = [array objectAtIndex:1];
    }
    return lastStr;
}

+ (BOOL)runningApplicationTerminateIdentifier:(NSString*)bundleIdentifier {
    BOOL retVal = NO;
    if (bundleIdentifier.length == 0 || bundleIdentifier == NULL) {
        return retVal;
    }
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.bundleIdentifier == %@", bundleIdentifier];
        NSArray *tmpArray = [arr filteredArrayUsingPredicate:pre];
        NSRunningApplication *runningApp = nil;
        if (tmpArray != nil && tmpArray.count > 0) {
            runningApp = [tmpArray objectAtIndex:0];
        } else {
            retVal = TRUE;
        }
        if (runningApp != nil) {
            retVal = [runningApp terminate];
        }
    }
    return retVal;
}

+ (BOOL)appIsRunningWithBundleIdentifier:(NSString*)bundleIdentifier {
    BOOL appIsRunning = NO;
    if (bundleIdentifier.length == 0 || bundleIdentifier == NULL) {
        return appIsRunning;
    }
    @autoreleasepool {
        NSArray *arr = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication *app in arr) {
            if ([[app bundleIdentifier] isEqualToString:bundleIdentifier]) {
                appIsRunning = YES;
                break;
            }
        }
    }
    return appIsRunning;
}

+ (void)createLaunchDaemon {
    if ([IMBSoftWareInfo singleton].isStartUpAirBackup) {
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL airBackupMasterSwitch = YES;
        NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
        if ([fm fileExistsAtPath:configPath]) {
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:configPath];
            if (dic != nil) {
                if ([dic.allKeys containsObject:@"AirBackupMasterSwitch"]) {
                    airBackupMasterSwitch = [[dic objectForKey:@"AirBackupMasterSwitch"] boolValue];
                }
            }
            [dic release];
        }else {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSNumber numberWithBool:airBackupMasterSwitch] forKey:@"AirBackupMasterSwitch"];
            [dic writeToFile:configPath atomically:YES];
            [dic release];
        }
        if (airBackupMasterSwitch) {
            [self startLaunchDaemon];
        }
    }
}

+ (void)startLaunchDaemon {
    NSFileManager *fm = [NSFileManager defaultManager];
    IMBLogManager *logmanager = [IMBLogManager singleton];
    NSString *plistName = @"com.imobie.airbackuphelper";
    NSString *appPath = [[[IMBHelper getAppSupportPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"AirBackupHelper.app"];
    NSString *plistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/LaunchAgents"] stringByAppendingPathComponent:[plistName stringByAppendingPathExtension:@"plist"]];
    //判断是否更新AirBackupHelper.app
    if ([self isUpdateAirBackupHelper]) {
        [logmanager writeInfoLog:@"Update AirBackupHelper.app"];
        //停止守护进程
        BOOL ret = [self stopLaunchDaemon];
        if ([fm fileExistsAtPath:appPath] && ret) {
            [fm removeItemAtPath:appPath error:nil];
        }
        
        NSString *updatePath = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"updateAirBackupHelper.plist"];
        [logmanager writeInfoLog:[NSString stringWithFormat:@"updatePath:%@",updatePath]];
        NSDictionary *softInfoDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"AirBackupHelper"];
        if ([fm fileExistsAtPath:updatePath]) {
            [fm removeItemAtPath:updatePath error:nil];
        }
        [softInfoDic writeToFile:updatePath atomically:YES];
    }
    
    //拷贝守护进程到指定目录下
    if (![fm fileExistsAtPath:appPath]) {
        [logmanager writeInfoLog:[NSString stringWithFormat:@"prepare copy deamon app:%@",appPath]];
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *deamonPath = [[[bundle executablePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"AirBackupHelper.app"];
        [logmanager writeInfoLog:[NSString stringWithFormat:@"copy deamon app:%@",deamonPath]];
        if ([fm fileExistsAtPath:deamonPath]) {
            [logmanager writeInfoLog:[NSString stringWithFormat:@"copying deamon app to:%@",appPath]];
            [fm copyItemAtPath:deamonPath toPath:appPath error:nil];
        }
    }
    
    //创建指定的plist文件并写入指定目录下
    if (![fm fileExistsAtPath:plistPath] && [fm fileExistsAtPath:appPath]) {
        [self createAirBackupHelperPlistFile];
    }else {
        if ([fm fileExistsAtPath:appPath]) {
            [self openAppNotOpen:appPath];
        }
    }
    
    //发送选择的语言
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *str = [array objectAtIndex:0];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"changelanguage" object:nil userInfo:@{@"language":str}];
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"at current language:%@",str]];
}

//获得是否更新AirBackupHelper.app
+ (BOOL)isUpdateAirBackupHelper {
    BOOL isUpdate = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *updatePath = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"updateAirBackupHelper.plist"];
    NSDictionary *softInfoDic = nil;
    if ([fm fileExistsAtPath:updatePath]) {
        softInfoDic = [NSDictionary dictionaryWithContentsOfFile:updatePath];
    }else {
        softInfoDic = [[NSBundle mainBundle] infoDictionary];
    }
    if (softInfoDic != nil) {
        NSArray *allKey = softInfoDic.allKeys;
        if (allKey != nil && allKey.count > 0) {
            if (([allKey containsObject:@"AirBackupHelper"])) {
                isUpdate = [[softInfoDic objectForKey:@"AirBackupHelper"] boolValue];
            }
        }
    }
    return isUpdate;
}

//创建指定的plist文件并写入指定目录下
+ (BOOL)createAirBackupHelperPlistFile {
    BOOL success = NO;
    IMBLogManager *logmanager = [IMBLogManager singleton];
    [logmanager writeInfoLog:@"create AirBackupHelper plist"];
    NSString *appPath = [[[IMBHelper getAppSupportPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"AirBackupHelper.app"];
    NSString *plistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/LaunchAgents"] stringByAppendingPathComponent:@"com.imobie.airbackuphelper.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:plistPath] && [fm fileExistsAtPath:appPath]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"KeepAlive"];
        [dic setObject:@"com.imobie.airbackuphelper" forKey:@"Label"];
        NSString *programPath = [appPath stringByAppendingPathComponent:@"Contents/MacOS/AirBackupHelper"];
        [dic setObject:programPath forKey:@"Program"];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"RunAtLoad"];
        success = [dic writeToFile:plistPath atomically:YES];
        //release
        [dic release];
        if (success) {
            //执行命令行操作
            if ([fm fileExistsAtPath:appPath]) {
                [self executeCommandFunction];
            }
        }else {
            if ([fm fileExistsAtPath:plistPath]) {
                [fm removeItemAtPath:plistPath error:nil];
            }
        }
    }
    return success;
}

/*
 sudo chown root  /Library/LaunchDaemons/com.dynamsoft.WebTwainService.plist
 sudo launchctl
 load -D system /Library/LaunchDaemons/com.dynamsoft.WebTwainService.plist
 */
//注册服务
+ (void)executeCommandFunction {
    IMBLogManager *logmanager = [IMBLogManager singleton];
    [logmanager writeInfoLog:@"execute Command Function"];
//    char *cmd1 = "sudo chown root ~/Library/LaunchAgents/com.imobie.airbackuphelper.plist";
//    system(cmd1);
//    char *cmd2 = "sudo launchctl";
//    system(cmd2);
    char *cmd3 = "launchctl load -D system ~/Library/LaunchAgents/com.imobie.airbackuphelper.plist";
    system(cmd3);
}

//打开守护进程app
+ (void)openAppNotOpen:(NSString *)appPath {
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    NSArray *appArray = [workSpace runningApplications];
    BOOL isOpen = NO;
    for (NSRunningApplication *runApp in appArray) {
        NSString *appName = runApp.localizedName;
        if ([appName isEqualToString:@"AirBackupHelper"]) {
            [[IMBLogManager singleton] writeInfoLog:@"AirBackupHelper is Open"];
            isOpen = YES;
            break;
        }
    }
    if (!isOpen) {
        NSString *path = [@"open " stringByAppendingString:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/'Application Support'/com.imobie.AnyTrans/AirBackupHelper.app"]];
        const char *cmd = path.UTF8String;
        
        NSLog(@"%s",cmd);
        system(cmd);
    }
}

//停止守护进程
+ (BOOL)stopLaunchDaemon {
    BOOL ret = YES;
    IMBLogManager *logmanager = [IMBLogManager singleton];
    [logmanager writeInfoLog:@"stop AirBackupHelper"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/LaunchAgents"] stringByAppendingPathComponent:@"com.imobie.airbackuphelper.plist"];
    
    //卸载服务
    char *cmd = "launchctl unload ~/Library/LaunchAgents/com.imobie.airbackuphelper.plist";
    int i = system(cmd);
    NSLog(@"i=%d",i);
    
    //删除plist文件
    if ([fm fileExistsAtPath:plistPath]) {
        ret = [fm removeItemAtPath:plistPath error:nil];
    }
    //停止守护进程
    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    NSArray *appArray = [workSpace runningApplications];
    for (NSRunningApplication *runApp in appArray) {
        NSString *appName = runApp.localizedName;
        if ([appName isEqualToString:@"AirBackupHelper"]) {
            [logmanager writeInfoLog:@"Close AirBackupHelper"];
            ret = [runApp forceTerminate];
            break;
        }
    }
    return ret;
}

+ (void)openChooseBrowser:(int)buyId withIsActivate:(BOOL)isActivate isDiscount:(BOOL)isDiscount isNeedAnalytics:(BOOL)isNeed {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    NSArray *userApplicationsDirs = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSLocalDomainMask, YES);
    NSMutableArray *aryM = [[NSMutableArray alloc] init] ;
    NSString *identifer = nil;
    if ([userApplicationsDirs count] > 0) {
        NSString *userApplicationsDir = [userApplicationsDirs objectAtIndex:0];
        if ([fm fileExistsAtPath:userApplicationsDir isDirectory:&isDirectory] && isDirectory) {
            NSArray *contents = [fm contentsOfDirectoryAtPath:userApplicationsDir error:NULL];
            for (NSString *contentsPath in contents) {
                if ([[contentsPath pathExtension] isEqualToString:@"app"]) {
                    if ([contentsPath.lowercaseString contains:@"google"] && ![aryM containsObject:@"google"]) {
                        [aryM addObject:@"google"];
                        identifer = @"com.google.Chrome";
                    }else if ([contentsPath.lowercaseString contains:@"safari"] && ![aryM containsObject:@"safari"]) {
                        [aryM addObject:@"safari"];
                        identifer = @"com.apple.Safari";
                    }else if ([contentsPath.lowercaseString contains:@"firefox"] && ![aryM containsObject:@"firefox"]) {
                        [aryM addObject:@"firefox"];
                        identifer = @"org.mozilla.firefox";
                    }else if ([contentsPath.lowercaseString contains:@"opera"] && ![aryM containsObject:@"opera"]) {
                        [aryM addObject:@"opera"];
                        identifer = @"com.operasoftware.Opera";
                    }
                }
            }
        }
    }
    
    /*
    
    //判断安装了几个浏览器，如果只安装了一个就直接打开，不需要出现选择浏览器窗口
    NSMutableArray *aryM = [[NSMutableArray alloc] init];
    //@"com.apple.Safari",@"com.google.Chrome",@"org.mozilla.firefox",@"com.operasoftware.Opera",@"com.tencent.QQBrowser"
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *allApplications = [workspace performSelector:@selector(allApplications)];
    NSLog(@"2222222222222");
    NSString *identifer = nil;
    for (NSString *app in allApplications) {
        NSString *appStr = [NSString stringWithFormat:@"%@",app];//转换成字符串
        if ([appStr contains:@"com.google.Chrome"] && ![aryM containsObject:@"google"]) {
            [aryM addObject:@"google"];
            identifer = @"com.google.Chrome";
        }else if ([appStr contains:@"com.apple.Safari"] && ![aryM containsObject:@"safari"]) {
            [aryM addObject:@"safari"];
            identifer = @"com.apple.Safari";
        }else if ([appStr contains:@"org.mozilla.firefox"] && ![aryM containsObject:@"firefox"]) {
            [aryM addObject:@"firefox"];
            identifer = @"org.mozilla.firefox";
        }else if ([appStr contains:@"com.operasoftware.Opera"] && ![aryM containsObject:@"opera"]) {
            [aryM addObject:@"opera"];
            identifer = @"com.operasoftware.Opera";
        }
    }
    NSLog(@"333333333333");
     */
    if (aryM.count < 2) {
        if (isNeed) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:@"default" label:ChooseBrowser transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        }
        IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
        NSURL *url = nil;
        NSString *str = CustomLocalizedString(@"Buy_Url", nil);
        if (isDiscount) {
            str = CustomLocalizedString(@"discount_Buy_Url", nil);
        }
        NSString *ver = softWare.version;
        if (softWare.isIronsrc) {
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                ver = @"ironsrc3";
            }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage){
                ver = @"ironsrc1";
            }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
                ver = @"ironsrc2";
            }else if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage){
                ver = @"ironsrc";
            }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage){
                ver = @"ironsrc4";
            }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage){
                ver = @"ironsrc5";
            }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                ver = @"ironsrc6";
            }else {
                ver = @"ironsrc";
            }
        }
        if (isDiscount) {
            url = [NSURL URLWithString:[NSString stringWithFormat:str, ver]];
        }else {
            url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, buyId]];
        }
        BOOL success = NO;
        if (identifer) {
            NSArray *ary = @[url];
            success =  [[NSWorkspace sharedWorkspace] openURLs: ary withAppBundleIdentifier:identifer
                                                       options: NSWorkspaceLaunchDefault additionalEventParamDescriptor: NULL launchIdentifiers: NULL];
        }
        if (!success) {
            [[NSWorkspace sharedWorkspace] openURL:url];
        }
    }else {
        IMBChooseBrowserWindowController *chooseWindow = [[IMBChooseBrowserWindowController alloc]initWithWindowNibName:@"IMBChooseBrowserWindowController" withIsNeedAnalytics:isNeed];
        NSWindow *mainWindow = [NSApp mainWindow];
        NSRect rect = mainWindow.frame;
        NSPoint point = mainWindow.frame.origin;
        float height = chooseWindow.window.frame.size.height;
        float width = chooseWindow.window.frame.size.width;
        [chooseWindow.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
        [chooseWindow setInstallBrowsers:aryM];
        [chooseWindow setIsActive:isActivate];
        [chooseWindow setIsDisCountBuy:isDiscount];
        [NSApp runModalForWindow:[chooseWindow window]];
    }
    [aryM release];
    NSLog(@"44444444444");
}

@end
