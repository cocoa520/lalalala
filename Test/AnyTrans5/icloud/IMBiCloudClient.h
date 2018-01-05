//
//  IMBiCloud.h
//  iCloudDemo
//
//  Created by Pallas on 6/25/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBLogManager.h"
#import "IMBBaseEntity.h"
@class IMBKeyValuePair;

typedef enum FileTypeMode {
    UnknownType = 'unty',
    SymbolicLink = 'slnk',
    RegularFile = 'file',
    RegularDirectory = 'dire'
} FileTypeModeEnum;

typedef enum DownloadError {
    DownloadExpiredError = 1,
    DownloadNetworkError = 2,
    DownloadOtherError = 3,
} DownloadErrorEnum;

@interface IMBiCloudLoginInfo : NSObject {
@private
    NSString *_appleID;
    NSString *_password;
    NSString *_dsPrsID;
    NSString *_mmeAuth;
    NSString *_pNum;
    BOOL _loginStatus;
    NSMutableArray *_backupList;
}

@property (nonatomic, readwrite, retain) NSString *appleID;
@property (nonatomic, readwrite, retain) NSString *password;
@property (nonatomic, readwrite, retain) NSString *dsPrsID;
@property (nonatomic, readwrite, retain) NSString *mmeAuth;
@property (nonatomic, readwrite, retain) NSString *pNum;
@property (nonatomic, readwrite) BOOL loginStatus;
@property (nonatomic, readwrite, retain) NSMutableArray *backupList;

@end
@class DeviceBackup;
@interface IMBiCloudBackup : NSObject {
@private
    NSString *_relativePath;
    NSString *_deviceName;
    NSString *_serialNumber;
    NSString *_uuid;
    NSString *_shortProductType;
    NSString *_productType;
    NSString *_model;
    NSString *_build;
    NSString *_iCloudAccount;
    NSString *_deviceType;
    NSString *_deviceColor;
    NSString *_iOSVersion;
    NSString *_lastTime;
    int64_t _lastModified;
    int64_t _incrSize;
    int64_t _backupSize;
    int _snapshotID;
    NSMutableArray *_keyBagArray;
    BOOL _hasKeyBag;
    NSMutableArray *_fileArray;
    BOOL _hasFiles;
    NSMutableArray *_fileInfoArray;
    BOOL _hasFilesInfo;
    BOOL _isDownload;
    BOOL _isDownloadSucess;
    BOOL _isDownloadFailed;
    NSString *_downloadFolderPath;
    BOOL _checkState;
    DeviceBackup *_deviceBackup;
    NSString *_iosProductTye;
    int _downCount;
}
@property (nonatomic, retain) NSString *relativePath;
@property (nonatomic, assign) int downCount;
@property (nonatomic, readwrite, retain) NSString *iosProductTye;
@property (nonatomic, assign) BOOL checkState;
@property (nonatomic, retain) DeviceBackup *deviceBackup;
@property (nonatomic, readwrite, retain) NSString *deviceName;
@property (nonatomic, retain) NSString *lastTime;;
@property (nonatomic, readwrite, retain) NSString *serialNumber;
@property (nonatomic, readwrite, retain) NSString *uuid;
@property (nonatomic, readwrite, retain) NSString *shortProductType;
@property (nonatomic, readwrite, retain) NSString *productType;
@property (nonatomic, readwrite, retain) NSString *model;
@property (nonatomic, readwrite, retain) NSString *build;
@property (nonatomic, readwrite, retain) NSString *iCloudAccount;
@property (nonatomic, readwrite, retain) NSString *deviceType;
@property (nonatomic, readwrite, retain) NSString *deviceColor;
@property (nonatomic, readwrite, retain) NSString *iOSVersion;
@property (nonatomic, readwrite) int64_t lastModified;
@property (nonatomic, readwrite) int64_t incrSize;
@property (nonatomic, readwrite) long long backupSize;
@property (nonatomic, readwrite) int snapshotID;
@property (nonatomic, readwrite, retain) NSMutableArray *keyBagArray;
@property (nonatomic, readwrite) BOOL hasKeyBag;
@property (nonatomic, readwrite, retain) NSMutableArray *fileArray;
@property (nonatomic, readwrite) BOOL hasFiles;
@property (nonatomic, readwrite, retain) NSMutableArray *fileInfoArray;
@property (nonatomic, readwrite) BOOL hasFilesInfo;
@property (nonatomic, readwrite) BOOL isDownload;
@property (nonatomic, readwrite) BOOL isDownloadSucess;
@property (nonatomic, readwrite) BOOL isDownloadFailed;
@property (nonatomic, readwrite, retain) NSString *downloadFolderPath;
@end

@interface IMBiCloudFileInfo : NSObject {
@private
    NSString *_fileName;
    NSString *_domain;
    NSString *_path;
    FileTypeModeEnum _fileTypeMode;
    int64_t _fileSize;
    int64_t _createDate;
    int64_t _lastModifyDate;
}

@property (nonatomic, readwrite, retain) NSString *fileName;
@property (nonatomic, readwrite, retain) NSString *domain;
@property (nonatomic, readwrite, retain) NSString *path;
@property (nonatomic, readwrite) FileTypeModeEnum fileTypeMode;
@property (nonatomic, readwrite) int64_t fileSize;
@property (nonatomic, readwrite) int64_t createDate;
@property (nonatomic, readwrite) int64_t lastModifyDate;

@end

@interface IMBiCloudClient : NSObject {
@private
    NSMutableDictionary *_filesDic;
    IMBiCloudLoginInfo *_loginInfo;
    NSMutableArray *_keybagList;
    NSNotificationCenter *nc;
    NSFileManager *fm;
    NSString *_cacheFolder;
    long _cacheFileName;
    
    IMBLogManager *_logManager;

}

@property (nonatomic, readwrite, retain) IMBiCloudLoginInfo *loginInfo;
@property (nonatomic, readwrite, retain) NSMutableArray *keybagList;

- (BOOL)iCloudLoginWithAppleID:(NSString*)appleID withPassword:(NSString*)password;
- (NSMutableArray*)getBackupList;
- (BOOL)checkLoginStatus;
// YES为有效，NO为无效
- (BOOL)checkInternetAvailble;
+ (void)getNoLoginBackupFiles:(IMBiCloudBackup *)backup;
- (NSMutableArray*)getBackupFiles:(IMBiCloudBackup*)backup;
- (BOOL)downloadBackup:(IMBiCloudBackup*)backup withFilter:(NSDictionary*)filter withOutputPath:(NSString*)outputPath;

@end

@interface IMBKeyValuePair : NSObject {
@private
    id _key;
    id _value;
}

@property(nonatomic, readwrite, retain) id key;
@property(nonatomic, readwrite, retain) id value;

- (id)initWithKey:(id)k withValue:(id)v;

@end
