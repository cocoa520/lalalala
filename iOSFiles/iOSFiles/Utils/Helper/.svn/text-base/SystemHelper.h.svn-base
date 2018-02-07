//
//  SystemHelper.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemHelper : NSObject
+ (NSString *)userHomePath;
+ (NSString *)userDeskTopPath;
+ (NSString *)applicationPath;
+ (NSString *)applicationUtilityPath;
+ (NSString *)userLibrary;
+ (NSString *)userApplicationSupportPath;
+ (NSString *)userApplicationPath;
+ (NSString *)userMoviePath;
+ (NSString *)userMusicPath;
+ (NSString *)userPicturePath;
+ (NSString *)userDownlodsPath;
+ (NSString *)userDocumentPath;
+ (NSString *)userPreferencesPath;
+ (NSString *)appDockIconPlistPath;
//大小
+ (uint64_t)getDiskFreeSizeByPath:(NSString *)path;
+ (uint64_t)getDiskTotalSizeByPath:(NSString *)path;
+(NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints;

+ (BOOL)isImageFile:(NSString *)filePath;
+ (BOOL)isVideoFile:(NSString*)filePath;
+ (NSString*)getRandomFileName:(int)length;
+ (unsigned long long )folderOrfileSize:(NSString *)filePath;
+ (NSString*)getSystemLastNumberString;//获取系统版本.以后的字符串
+ (BOOL)runningApplicationTerminateIdentifier:(NSString*)bundleIdentifier;
+ (BOOL)appIsRunningWithBundleIdentifier:(NSString*)bundleIdentifier;

+ (void)createLaunchDaemon;
+ (void)startLaunchDaemon;
+ (BOOL)createAirBackupHelperPlistFile;
+ (BOOL)stopLaunchDaemon;
@end
