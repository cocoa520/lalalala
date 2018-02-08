//
//  GeneralUtility.h
//  InstallAntivirus
//
//  Created by Pallas on 6/24/15.
//  Copyright (c) 2015 Pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/NSRunningApplication.h>

//#ifndef ELCAPITAN
//#ifdef __x86_64__
//typedef struct {
//    int64_t majorVersion;
//    int64_t minorVersion;
//    int64_t patchVersion;
//} IMBOperatingSystemVersion;
//#else
//typedef struct {
//    int32_t majorVersion;
//    int32_t minorVersion;
//    int32_t patchVersion;
//} IMBOperatingSystemVersion;
//#endif
//#endif

#define Even(x) (x) - ((x) % 2)

typedef enum {
    MaciMac,
    MacMini,
    MacBook,
    MacBookAir,
    MacBookPro,
    MacPro
} DeviceModel;

typedef enum SearchOption {
    TopDirectoryOnly = 0,
    AllDirectories = 1,
} SearchOptionEnum;

@interface NSProcessInfo (MenuMetersWorkarounds)
//- (BOOL)isOperatingSystemAtLeastVersion:(IMBOperatingSystemVersion)version;
@end

// OS version info

@interface GeneralUtility : NSObject

+ (NSString *)osVersion;
+ (NSString *)platform;
+ (int)platformFlag;
+ (BOOL)OSIsJaguarOrLater;
+ (BOOL)OSIsPantherOrLater;
+ (BOOL)OSIsTigerOrLater;
+ (BOOL)OSIsLeopardOrLater;
+ (BOOL)OSIsSnowLeopardOrLater;
+ (BOOL)OSIsLionOrLater;
+ (BOOL)OSIsMountainLionOrLater;
+ (BOOL)OSIsMavericksOrLater;
+ (DeviceModel)deviceModal;
+ (NSString*)getPlatformSerialNumber;
+ (NSDictionary*)getCpuIds;
+ (NSString*)getHardwareUUID;
+ (NSString*)getHardwareSerialNumber;
+ (uint64_t)totalDiskSpaceInBytes;
+ (uint64_t)freeDiskSpaceInBytes;
+ (uint64_t)usedDiskSpaceInBytes;
+ (uint64_t)physicalMemoryInBytes;
//+ (char*)getSystemVersion;    // 10.8及以后才能使用
+ (float)backingFactor;

+ (NSString*)convertCstringToString:(char*)cString;
+ (char*)convertStringToCstring:(NSString*)string;

+ (BOOL)appIsRunningAtPath:(NSString*)path;
+ (NSRunningApplication*)runningAppAtPath:(NSString*)path;
+ (BOOL)appIsRunningWithBundleIdentifier:(NSString*)bundleIdentifier;
+ (BOOL)runningApplicationTerminateIdentifier:(NSString*)bundleIdentifier;
+ (BOOL)isExsitAppWithIdentifier:(NSString*)identifier;
+ (NSString*)appAbsolutePathWithIdentifier:(NSString*)identifier;

// 常用浏览器的配置存储路径
+ (NSString*)firefoxDefaultPath;
+ (NSString*)chromeDefaultPath;
+ (NSString*)operaDefaultPath;

//将NSImage *转换为CGImageRef
+ (CGImageRef)nsimageToCGImageRef:(NSImage*)image;
+ (NSImage*)rotateImage:(NSImage*)sourceImage byDegrees:(float)degegrees;
+ (NSImage*)rotateImage:(NSImage*)sourceImage;
+ (void)rotateImage:(NSImage *)image roate:(float)roate rect:(NSRect)rect;
+ (NSImage*)iconForFile:(NSString *)path maxSize:(int)size;

+ (NSDictionary*)allAttributesOfFile:(NSString*)path;
+ (NSDictionary*)commonAttributesOfFile:(NSString*)path;
+ (NSDictionary*)specialAttributesOfFile:(NSString*)path;
+ (NSString*)itemKindForFile:(NSString*)string withAppTempPath:(NSString*)appTempPath;
+ (NSMutableArray*)allFilesAtPath:(NSString*)dirPath withSearchOption:(SearchOptionEnum)searchOption;
+ (BOOL)setAttributeForPath:(NSString*)path withName:(CFStringRef)name withValue:(CFTypeRef)value;
+ (BOOL)fileHasWritePermission:(NSString *)path;
+ (uint64_t)sizeOfFileWithPath:(NSString *)path;
+ (uint64_t)countOfFileWithPath:(NSString*)path;
+ (uint64_t)countOfItemNotContainSubItemWithPath:(NSString*)path;
+ (NSArray*)getSizeAndUnitFor1024:(uint64_t)size withReserved:(uint)reserved;
+ (NSArray*)getSizeAndUnitFor1024:(uint64_t)size;
+ (NSArray*)getSizeAndUnitFor1000:(uint64_t)size withReserved:(uint)reserved;
+ (NSArray*)getSizeAndUnitFor1000:(uint64_t)size;

+ (NSMutableArray *)pathWithDomainKey:(NSSearchPathDirectory)dic inDomain:(NSSearchPathDomainMask)domain;
+ (NSString *)userHomePath;
+ (NSString *)tempPath;
+ (NSString *)userDeskTopPath;
+ (NSString *)applicationPath;
+ (NSString *)applicationUtilityPath;
+ (NSString *)userLibrary;
+ (NSString *)userApplicationSupportPath;
+ (NSString *)userApplicationPath;
+ (NSString *)userTrashPath;
+ (NSString *)userMoviePath;
+ (NSString *)userMusicPath;
+ (NSString *)userPicturePath;
+ (NSString *)userDownlodsPath;
+ (NSString *)userDocumentPath;
+ (NSString *)userPreferencesPath;
+ (NSString *)appDockIconPlistPath;

+ (BOOL)suPermission:(NSString *)tips;
+ (BOOL)changePermissionForPath:(NSString*)path withUser:(NSString*)permission withGroup:(NSString*)permission withOther:(NSString*)permission;
+ (BOOL)removeFileForcely:(NSString *)path;
+ (BOOL)moveFileForcelyFrom:(NSString *)srcPath toPath:(NSString *)toPath withTips:(NSString*)tips;
+ (BOOL)moveFileToTrashFrom:(NSString *)srcPath;
+ (BOOL)mkdirWithAuth:(NSString*)path withTips:(NSString*)tips;
+ (BOOL)removeItemWithAuth:(NSString*)path withTips:(NSString*)tips;
+ (BOOL)unparkWithAuth:(NSString*)package withType:(NSString*)type withToFolder:(NSString*)toFolder withTips:(NSString*)tips;

+ (BOOL)shutdownSystem;
+ (BOOL)restartSystem;
+ (BOOL)startFinder;
+ (BOOL)killFinder;
+ (BOOL)clearRecentApplications;
+ (BOOL)clearRecentDocuments;
+ (BOOL)clearRecentServers;
+ (BOOL)clearDNSCachesWithAuth:(NSString*)authWord;
+ (BOOL)rebuildSpotlightIndexWithAuth:(NSString*)authWord;
+ (BOOL)repairDiskPermissionsWithAuth:(NSString*)authWord;
+ (BOOL)verifyStartupDiskWithAuth:(NSString*)authWord;
+ (BOOL)rebuildLaunchServicesDatabaseWithAuth:(NSString *)authWord;
+ (BOOL)speedUpMail;

+ (NSData*)bigInteger:(int)numBits;
+ (NSString*)generateUUID;

@end
