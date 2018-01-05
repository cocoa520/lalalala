//
//  IMBiCloud.m
//  iCloudDemo
//
//  Created by Pallas on 6/25/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import "IMBiCloudClient.h"
#import "IMBMBDBParse.h"
#import "IMBHttpWebResponseUtility.h"
#import "IMBKeybag.h"
//#import "CommonType.h"
#import "IMBAES_256_CBC.h"
#import "IMBAES_CFB.h"
#import "NSData+EncryptDecrypt.h"
#import "RegexKitLite.h"
#import "Protocol.h"
#import "NSString+Category.h"
#import "TempHelper.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
//#import "NSString+ContainsString.h"
//#import "IMBHelper.h"
//#import "NSString+AESCrypt.h"
//#import "IMBCommonDefine.h"

@implementation IMBiCloudLoginInfo
@synthesize appleID = _appleID;
@synthesize password = _password;
@synthesize dsPrsID = _dsPrsID;
@synthesize mmeAuth = _mmeAuth;
@synthesize pNum = _pNum;
@synthesize loginStatus = _loginStatus;
@synthesize backupList = _backupList;


- (id)init {
    self = [super init];
    if (self) {
        _appleID = @"";
        _password = @"";
        _dsPrsID = @"";
        _mmeAuth = @"";
        _pNum = @"";
        _loginStatus = NO;
        _backupList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_backupList != nil) {
        [_backupList release];
        _backupList = nil;
    }
    [super dealloc];
}

@end

@implementation IMBiCloudBackup
@synthesize relativePath = _relativePath;
@synthesize downCount = _downCount;
@synthesize checkState = _checkState;
@synthesize deviceName = _deviceName;
@synthesize serialNumber = _serialNumber;
@synthesize uuid = _uuid;
@synthesize shortProductType = _shortProductType;
@synthesize productType = _productType;
@synthesize model = _model;
@synthesize build = _build;
@synthesize iCloudAccount = _iCloudAccount;
@synthesize deviceType = _deviceType;
@synthesize deviceColor = _deviceColor;
@synthesize iOSVersion = _iOSVersion;
@synthesize lastModified = _lastModified;
@synthesize incrSize = _incrSize;
@synthesize backupSize = _backupSize;
@synthesize snapshotID = _snapshotID;
@synthesize keyBagArray = _keyBagArray;
@synthesize hasKeyBag = _hasKeyBag;
@synthesize fileArray = _fileArray;
@synthesize hasFiles = _hasFiles;
@synthesize fileInfoArray = _fileInfoArray;
@synthesize hasFilesInfo = _hasFilesInfo;
@synthesize isDownload = _isDownload;
@synthesize downloadFolderPath = _downloadFolderPath;
@synthesize isDownloadSucess = _isDownloadSucess;
@synthesize isDownloadFailed = _isDownloadFailed;
@synthesize lastTime = _lastTime;
@synthesize deviceBackup = _deviceBackup;
@synthesize iosProductTye = _iosProductTye;
- (id)init {
    self = [super init];
    if (self) {
        _deviceName = @"";
        _serialNumber = @"";
        _uuid = @"";
        _shortProductType = @"";
        _productType = @"";
        _model = @"";
        _build = @"";
        _iCloudAccount = @"";
        _deviceType = @"";
        _deviceColor = @"";
        _iOSVersion = @"";
        _lastModified = 0;
        _incrSize = 0;
        _backupSize = 0;
        _snapshotID = 0;
        _keyBagArray = [[NSMutableArray alloc] init];
        _hasKeyBag = NO;
        _fileArray = [[NSMutableArray alloc] init];
        _hasFiles = NO;
        _fileInfoArray = nil;
        _hasFilesInfo = NO;
        _downloadFolderPath = @"";
        _checkState = UnChecked;
    }
    return self;
}

- (void)dealloc {
    if (_keyBagArray != nil) {
        [_keyBagArray release];
        _keyBagArray = nil;
    }
    if (_fileArray != nil) {
        [_fileArray release];
        _fileArray = nil;
    }
    [super dealloc];
}

@end

@implementation IMBiCloudFileInfo
@synthesize fileName = _fileName;
@synthesize domain = _domain;
@synthesize path = _path;
@synthesize fileTypeMode = _fileTypeMode;
@synthesize fileSize = _fileSize;
@synthesize createDate = _createDate;
@synthesize lastModifyDate = _lastModifyDate;

- (id)init {
    self = [super init];
    if (self) {
        _fileName = @"";
        _domain = @"";
        _path = @"";
        _fileSize = 0;
        _createDate = 0;
        _lastModifyDate = 0;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

@interface IMBiCloudClient ()

@property (nonatomic, readwrite, retain) NSString *cacheFolder;
@property (nonatomic, readwrite, assign) long cacheFileName;

@end

@implementation IMBiCloudClient
@synthesize loginInfo = _loginInfo;
@synthesize keybagList = _keybagList;
@synthesize cacheFolder = _cacheFolder;
@synthesize cacheFileName = _cacheFileName;
- (id)init {
    self = [super init];
    if (self) {
        //        _filesDic = [[NSMutableDictionary alloc] init];
        _loginInfo = [[IMBiCloudLoginInfo alloc] init];
        _keybagList = [[NSMutableArray alloc] init];
        nc = [NSNotificationCenter defaultCenter];
        fm = [NSFileManager defaultManager];
        _logManager = [IMBLogManager singleton];
        
        NSString *tmpCacheFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:@"iCloudCache"];
        if (![fm fileExistsAtPath:tmpCacheFolder]) {
            [fm createDirectoryAtPath:tmpCacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self setCacheFolder:tmpCacheFolder];
        self.cacheFileName = 1;;
    }
    return self;
}

- (void)dealloc {
    if (_filesDic != nil) {
        [_filesDic release];
        _filesDic = nil;
    }
    if (_loginInfo != nil) {
        [_loginInfo release];
        _loginInfo = nil;
    }
    if (_keybagList != nil) {
        [_keybagList release];
        _keybagList = nil;
    }
    [super dealloc];
}

- (BOOL)iCloudLoginWithAppleID:(NSString*)appleID withPassword:(NSString*)password {
    BOOL retVal = NO;
    NSString *plist = [self authenticate:appleID withPassword:password];
    if (![self stringIsNilOrEmpty:plist]) {
        retVal = [self parseAuthenticate:plist];
        if (retVal) {
            NSString *infoPlist = [self getAccountInfo:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth];
            retVal = [self parseAccountInfo:infoPlist];
            if (retVal) {
                [self.loginInfo setAppleID:appleID];
                [self.loginInfo setPassword:password];
                [self.loginInfo setLoginStatus:YES];
            } else {
                [self.loginInfo setLoginStatus:NO];
            }
        }
    }
    return retVal;
}

- (NSMutableArray*)getBackupList {
    [_logManager writeInfoLog:@"get backup list"];
    //    NSString *licenseStr = [self.loginInfo.appleID AES256EncryptWithKey:@"123456789"];
    //    [_logManager writeInfoLog:[NSString stringWithFormat:@"kb data:++%@==",licenseStr]];
    //    NSString *licenseStr = @"xNhC9Z1Hm0bBJhsbMA5unl3zwMDLthGXH5xPF+HIy9M=";
    //    NSLog(@"%@",[licenseStr AES256DecryptWithKey:@"123456789"]);
    [self.loginInfo.backupList removeAllObjects];
    NSData *udidsData = [self listDevices:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"udidsData:%@",udidsData]];
    //    licenseStr = [self.loginInfo.password AES256EncryptWithKey:@"123456789"];
    //    [_logManager writeInfoLog:[NSString stringWithFormat:@"kbup data:--%@==",licenseStr]];
    //    licenseStr = @"l0oAp4qF/Zjs4xlqI3MbKw==";
    //    NSLog(@"%@",[licenseStr AES256DecryptWithKey:@"123456789"]);
    
    if (udidsData != nil) {
        DeviceUdidsL *uuids = nil;
        @try {
            uuids = [DeviceUdidsL parseFromData:udidsData];
        }
        @catch (NSException *exception) {
            [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(DeviceUdids):%@",exception.reason]];
        }
        for (int u = 0; u < uuids.udidsList.count; u++) {
            NSData *uuidData = [uuids udidsAtIndex:u];
            NSString *uuid = [NSString stringToHex:(uint8_t *)(uuidData.bytes) length:(int)uuidData.length];
            NSData *snapshotInfo = [self getInfo:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth withBackupUDID:uuid];
            DeviceL *dev = nil;
            @try {
                dev = [DeviceL parseFromData:snapshotInfo];
            }
            @catch (NSException *exception) {
                [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(DeviceEx):%@",exception.reason]];
            }
            for (int b = 0; b < dev.backupList.count; b++) {
                BackupL *bItem  = [dev backupAtIndex:b];
                IMBiCloudBackup *backup = [[IMBiCloudBackup alloc] init];
                [backup setDeviceName:bItem.info.name];
                [backup setSerialNumber:dev.device.serialNumber];
                [backup setUuid:uuid];
                [backup setShortProductType:dev.device.deviceClass];
                [backup setProductType:dev.device.productType];
                [backup setModel:dev.device.hardwareModel];
                [backup setBuild:bItem.info.buildEx];
                [backup setICloudAccount:self.loginInfo.appleID];
                [backup setDeviceColor:dev.device.deviceClass];
                [backup setDeviceType:dev.device.marketingName];
                [backup setIOSVersion:bItem.info.firmware];
                [backup setLastModified:bItem.lastModified];
                [backup setIncrSize:bItem.size];
                [backup setSnapshotID:bItem.snapshotId];
                NSData *keysData = [self getKeys:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth withBackupUDID:backup.uuid];
                KeysL *keys = nil;
                @try {
                    keys = [KeysL parseFromData:keysData];
                }
                @catch (NSException *exception) {
                    [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(Keys):%@",exception.reason]];
                }
                NSData *passcode = nil;
                if (keys.keySetList != nil && keys.keySetList.count > 0) {
                    KeyL *key = [keys keySetAtIndex:0];
                    for (int kbi = 1; kbi < keys.keySetList.count; kbi++) {
                        KeyL *keyBag = [keys keySetAtIndex:kbi];
                        IMBKeybag *keybag = [[IMBKeybag alloc] initWithKeybagData: keyBag.data];
                        [backup.keyBagArray addObject:keybag];
                    }
                    passcode = key.data;
                } else {
                    [backup.keyBagArray removeAllObjects];
                    [backup setHasKeyBag:NO];
                }
                
                if (passcode.length == 0) {
                    [backup.keyBagArray removeAllObjects];
                    [backup setHasKeyBag:NO];
                } else {
                    for (IMBKeybag *kb in backup.keyBagArray) {
                        if (![kb unlockBackupKeybagWithPasscodeData:passcode]) {
                            [backup.keyBagArray removeAllObjects];
                            break;
                        }
                    }
                    if (backup.keyBagArray.count > 0) {
                        [backup setHasKeyBag:YES];
                    }
                }
                
                [self.loginInfo.backupList addObject:backup];
                [self getBackupFiles:backup];
                [backup release];
                backup = nil;
            }
        }
    }
    [_logManager writeInfoLog:@"get backup list END"];
    if (self.loginInfo.backupList != nil && self.loginInfo.backupList.count > 0) {
        return self.loginInfo.backupList;
    } else {
        return nil;
    }
}

- (BOOL)checkLoginStatus {
    BOOL retVal = NO;
    BOOL internetAvailble = [TempHelper checkInternetAvailble];
    if (internetAvailble) {
        @try {
            NSData *udidsData = [self listDevices:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth];
            if (udidsData != nil && udidsData.length > 0) {
                retVal = YES;
            }
        }
        @catch (NSException *exception) {
            
        }
        if (!retVal) {
            retVal = [self iCloudLoginWithAppleID:self.loginInfo.appleID withPassword:self.loginInfo.password];
        }
    }
    return retVal;
}

- (BOOL)checkInternetAvailble {
    BOOL internetAvailble = [TempHelper checkInternetAvailble];
    return internetAvailble;
}

+ (void)getNoLoginBackupFiles:(IMBiCloudBackup *)backup {
    NSMutableArray *tmpfiles = nil;
    NSMutableDictionary *filesMap = [[NSMutableDictionary alloc] init];
    for (int snapshotId = 1; snapshotId < backup.snapshotID + 1; snapshotId ++) {
        NSString *outputPath = [TempHelper getiCloudLocalPath];
        outputPath = [outputPath stringByAppendingPathComponent:backup.iCloudAccount];
        NSString *downloadPath = [outputPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d",backup.uuid,snapshotId]];
        NSString *fileDataPath = [downloadPath stringByAppendingPathComponent:@"fileData.plist"];
        NSData *fileListData = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileDataPath]) {
            NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileDataPath];
            if ([fileDic.allKeys containsObject:@"fileListData"]) {
                fileListData = [[fileDic objectForKey:@"fileListData"] retain];
            }
            [fileDic release];
        }
        
        if (fileListData != nil && fileListData.length > 0) {
            tmpfiles = [self parseNoLoginFiles:fileListData withFilter:nil];
            [backup.fileArray addObjectsFromArray:tmpfiles];
            [backup setHasFiles:YES];
            [fileListData release];
        }
        
        for (FileL *f in tmpfiles) {
            NSString *fileName = [NSString stringToHex:(uint8_t*)(f.fileName.bytes) length:(int)f.fileName.length];
            IMBiCloudFileInfo *icloudFile = [[IMBiCloudFileInfo alloc] init];
            [icloudFile setFileName:fileName];
            [icloudFile setDomain:f.domain];
            [icloudFile setPath:f.path];
            ushort mode = f.info.mode;
            if ((mode & 0xf000) == MASK_SYMBOLIC_LINK) {
                [icloudFile setFileTypeMode:SymbolicLink];
            } else if ((mode & 0xf000) == MASK_REGULAR_FILE) {
                [icloudFile setFileTypeMode:RegularFile];
            } else if ((mode & 0xf000) == MASK_DIRECTORY) {
                [icloudFile setFileTypeMode:RegularDirectory];
            } else {
                [icloudFile setFileTypeMode:UnknownType];
            }
            [icloudFile setFileSize:f.fileSize];
            [icloudFile setCreateDate:f.info.ctime];
            [icloudFile setLastModifyDate:f.info.mtime];
            [filesMap setObject:icloudFile forKey:fileName];
            [icloudFile release];
            icloudFile = nil;
        }
    }
    
    NSMutableArray *files = nil;
    if (filesMap.count > 0) {
        files = [NSMutableArray arrayWithArray:filesMap.allValues];
        if (files != nil && files.count > 0) {
            [backup setFileInfoArray:files];
            [backup setHasFilesInfo:YES];
        }
    }
    
    [filesMap release];
    filesMap = nil;
}

- (NSMutableArray*)getBackupFiles:(IMBiCloudBackup*)backup {
    if (backup.hasFilesInfo) {
        return backup.fileInfoArray;
    }
    NSMutableArray *files = nil;
    if (![self checkLoginStatus]) {
        //@"Login Expired" 登录过期错误
        //too doo
        //        [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadExpiredError] userInfo:nil];
        return files;
    }
    
    NSMutableDictionary *filesMap = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *snapInfoDic = [[NSMutableDictionary alloc] init];
    for (IMBiCloudBackup *backupItem in self.loginInfo.backupList) {
        if ([backupItem.uuid isEqualToString:backup.uuid]) {
            [snapInfoDic setObject:backupItem forKey:[NSNumber numberWithInt:backupItem.snapshotID]];
        }
    }
    NSArray *allSnapKey = snapInfoDic.allKeys;
    if (allSnapKey != nil && allSnapKey.count > 0) {
        for (int snapshotID = 1; snapshotID < backup.snapshotID + 1; snapshotID++) {
            if (![allSnapKey containsObject:[NSNumber numberWithInt:snapshotID]]) {
                continue;
            }
            if (![self checkInternetAvailble]) {
                //@"networkDisconnect" 网络连接错误
                //toodoo
                [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadNetworkError] userInfo:nil];
                break;
            }
            
            IMBiCloudBackup *currBackup = [snapInfoDic objectForKey:[NSNumber numberWithInt:snapshotID]];
            NSMutableArray *tmpfiles = nil;
            if (!currBackup.hasFiles) {
                NSString *outputPath = [TempHelper getiCloudLocalPath];
                outputPath = [outputPath stringByAppendingPathComponent:currBackup.iCloudAccount];
                if (![fm fileExistsAtPath:outputPath]) {
                    [fm createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSString *downloadPath = [outputPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d",backup.uuid,backup.snapshotID]];
                if (![fm fileExistsAtPath:downloadPath]) {
                    [fm createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                
                NSString *fileDataPath = [downloadPath stringByAppendingPathComponent:@"fileData.plist"];
                NSData *fileListData = nil;
                if ([fm fileExistsAtPath:fileDataPath]) {
                    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileDataPath];
                    if ([fileDic.allKeys containsObject:@"fileListData"]) {
                        fileListData = [[fileDic objectForKey:@"fileListData"] retain];
                    }
                    [fileDic release];
                }else {
                    fileListData = [[self listFiles:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth withBackupUDID:backup.uuid withSnapshotID:snapshotID withOffset:0 withLimit:(pow(2, 16) - 1)] retain];
                    if (fileListData != nil && fileListData.length > 0) {
                        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
                        [tmpDic setObject:fileListData forKey:@"fileListData"];
                        [tmpDic writeToFile:fileDataPath atomically:YES];
                        [tmpDic release];
                    }
                }
                
                if (fileListData != nil && fileListData.length > 0) {
                    tmpfiles = [self parseFiles:fileListData withFilter:nil];
                    [currBackup.fileArray addObjectsFromArray:tmpfiles];
                    [currBackup setHasFiles:YES];
                }
                [fileListData release];
            } else {
                tmpfiles = currBackup.fileArray;
            }
            
            if (currBackup.hasFiles) {
                for (FileL *f in tmpfiles) {
                    NSString *fileName = [NSString stringToHex:(uint8_t*)(f.fileName.bytes) length:(int)f.fileName.length];
                    IMBiCloudFileInfo *icloudFile = [[IMBiCloudFileInfo alloc] init];
                    [icloudFile setFileName:fileName];
                    [icloudFile setDomain:f.domain];
                    [icloudFile setPath:f.path];
                    ushort mode = f.info.mode;
                    if ((mode & 0xf000) == MASK_SYMBOLIC_LINK) {
                        [icloudFile setFileTypeMode:SymbolicLink];
                    } else if ((mode & 0xf000) == MASK_REGULAR_FILE) {
                        [icloudFile setFileTypeMode:RegularFile];
                    } else if ((mode & 0xf000) == MASK_DIRECTORY) {
                        [icloudFile setFileTypeMode:RegularDirectory];
                    } else {
                        [icloudFile setFileTypeMode:UnknownType];
                    }
                    [icloudFile setFileSize:f.fileSize];
                    [icloudFile setCreateDate:f.info.ctime];
                    [icloudFile setLastModifyDate:f.info.mtime];
                    [filesMap setObject:icloudFile forKey:fileName];
                    [icloudFile release];
                    icloudFile = nil;
                }
            }
        }
    }
    [snapInfoDic release];
    snapInfoDic = nil;
    
    if (filesMap.count > 0) {
        files = [NSMutableArray arrayWithArray:filesMap.allValues];
        int64_t totalSize = 0;
        if (files != nil && files.count > 0) {
            [backup setFileInfoArray:files];
            [backup setHasFilesInfo:YES];
        }
        for (IMBiCloudFileInfo *icloudFile in files) {
            totalSize += icloudFile.fileSize;
        }
        [backup setBackupSize:totalSize];
    }
    
    [filesMap release];
    filesMap = nil;
    return files;
}

- (BOOL)downloadBackup:(IMBiCloudBackup*)backup withFilter:(NSDictionary*)filter withOutputPath:(NSString*)outputPath {
    [_logManager writeInfoLog:@"--------icloud backup download------------"];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"download Name:%@",backup.deviceName]];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"download serial:%@",backup.serialNumber]];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"download date:%@",[DateHelper dateFrom1970ToString:(long)(backup.lastModified) withMode:3]]];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"download size:%@",[StringHelper getFileSizeString:backup.backupSize reserved:2]]];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"download iosVersion:%@",backup.iOSVersion]];
    [_logManager writeInfoLog:@"------------------------------------------"];
    
    if (![self checkLoginStatus]) {
        //@"Login Expired" 登录过期错误
        //toodoo
        [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadExpiredError] userInfo:nil];
        return NO;
    }
    //    NSString *downloadPath = [outputPath stringByAppendingPathComponent:backup.uuid];
    //    downloadPath = [downloadPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", backup.snapshotID]];
    NSString *downloadPath = [outputPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d",backup.uuid,backup.snapshotID]];
    if (![fm fileExistsAtPath:downloadPath]) {
        //[fm removeItemAtPath:downloadPath error:nil];
        [fm createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (!backup.hasKeyBag) {
        NSData *keysData = [self getKeys:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth withBackupUDID:backup.uuid];
        KeysL *keys = nil;
        @try {
            keys = [KeysL parseFromData:keysData];
        }
        @catch (NSException *exception) {
            [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(Keys1):%@",exception.reason]];
        }
        
        NSData *passcode = nil;
        if (keys.keySetList != nil && keys.keySetList.count > 0) {
            KeyL *key = [keys keySetAtIndex:0];
            for (int kbi = 1; kbi < keys.keySetList.count; kbi++) {
                KeyL *keyBag = [keys keySetAtIndex:kbi];
                IMBKeybag *keybag = [[IMBKeybag alloc] initWithKeybagData: keyBag.data];
                [backup.keyBagArray addObject:keybag];
                [keybag release];
                keybag = nil;
            }
            passcode = key.data;
        } else {
            [backup.keyBagArray removeAllObjects];
            [backup setHasKeyBag:NO];
        }
        
        if (passcode.length == 0) {
            [backup.keyBagArray removeAllObjects];
            [backup setHasKeyBag:NO];
        } else {
            for (IMBKeybag *kb in backup.keyBagArray) {
                if (![kb unlockBackupKeybagWithPasscodeData:passcode]) {
                    [backup.keyBagArray removeAllObjects];
                }
            }
            if (backup.keyBagArray.count > 0) {
                [backup setHasKeyBag:YES];
            }
        }
    }
    
    if (!backup.hasKeyBag) {
        backup.isDownloadFailed = YES;
        //@"Download failed!"  下载失败错误
        //toodoo
        [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadOtherError] userInfo:nil];
        return NO;
    } else {
        self.keybagList = backup.keyBagArray;
    }
    
    BOOL networkValid = YES;
    long totalSize = 0;
    NSMutableDictionary *filesMap = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *snapshotFilesMap = [[NSMutableDictionary alloc] init];
    // 如果备份中已经获取到了文件信息就不再获取了，只需要过滤出自己感兴趣的就可以了
    NSMutableDictionary *snapInfoDic = [[NSMutableDictionary alloc] init];
    for (IMBiCloudBackup *backupItem in self.loginInfo.backupList) {
        if ([backupItem.uuid isEqualToString:backup.uuid]) {
            [snapInfoDic setObject:backupItem forKey:[NSNumber numberWithInt:backupItem.snapshotID]];
        }
    }
    // 创建缓存文件
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:self.cacheFolder isDirectory:&isDir]) {
        [fm removeItemAtPath:self.cacheFolder error:nil];
    }
    [fm createDirectoryAtPath:self.cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    self.cacheFileName = 1;
    
    NSArray *allSnapKey = snapInfoDic.allKeys;
    if (allSnapKey != nil && allSnapKey.count > 0) {
        for (int snapshotID = 1; snapshotID < backup.snapshotID + 1; snapshotID++) {
            if (!backup.isDownload) {
                [filesMap release];
                filesMap = nil;
                [snapshotFilesMap release];
                snapshotFilesMap = nil;
                return NO;
            }
            if (![allSnapKey containsObject:[NSNumber numberWithInt:snapshotID]]) {
                continue;
            }
            networkValid = [self checkInternetAvailble];
            if (!networkValid) {
                //@"Download failed!" 下载失败,网络错误
                //toodoo
                [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadNetworkError] userInfo:nil];
                break;
            }
            
            IMBiCloudBackup *currBackup = [snapInfoDic objectForKey:[NSNumber numberWithInt:snapshotID]];
            NSMutableArray *tmpfiles = nil;
            if (!currBackup.hasFiles) {
                NSData *fileListData = [self listFiles:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth withBackupUDID:backup.uuid withSnapshotID:snapshotID withOffset:0 withLimit:(pow(2, 16) - 1)];
                if (fileListData != nil && fileListData.length > 0) {
                    @autoreleasepool {
                        tmpfiles = [[self parseFiles:fileListData withFilter:nil] retain];
                    }
                    [currBackup.fileArray addObjectsFromArray:tmpfiles];
                    [currBackup setHasFiles:YES];
                }
            } else {
                tmpfiles = [currBackup.fileArray retain];
            }
            
            if (currBackup.hasFiles) {
                NSArray *files = nil;
                @autoreleasepool {
                    files = [[self filterFiles:tmpfiles withFilter:filter withWriteFolderPath:downloadPath] retain];
                }
                if (files != nil && files.count > 0) {
                    for (FileL *f in files) {
                        @autoreleasepool {
                            totalSize += f.fileSize;
                            NSString *fileName = [NSString stringToHex:(uint8_t*)(f.fileName.bytes) length:(int)f.fileName.length];
                            IMBiCloudFileInfo *icloudFile = [[IMBiCloudFileInfo alloc] init];
                            [icloudFile setFileName:fileName];
                            [icloudFile setDomain:f.domain];
                            [icloudFile setPath:f.path];
                            [icloudFile setFileSize:f.fileSize];
                            [icloudFile setCreateDate:f.info.ctime];
                            [icloudFile setLastModifyDate:f.info.mtime];
                            [filesMap setObject:icloudFile forKey:fileName];
                            [icloudFile release];
                            icloudFile = nil;
                        }
                    }
                    [snapshotFilesMap setObject:files forKey:[NSNumber numberWithInt:snapshotID]];
                }
                if (files != nil) {
                    [files release];
                    files = nil;
                }
            }
            if (tmpfiles != nil) {
                [tmpfiles release];
                tmpfiles = nil;
            }
        }
    }
    [snapInfoDic release];
    snapInfoDic = nil;
    
    NSDictionary *info = nil;//[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:totalSize], @"TotalSize", nil];
    //    [nc postNotificationName:@"Download start!" object:nil userInfo:info];
    
    if (filesMap.allKeys.count > 0) {
        NSArray *totalFiles = filesMap.allValues;
        if (totalFiles != nil && totalFiles.count > 0) {
            NSString *infoPlistPath = [downloadPath stringByAppendingPathComponent:@"info.plist"];
            NSMutableArray *infoArray = nil;
            if ([fm fileExistsAtPath:infoPlistPath]) {
                infoArray = [[NSMutableArray arrayWithContentsOfFile:infoPlistPath] retain];
            }else {
                infoArray = [[NSMutableArray alloc] init];
            }
            for (IMBiCloudFileInfo *f in totalFiles) {
                if (!backup.isDownload) {
                    [filesMap release];
                    filesMap = nil;
                    [snapshotFilesMap release];
                    snapshotFilesMap = nil;
                    [infoArray release];
                    infoArray = nil;
                    return NO;
                }
                BOOL isAdd = YES;
                NSMutableDictionary *fInfo = [[NSMutableDictionary alloc] init];
                [fInfo setObject:f.fileName forKey:@"FileName"];
                [fInfo setObject:f.domain forKey:@"Domain"];
                [fInfo setObject:f.path forKey:@"Path"];
                [fInfo setObject:[NSNumber numberWithLongLong:f.fileSize] forKey:@"FileSize"];
                [fInfo setObject:[NSNumber numberWithLongLong:f.createDate] forKey:@"CreateDate"];
                [fInfo setObject:[NSNumber numberWithLongLong:f.lastModifyDate] forKey:@"LastModifyDate"];
                for (NSDictionary *dic in infoArray) {
                    NSString *domianName = [dic objectForKey:@"Domain"];
                    NSString *pathName = [dic objectForKey:@"path"];
                    if ([domianName isEqualToString:f.path] && [pathName isEqualToString:f.domain]) {
                        isAdd = NO;
                        break;
                    }
                }
                if (isAdd) {
                    [infoArray addObject:fInfo];
                }
                [fInfo release];
                fInfo = nil;
            }
            
            
            if ([fm fileExistsAtPath:infoPlistPath]) {
                [fm removeItemAtPath:infoPlistPath error:nil];
            }
            [infoArray writeToFile:infoPlistPath atomically:YES];
            if (infoArray != nil) {
                [infoArray release];
                infoArray = nil;
            }
        }
    }
    
    long downloadedTotalSize = 0;
    
    NSArray *allKey = snapshotFilesMap.allKeys;
    allKey = [allKey sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
    
    NSMutableDictionary *fileDataMap = [[NSMutableDictionary alloc] init];
    NSMutableArray *keyArrMap = [[NSMutableArray alloc] init];
    for (NSNumber *sidNum in allKey) {
        int snapshortID = sidNum.intValue;
        NSArray *files = [snapshotFilesMap objectForKey:sidNum];
        if (files.count == 0) {
            continue;
        }
        networkValid = [self checkInternetAvailble];
        if (!networkValid) {
            //@"networkDisconnect"  网络连接错误
            //toodoo
            [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadNetworkError] userInfo:nil];
            break;
        }
        NSData *fgdata = nil;
        @autoreleasepool {
            NSData *getFilesRequest = [self buildGetFiles:files];
            NSData *getFilesResponse = [self getFilesData:getFilesRequest withPNum:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth withBackupUDID:backup.uuid withSnapshotID:snapshortID];//与服务器打交道，耗时
            if (!backup.isDownload) {
                return NO;
            }
            NSArray *authChunks = [self parseAuthChunk:getFilesResponse];
            if (authChunks == nil || authChunks.count == 0) {
                continue;
            }
            NSDictionary *hd = [self buildHashDictionary:files];
            IMBKeyValuePair *fa = [self buildAuthorizeGetA:authChunks withHashDict:hd];
            fgdata = [[self authorizeGet:[fa.value data] withAuth:fa.key withPNum:self.loginInfo.pNum withDsPrsID:self.loginInfo.dsPrsID withMmeAuthToken:self.loginInfo.mmeAuth] retain];
        }
        
        FileGroupsL *filegroups = nil;
        @try {
            filegroups = [FileGroupsL parseFromData:fgdata];
        }
        @catch (NSException *exception) {
            [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(FileGroups):%@",exception.reason]];
        }
        
        [fgdata release];
        fgdata = nil;
        if (!backup.isDownload) {
            [filesMap release];
            filesMap = nil;
            [snapshotFilesMap release];
            snapshotFilesMap = nil;
            [fileDataMap release];
            fileDataMap = nil;
            [keyArrMap release];
            keyArrMap = nil;
            return NO;
        }
        
        NSMutableArray *keyArr = [[NSMutableArray alloc] initWithArray:[_filesDic allKeys]];//[NSMutableArray arrayWithArray:[_filesDic allKeys]];
        info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[TempHelper usedMemory]], @"DownloadedTotalSize",  [NSNumber numberWithLong:totalSize], @"totalSize", nil];
        [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_PROGRESS object:nil userInfo:info];
        [_logManager writeInfoLog:[NSString stringWithFormat:@"icloud,memory:%f",[TempHelper usedMemory]]];
        for (FileChecksumStorageHostChunkListsL *group in filegroups.fileGroupsDataList) {
            if (!backup.isDownload) {
                [filesMap release];
                filesMap = nil;
                [snapshotFilesMap release];
                snapshotFilesMap = nil;
                [fileDataMap release];
                fileDataMap = nil;
                [keyArrMap release];
                keyArrMap = nil;
                [keyArr release];
                keyArr = nil;
                return NO;
            }
            NSMutableArray *dataFilePath = nil;
            for (int shci = 0; shci < group.storageHostChunkListList.count; shci++) {
                if (!backup.isDownload) {
                    [filesMap release];
                    filesMap = nil;
                    [snapshotFilesMap release];
                    snapshotFilesMap = nil;
                    [fileDataMap release];
                    fileDataMap = nil;
                    [keyArrMap release];
                    keyArrMap = nil;
                    [keyArr release];
                    keyArr = nil;
                    return NO;
                }
                //                networkValid = [self checkInternetAvailble];
                //                if (!networkValid) {
                //                    break;
                //                }
                StorageHostChunkListL *hosts = [group storageHostChunkListAtIndex:shci];
                @try {
                    //                    @autoreleasepool {
                    if (dataFilePath != nil) {
                        [dataFilePath release];
                        dataFilePath = nil;
                    }
                    dataFilePath = [[NSMutableArray alloc] init];
                    [self downloadChunks:hosts withCacheData:dataFilePath];
                    //                    }
                }
                @catch (NSException *exception) {
                    if (dataFilePath != nil) {
                        [dataFilePath release];
                        dataFilePath = nil;
                    }
                    [_logManager writeInfoLog:[NSString stringWithFormat:@"DownloadChunks faild, reason is %@", [exception reason]]];
                    continue;
                }
                
                if (dataFilePath == nil) {
                    continue;
                }
                
                for (int fccri = 0; fccri < group.fileChecksumChunkReferencesList.count; fccri++) {
                    //                    [_logManager writeInfoLog:[NSString stringWithFormat:@"download icloud file,memory:%f",[IMBHelper usedMemory]]];
                    if (!backup.isDownload) {
                        [filesMap release];
                        filesMap = nil;
                        [snapshotFilesMap release];
                        snapshotFilesMap = nil;
                        [fileDataMap release];
                        fileDataMap = nil;
                        [keyArrMap release];
                        keyArrMap = nil;
                        [keyArr release];
                        keyArr = nil;
                        if (dataFilePath != nil) {
                            [dataFilePath release];
                            dataFilePath = nil;
                        }
                        return NO;
                    }
                    @autoreleasepool {
                        FileChecksumChunkReferencesL *fileRef = [group fileChecksumChunkReferencesAtIndex:fccri];
                        BOOL isContain = NO;
                        @autoreleasepool {
                            isContain = [keyArr containsObject:fileRef.fileChecksum];
                        }
                        if (!isContain) {
                            continue;
                        }
                        NSMutableDictionary *decryptedChunks = [[NSMutableDictionary alloc] init];
                        for (int cri = 0; cri < fileRef.chunkReferencesList.count; cri++) {
                            if (!backup.isDownload) {
                                [filesMap release];
                                filesMap = nil;
                                [snapshotFilesMap release];
                                snapshotFilesMap = nil;
                                [fileDataMap release];
                                fileDataMap = nil;
                                [keyArrMap release];
                                keyArrMap = nil;
                                [keyArr release];
                                keyArr = nil;
                                [decryptedChunks release];
                                decryptedChunks = nil;
                                if (dataFilePath != nil) {
                                    [dataFilePath release];
                                    dataFilePath = nil;
                                }
                                return NO;
                            }
                            ChunkReferenceL *chunkRef = [fileRef chunkReferencesAtIndex:cri];
                            if ((int)chunkRef.containerIndex == shci) {
                                [decryptedChunks setObject:[dataFilePath objectAtIndex:(int)[chunkRef chunkIndex]] forKey:[NSNumber numberWithInt:cri]];
                            }
                        }
                        
                        NSMutableDictionary *dcDic = nil;
                        isContain = NO;
                        @autoreleasepool {
                            //                            NSArray *keyArrMap = [fileDataMap allKeys];
                            if (keyArrMap.count > 0) {
                                isContain = [keyArrMap containsObject:fileRef.fileChecksum];
                            }
                        }
                        if (isContain) {
                            dcDic = [[fileDataMap objectForKey:fileRef.fileChecksum] retain];
                        } else {
                            dcDic = [[NSMutableDictionary alloc] init];
                            [fileDataMap setObject:dcDic forKey:fileRef.fileChecksum];
                            [keyArrMap addObject:fileRef.fileChecksum];
                        }
                        
                        for (NSNumber *key in decryptedChunks) {
                            if (!backup.isDownload) {
                                [filesMap release];
                                filesMap = nil;
                                [snapshotFilesMap release];
                                snapshotFilesMap = nil;
                                [fileDataMap release];
                                fileDataMap = nil;
                                [keyArrMap release];
                                keyArrMap = nil;
                                [keyArr release];
                                keyArr = nil;
                                [decryptedChunks release];
                                decryptedChunks = nil;
                                [dcDic release];
                                dcDic = nil;
                                if (dataFilePath != nil) {
                                    [dataFilePath release];
                                    dataFilePath = nil;
                                }
                                return NO;
                            }
                            NSString *fileCachePath = [decryptedChunks objectForKey:key];
                            //                            NSData *filedata = [decryptedChunks objectForKey:key];
                            [dcDic setObject:fileCachePath forKey:key];
                        }
                        
                        if (dcDic.allKeys.count == fileRef.chunkReferencesList.count) {
                            FileL *f = [_filesDic objectForKey:fileRef.fileChecksum];
                            long fileSize = [self writeFile:f withDecryptedChunks:dcDic withOutputPath:downloadPath];
                            downloadedTotalSize += fileSize;
                            info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:downloadedTotalSize], @"DownloadedTotalSize",  [NSNumber numberWithLong:totalSize], @"totalSize", nil];
                            //                            NSLog(@"info progrress:%f",((float)downloadedTotalSize)/totalSize);
                            //toodoo
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_PROGRESS object:nil userInfo:info];
                            [_filesDic removeObjectForKey:fileRef.fileChecksum];
                            [keyArr removeObject:fileRef.fileChecksum];
                        }
                        [dcDic release];
                        dcDic = nil;
                        [decryptedChunks release];
                        decryptedChunks = nil;
                    }
                }
                if (dataFilePath != nil) {
                    [dataFilePath release];
                    dataFilePath = nil;
                }
            }
            if (!networkValid) {
                break;
            }
        }
        
        // -- stop
        if (keyArr != nil) {
            [keyArr release];
            keyArr = nil;
        }
        if (!networkValid) {
            //@"networkDisconnect" 网络连接错误
            //toodoo
            [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_ERROR object:[NSNumber numberWithInt:DownloadNetworkError] userInfo:nil];
        }
    }
    [fileDataMap release];
    fileDataMap = nil;
    [keyArrMap release];
    keyArrMap = nil;
    // 清理缓存文件
    if ([fm fileExistsAtPath:self.cacheFolder]) {
        [fm removeItemAtPath:self.cacheFolder error:nil];
    }
    //    info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:downloadedTotalSize], @"DownloadFileSize", nil];
    
    if (_filesDic != nil) {
        [_filesDic release];
        _filesDic = nil;
    }
    if (_keybagList != nil) {
        [_keybagList release];
        _keybagList = nil;
    }
    if (networkValid) {
        backup.isDownloadSucess = YES;
        //toodoo
        [nc postNotificationName:NOTIFY_ICLOUD_DOWNLOAD_COMPLETE object:nil userInfo:nil];
    }
    [filesMap release];
    filesMap = nil;
    [snapshotFilesMap release];
    snapshotFilesMap = nil;
    return YES;
}

- (void)downloadChunks:(StorageHostChunkListL*)storageHost withCacheData:(NSMutableArray *)cacheData {
    NSData *fileData = [self getFileData:storageHost.hostInfo.headersList withHost:storageHost.hostInfo.hostname withPath:storageHost.hostInfo.uri];
    //    NSMutableArray *decrypted = [[[NSMutableArray alloc] init] autorelease];
    uint currPos = 0;
    NSData *decryptedData = nil;
    for (int i = 0; i < storageHost.chunkInfoList.count; i++) {
        @autoreleasepool {
            ChunkInfoL *ci = [storageHost chunkInfoAtIndex:i];
            NSData *chunkData = [fileData subdataWithRange:NSMakeRange(currPos, ci.chunkLength)];
            NSData *enckey = [ci.chunkEncryptionKey subdataWithRange:NSMakeRange(1, (ci.chunkEncryptionKey.length - 1))];
            NSData *checksum = [ci.chunkChecksum subdataWithRange:NSMakeRange(1, 20)];
            @autoreleasepool {
                decryptedData = [[IMBAES_CFB decryptCFBWithKey:(Byte*)(enckey.bytes) withIV:ZERO_IV withData:chunkData] retain];
            }
            NSData *sha = [decryptedData sha256];
            sha = [sha sha256];
            NSData *verify = [sha subdataWithRange:NSMakeRange(0, 20)];
            if (![self compareWithData:verify withData:checksum]) {
                if (decryptedData != nil) {
                    [decryptedData release];
                    decryptedData = nil;
                }
                @throw [NSException exceptionWithName:@"Verify failed!" reason:@"Verify failed!" userInfo:nil];
            }
            if (decryptedData != nil) {
                NSString *cacheFilePath = [self.cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", self.cacheFileName]];
                if (![fm fileExistsAtPath:cacheFilePath]) {
                    [fm createFileAtPath:cacheFilePath contents:decryptedData attributes:nil];
                }
                [cacheData addObject:cacheFilePath];
                self.cacheFileName += 1;
                [decryptedData release];
                decryptedData = nil;
            }
            currPos += ci.chunkLength;
        }
    }
    //    return decrypted;
}

- (NSData*)decryptChunk:(NSData*)chunkData withEncryptionKey:(NSData*)encryptionKey withChunkChecksum:(NSData*)chunkChecksum {
    NSData *clearData = [IMBAES_CFB decryptCFBWithKey:(Byte*)(encryptionKey.bytes) withIV:ZERO_IV withData:chunkData];
    @autoreleasepool {
        NSData *sha = [clearData sha256];
        sha = [sha sha256];
        NSData *verify = [sha subdataWithRange:NSMakeRange(0, 20)];
        if (![self compareWithData:verify withData:chunkChecksum]) {
            @throw [NSException exceptionWithName:@"Verify failed!" reason:@"Verify failed!" userInfo:nil];
        }
    }
    return clearData;
}

- (long)writeFile:(FileL*)f withDecryptedChunks:(NSDictionary*)decryptedChunks withOutputPath:(NSString*)outputPath {
    long fileSize = 0;
    IMBKeybag *keybag = nil;
    if (f.info.hasKeybagId) {
        if (f.info.keybagId > self.keybagList.count) {
            keybag = [self.keybagList objectAtIndex:0];
        }else if (f.info.keybagId == self.keybagList.count) {
            keybag = [self.keybagList objectAtIndex:self.keybagList.count - 1];
        }else {
            keybag = [self.keybagList objectAtIndex:f.info.keybagId];
        }
    } else {
        keybag = [self.keybagList objectAtIndex:0];
    }
    
    //NSString *path = [outputPath stringByAppendingPathComponent:[NSString stringToHex:(uint8_t*)(f.fileName.bytes) length:f.fileName.length]];
    //    NSString *path = [outputPath stringByAppendingPathComponent:f.path];
    //    NSString *folderPath = [path stringByDeletingLastPathComponent];
    //    if (![fm fileExistsAtPath:folderPath]) {
    //        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    //    }
    //    if ([fm fileExistsAtPath:path]) {
    //        [fm removeItemAtPath:path error:nil];
    //    }
    //    [fm createFileAtPath:path contents:nil attributes:nil];
    
    NSString *path = nil;
    @autoreleasepool {
        NSString *fileName = [NSString stringToHex:(uint8_t*)(f.fileName.bytes) length:(int)f.fileName.length];
        path = [[outputPath stringByAppendingPathComponent:fileName] retain];
    }
    
    if (![fm fileExistsAtPath:path]) {
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
    
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file == nil) {
        fileSize = (long)f.fileSize;
    }
    [file truncateFileAtOffset:0];
    
    NSArray *indexs = decryptedChunks.allKeys;
    indexs = [indexs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
    
    for (NSNumber *index in indexs) {
        @autoreleasepool {
            // 获取文件的内容
            NSString *cachePath = [decryptedChunks objectForKey:index];
            NSData *filedata = nil;
            if ([fm fileExistsAtPath:cachePath]) {
                NSFileHandle *rfh = [NSFileHandle fileHandleForReadingAtPath:cachePath];
                filedata = [rfh readDataToEndOfFile];
                [fm removeItemAtPath:cachePath error:nil];
            }
            if (filedata != nil) {
                [file writeData:filedata];
                fileSize += filedata.length;
            }
        }
    }
    [file closeFile];
    
    if (f.info.encryptionKey != nil && f.info.encryptionKey.length > 0) {
        NSData *encryptionKey = f.info.encryptionKey;
        NSData *pcData = [encryptionKey subdataWithRange:NSMakeRange(0x18, 0x04)];
        int protectionClass = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)(pcData.bytes) byteLength:(int)pcData.length];
        if (!(protectionClass != f.info.protectionClass)) {
            fileSize = f.info.decryptedSize;
            return fileSize;
        }
        
        NSData *wrappedKey = nil;
        if (f.info.hasEncryptionKeyVersion && f.info.encryptionKeyVersion  == 2) {
            NSData *assertData = [encryptionKey subdataWithRange:NSMakeRange(0x20, 0x10)];
            if (![self compareWithData:[keybag uuid] withData:assertData]) {
                fileSize = f.info.decryptedSize;
                return fileSize;
            }
            NSData *keyLenData = [encryptionKey subdataWithRange:NSMakeRange(0x20, 4)];
            int keyLength = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)(keyLenData.bytes) byteLength:(int)keyLenData.length];
            if (keyLength != 0x48) {
                fileSize = f.info.decryptedSize;
                return fileSize;
            }
            long wrappedKeyLen = encryptionKey.length - 0x24;
            wrappedKey = [encryptionKey subdataWithRange:NSMakeRange(0x24, wrappedKeyLen)];
        } else {
            long wrappedKeyLen = encryptionKey.length - 0x1C;
            wrappedKey = [encryptionKey subdataWithRange:NSMakeRange(0x1c, wrappedKeyLen)];
        }
        
        NSData *fileKey = nil;
        @try {
            fileKey = [keybag unwrapKeyForClass:protectionClass withPersistentKey:wrappedKey];
        }
        @catch (NSException *exception) {
            fileSize = f.info.decryptedSize;
            return fileSize;
        }
        if (fileKey != nil && fileKey.length > 0) {
            if (![self decryptProtectedFile:path withFileKey:fileKey withDecryptedSize:f.info.decryptedSize]) {
                [fm removeItemAtPath:path error:nil];
            }
            fileSize = f.info.decryptedSize;
        } else {
            fileSize = f.info.decryptedSize;
        }
    }
    if (path != nil) {
        [path release];
        path = nil;
    }
    return fileSize;
}

- (BOOL)decryptProtectedFile:(NSString*)path withFileKey:(NSData*)fileKey withDecryptedSize:(int)decryptedSize {
    BOOL retVal = YES;
    NSData *sha1Data = [fileKey sha1];
    NSData *ivKey = [sha1Data subdataWithRange:NSMakeRange(0, 16)];
    NSString *oldPath = [path stringByAppendingString:@".encrypted"];
    if ([fm fileExistsAtPath:oldPath]) {
        [fm removeItemAtPath:oldPath error:nil];
    }
    [fm moveItemAtPath:path toPath:oldPath error:nil];
    
    if ([fm fileExistsAtPath:oldPath] && ![fm fileExistsAtPath:path]) {
        NSDictionary *fileInfo = [fm attributesOfItemAtPath:oldPath error:nil];
        long sz = 0;
        if (fileInfo != nil) {
            sz = [[fileInfo valueForKey:NSFileSize] longValue];
        }
        if (sz > 0) {
            long n = (sz / 0x1000);
            if (decryptedSize > 0) {
                n = n + 1;
            }
            
            NSFileHandle *encFile = [NSData dataWithContentsOfFile:oldPath];
            NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:path];
            
            CC_SHA1_CTX ctx;
            CC_SHA1_Init(&ctx);
            for (int block = 0; block < n; block++) {
                NSData *iv = [IMBAES_256_CBC aesEncryptWithData:[self computeIV:(UInt32)(block * 0x1000)] withKey:ivKey withIV:[NSData dataWithBytes:ZERO_IV length:16]];
                NSData *data = [encFile readDataOfLength:0x1000];
                CC_SHA1_Update(&ctx, data.bytes, (int)data.length);
                NSData *decData = [IMBAES_256_CBC aesDecryptWithData:data withKey:fileKey withIV:iv];
                if (decData != nil && decData.length > 0) {
                    [file writeData:decData];
                }
            }
            
            if (decryptedSize == 0) {
                NSData *trailer = [encFile readDataOfLength:0x1C];
                NSData *decryptedSizeData = [trailer subdataWithRange:NSMakeRange(0, 8)];
                decryptedSize = (int)[IMBBigEndianBitConverter bigEndianToInt64:(Byte*)(decryptedSizeData.bytes) byteLength:(int)decryptedSizeData.length];
                
                int verifyLen = 0x1C - 0x08;
                NSData *verifyData = [trailer subdataWithRange:NSMakeRange(0x08, verifyLen)];
                unsigned char digest[CC_SHA1_DIGEST_LENGTH];
                CC_SHA1_Final(digest, &ctx);
                NSData *hashData = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
                if (![self compareWithData:hashData withData:verifyData]) {
                    retVal = NO;
                }
            }
            [encFile closeFile];
            [file truncateFileAtOffset:decryptedSize];
            [file closeFile];
        }
        [fm removeItemAtPath:oldPath error:nil];
    }
    return retVal;
}

#define HFS_IV_GENERATOR 0x80000061
#define IV_GEN(x) (((x) >> 1) ^ (((x) & 1) ? HFS_IV_GENERATOR : 0))
- (NSData*)computeIV:(UInt32)seed {
    NSMutableData *retData = [[[NSMutableData alloc] init] autorelease];
    seed = IV_GEN(seed);
    [retData appendBytes:&seed length:sizeof(seed)];
    seed = IV_GEN(seed);
    [retData appendBytes:&seed length:sizeof(seed)];
    seed = IV_GEN(seed);
    [retData appendBytes:&seed length:sizeof(seed)];
    seed = IV_GEN(seed);
    [retData appendBytes:&seed length:sizeof(seed)];
    return retData;
}

- (NSString *)authenticate:(NSString*)appleID withPassword:(NSString*)password {
    NSString *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/6.1.3(N90AP;iPhone3,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"Basic %@", [IMBHttpWebResponseUtility encode:appleID withPart:password]] forKey:@"Authorization"];
    [authHeaders setObject:@"<iPhone3,1><iPhone OS;6.1.3;10B329><com.apple.AppleAccount/1.0(com.apple.backupd/10B329)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility getWithHeaders:authHeaders withHost:@"setup.icloud.com" withPath:[NSString stringWithFormat:@"/setup/authenticate/%@", appleID] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSDictionary *)dictionaryWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary *dict = [NSPropertyListSerialization
                          propertyListFromData:data
                          mutabilityOption:NSPropertyListImmutable
                          format:&format
                          errorDescription:&error];
    if(!dict){
        [error release];
    }
    return dict;
}

- (BOOL)parseAuthenticate:(NSString*)plist {
    BOOL retVal = NO;
    NSString *dsPrsID = nil;
    NSString *mmeAuth = nil;
    NSDictionary *dic = [self dictionaryWithString:plist];
    if (dic != nil && dic.allKeys.count > 0) {
        NSArray *allkeys = dic.allKeys;
        if ([allkeys containsObject:@"appleAccountInfo"]) {
            NSDictionary *tmpDic = [dic objectForKey:@"appleAccountInfo"];
            if (tmpDic != nil && tmpDic.allKeys.count > 0) {
                NSArray *subAllKeys = tmpDic.allKeys;
                if ([subAllKeys containsObject:@"dsPrsID"]) {
                    int64_t retDsPrsID = [[tmpDic objectForKey:@"dsPrsID"] longLongValue];
                    dsPrsID = [NSString stringWithFormat:@"%lld", retDsPrsID];
                }
            }
        }
        
        if ([allkeys containsObject:@"tokens"]) {
            NSDictionary *tmpDic = [dic objectForKey:@"tokens"];
            if (tmpDic != nil && tmpDic.allKeys.count > 0) {
                NSArray *subAllKeys = tmpDic.allKeys;
                if ([subAllKeys containsObject:@"mmeAuthToken"]) {
                    mmeAuth = [tmpDic objectForKey:@"mmeAuthToken"];
                }
            }
        }
    }
    
    if (![self stringIsNilOrEmpty:dsPrsID] && ![self stringIsNilOrEmpty:mmeAuth]) {
        [self.loginInfo setDsPrsID:dsPrsID];
        [self.loginInfo setMmeAuth:mmeAuth];
        retVal = YES;
    } else {
        retVal = NO;
    }
    
    return retVal;
}

- (NSString *)getAccountInfo:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken {
    NSString *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/6.1.3(N90AP;iPhone3,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"Basic %@", [IMBHttpWebResponseUtility encode:dsPrsID withPart:mmeAuthToken]] forKey:@"Authorization"];
    [authHeaders setObject:@"<iPhone3,1><iPhone OS;6.1.3;10B329><com.apple.AppleAccount/1.0(com.apple.backupd/10B329)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility getWithHeaders:authHeaders withHost:@"setup.icloud.com" withPath:@"/setup/get_account_settings" withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (BOOL)parseAccountInfo:(NSString*)plist {
    BOOL retVal = NO;
    NSString *mmeAuth = nil;
    NSString *pnum = nil;
    NSDictionary *dic = [self dictionaryWithString:plist];
    if (dic != nil && dic.allKeys.count > 0) {
        NSArray *allkeys = dic.allKeys;
        if ([allkeys containsObject:@"tokens"]) {
            NSDictionary *tmpDic = [dic objectForKey:@"tokens"];
            if (tmpDic != nil && tmpDic.allKeys.count > 0) {
                NSArray *subAllKeys = tmpDic.allKeys;
                if ([subAllKeys containsObject:@"mmeAuthToken"]) {
                    mmeAuth = [tmpDic objectForKey:@"mmeAuthToken"];
                }
            }
        }
        
        if ([allkeys containsObject:@"com.apple.mobileme"]) {
            NSDictionary *mobileMeDic = [dic objectForKey:@"com.apple.mobileme"];
            if (mobileMeDic != nil && mobileMeDic.allKeys.count > 0) {
                NSArray *mAllKeys = mobileMeDic.allKeys;
                if ([mAllKeys containsObject:@"com.apple.Dataclass.Backup"]) {
                    NSDictionary *backupInfo = [mobileMeDic objectForKey:@"com.apple.Dataclass.Backup"];
                    if (backupInfo != nil && backupInfo.allKeys.count > 0) {
                        if ([backupInfo.allKeys containsObject:@"url"]) {
                            NSString *backupUrl = [backupInfo objectForKey:@"url"];
                            pnum = [backupUrl stringByMatching:@"https://p([0-9]+)-mobilebackup.icloud.com:443$" capture:1L];
                        }
                    }
                }
            }
        }
    }
    if (![self stringIsNilOrEmpty:mmeAuth] && ![self stringIsNilOrEmpty:pnum]) {
        [self.loginInfo setMmeAuth:mmeAuth];
        [self.loginInfo setPNum:pnum];
        retVal = YES;
    } else {
        [self.loginInfo setMmeAuth:@""];
        [self.loginInfo setPNum:@""];
        retVal = NO;
    }
    return retVal;
}

- (NSData *)listDevices:(NSString*)pNum withDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/6.1.3(N90AP;iPhone3,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"X-MobileMe-AuthToken %@", [IMBHttpWebResponseUtility encode:dsPrsID withPart:mmeAuthToken]] forKey:@"Authorization"];
    [authHeaders setObject:@"1.7" forKey:@"X-Apple-MBS-Protocol-Version"];
    [authHeaders setObject:@"<iPhone3,1><iPhone OS;6.1.3;10B329><com.apple.AppleAccount/1.0(com.apple.backupd/10B329)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:[NSString stringWithFormat:@"p%@-mobilebackup.icloud.com", pNum] withPath:[NSString stringWithFormat:@"/mbs/%@", dsPrsID] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSData *)getInfo:(NSString*)pNum withDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withBackupUDID:(NSString*)backupUDID {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/6.1.3(N90AP;iPhone3,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"X-MobileMe-AuthToken %@", [IMBHttpWebResponseUtility encode:dsPrsID withPart:mmeAuthToken]] forKey:@"Authorization"];
    [authHeaders setObject:@"1.7" forKey:@"X-Apple-MBS-Protocol-Version"];
    [authHeaders setObject:@"<iPhone3,1><iPhone OS;6.1.3;10B329><com.apple.AppleAccount/1.0(com.apple.backupd/10B329)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:[NSString stringWithFormat:@"p%@-mobilebackup.icloud.com", pNum] withPath:[NSString stringWithFormat:@"/mbs/%@/%@", dsPrsID, backupUDID] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSData *)getKeys:(NSString*)pNum withDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withBackupUDID:(NSString*)backupUDID {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/6.1.3(N90AP;iPhone3,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"X-MobileMe-AuthToken %@", [IMBHttpWebResponseUtility encode:dsPrsID withPart:mmeAuthToken]] forKey:@"Authorization"];
    [authHeaders setObject:@"1.7" forKey:@"X-Apple-MBS-Protocol-Version"];
    [authHeaders setObject:@"<iPhone3,1><iPhone OS;6.1.3;10B329><com.apple.AppleAccount/1.0(com.apple.backupd/10B329)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:[NSString stringWithFormat:@"p%@-mobilebackup.icloud.com", pNum] withPath:[NSString stringWithFormat:@"/mbs/%@/%@/getKeys", dsPrsID, backupUDID] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSData *)listFiles:(NSString*)pNum withDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withBackupUDID:(NSString*)backupUDID withSnapshotID:(int)snapshotID withOffset:(int)offset withLimit:(long)limit {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/6.1.3(N90AP;iPhone3,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"X-MobileMe-AuthToken %@", [IMBHttpWebResponseUtility encode:dsPrsID withPart:mmeAuthToken]] forKey:@"Authorization"];
    [authHeaders setObject:@"1.7" forKey:@"X-Apple-MBS-Protocol-Version"];
    [authHeaders setObject:@"<iPhone3,1><iPhone OS;6.1.3;10B329><com.apple.AppleAccount/1.0(com.apple.backupd/10B329)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:[NSString stringWithFormat:@"p%@-mobilebackup.icloud.com", pNum] withPath:[NSString stringWithFormat:@"/mbs/%@/%@/%d/listFiles?offset=%d%@", dsPrsID, backupUDID, snapshotID, offset, (limit == 0 ? @"" : [NSString stringWithFormat:@"&limit=%ld", limit])] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSData *)getFilesData:(NSData*)data withPNum:(NSString*)pNum withDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withBackupUDID:(NSString*)backupUDID withSnapshotID:(int)snapshotID {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/7.1(N78AP;iPod5,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"*/*" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:[NSString stringWithFormat:@"X-MobileMe-AuthToken %@", [IMBHttpWebResponseUtility encode:dsPrsID withPart:mmeAuthToken]] forKey:@"Authorization"];
    [authHeaders setObject:@"1.7" forKey:@"X-Apple-MBS-Protocol-Version"];
    [authHeaders setObject:@"<iPod5,1><iPod OS;7.1;11D167><com.apple.AppleAccount/1.0(com.apple.backupd/11D167)>" forKey:@"X-MMe-Client-Info"];
    retVal = [IMBHttpWebResponseUtility postWithData:data withHeaders:authHeaders withHost:[NSString stringWithFormat:@"p%@-mobilebackup.icloud.com", pNum] withPath:[NSString stringWithFormat:@"/mbs/%@/%@/%d/getFiles", dsPrsID, [backupUDID lowercaseString], snapshotID] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSData *)authorizeGet:(NSData*)data withAuth:(NSString*)auth withPNum:(NSString*)pNum withDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    [authHeaders setObject:@"MobileBackup/7.1(N78AP;iPod5,1)" forKey:@"User-Agent"];
    [authHeaders setObject:@"application/vnd.com.apple.me.ubchunk+protobuf" forKey:@"Accept"];
    [authHeaders setObject:@"en-US" forKey:@"Accept-Language"];
    [authHeaders setObject:@"pplication/vnd.com.apple.me.ubchunk+protobuf" forKey:@"Content-Type"];
    [authHeaders setObject:@"<iPod5,1><iPod OS;7.1;11D167><com.apple.AppleAccount/1.0(com.apple.backupd/11D167)>" forKey:@"X-MMe-Client-Info"];
    [authHeaders setObject:auth forKey:@"X-Apple-mmcs-auth"];
    [authHeaders setObject:@"com.apple.Dataclass.Backup" forKey:@"X-Apple-mmcs-DataClass"];
    [authHeaders setObject:@"3.3" forKey:@"X-Apple-mmcs-Proto-Version"];
    [authHeaders setObject:dsPrsID forKey:@"X-Apple-mme-dsid"];
    retVal = [IMBHttpWebResponseUtility postWithData:data withHeaders:authHeaders withHost:[NSString stringWithFormat:@"p%@-content.icloud.com", pNum] withPath:[NSString stringWithFormat:@"/%@/authorizeGet", dsPrsID] withSSL:YES];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

- (NSData *)getFileData:(NSArray*)_headers withHost:(NSString*)host withPath:(NSString*)path {
    NSData *retVal = nil;
    NSMutableDictionary *authHeaders = [[NSMutableDictionary alloc] init];
    if (_headers != nil && _headers.count > 0) {
        for (NameValuePairL *nvp in _headers) {
            [authHeaders setObject:nvp.value forKey:nvp.name];
        }
    }
    retVal = [IMBHttpWebResponseUtility getBytesWithHeaders:authHeaders withHost:host withPath:path withSSL:NO];
    [authHeaders release];
    authHeaders = nil;
    return retVal;
}

+ (NSMutableArray *)parseNoLoginFiles:(NSData *)fileListData  withFilter:(NSDictionary*)filter {
    NSMutableArray *files = [[[NSMutableArray alloc] init] autorelease];
    PBCodedInputStream *fileCounter = [PBCodedInputStream streamWithData:fileListData];
    PBCodedInputStream *fileParser = [PBCodedInputStream streamWithData:fileListData];
    int numFiles = 0;
    for (numFiles = 0; ![fileCounter isAtEnd]; numFiles++) {
        int j = [fileCounter readRawVarint32];
        [fileCounter skipRawData:j];
    }
    
    for (int i = 0; ![fileParser isAtEnd]; i++) {
        int len = [fileParser readRawVarint32];
        FileL *file = nil;
        @try {
            file = [FileL parseFromData:[fileParser readRawData:len]];
        }
        @catch (NSException *exception) {
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"exception reason(FileEx1):%@",exception.reason]];
        }
        
        if (filter != nil && filter.allKeys.count > 0) {
            for (NSString *key in filter) {
                NSString *domain = key;
                NSArray *paths = [filter objectForKey:domain];
                if ([file.domain containsString:domain]) {
                    if (paths != nil && paths.count > 0) {
                        for (NSString *path in paths) {
                            if ([file.path containsString:path]) {
                                [files addObject:file];
                                break;
                            }
                        }
                        break;
                    } else {
                        [files addObject:file];
                        break;
                    }
                }
            }
        } else {
            [files addObject:file];
        }
    }
    return files;
}

- (NSMutableArray*)parseFiles:(NSData*)fileListData withFilter:(NSDictionary*)filter {
    NSMutableArray *files = [[[NSMutableArray alloc] init] autorelease];
    PBCodedInputStream *fileCounter = [PBCodedInputStream streamWithData:fileListData];
    PBCodedInputStream *fileParser = [PBCodedInputStream streamWithData:fileListData];
    int numFiles = 0;
    for (numFiles = 0; ![fileCounter isAtEnd]; numFiles++) {
        int j = [fileCounter readRawVarint32];
        [fileCounter skipRawData:j];
    }
    
    for (int i = 0; ![fileParser isAtEnd]; i++) {
        int len = [fileParser readRawVarint32];
        @autoreleasepool {
            FileL *file = nil;
            @try {
                file = [FileL parseFromData:[fileParser readRawData:len]];
            }
            @catch (NSException *exception) {
                [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(FileEx):%@",exception.reason]];
            }
            if (filter != nil && filter.allKeys.count > 0) {
                for (NSString *key in filter) {
                    NSString *domain = key;
                    NSArray *paths = [filter objectForKey:domain];
                    if ([file.domain containsString:domain]) {
                        if (paths != nil && paths.count > 0) {
                            for (NSString *path in paths) {
                                if ([file.path containsString:path]) {
                                    [files addObject:file];
                                    break;
                                }
                            }
                            break;
                        } else {
                            [files addObject:file];
                            break;
                        }
                    }
                }
            } else {
                [files addObject:file];
            }
        }
    }
    return files;
}

- (NSMutableArray*)filterFiles:(NSArray*)fileList withFilter:(NSDictionary*)filter withWriteFolderPath:(NSString*)writeFolderPath {
    NSMutableArray *files = [[[NSMutableArray alloc] init] autorelease];
    for (FileL *file in fileList) {
        // Todo 检查本地对应下载文件夹中是否已经下载有了该文件，如果没有就添加到下载列表中，否则就跳过
        NSString *localFilePtah = @"";
        @autoreleasepool {
            NSString *fileName = [NSString stringToHex:(uint8_t*)(file.fileName.bytes) length:(int)file.fileName.length];
            localFilePtah = [[writeFolderPath stringByAppendingPathComponent:fileName] retain];
        }
        if ([fm fileExistsAtPath:localFilePtah]) {
            if (localFilePtah != nil) {
                [localFilePtah release];
                localFilePtah = nil;
            }
            continue;
        }
        if (localFilePtah != nil) {
            [localFilePtah release];
            localFilePtah = nil;
        }
        if (filter != nil && filter.allKeys.count > 0) {
            for (NSString *key in filter) {
                NSString *domain = key;
                NSArray *paths = [filter objectForKey:domain];
                if ([file.domain containsString:domain]) {
                    if (paths != nil && paths.count > 0) {
                        for (NSString *path in paths) {
                            if ([file.path containsString:path]) {
                                [files addObject:file];
                                break;
                            }
                        }
                        break;
                    } else {
                        [files addObject:file];
                        break;
                    }
                }
            }
        } else {
            [files addObject:file];
        }
    }
    return files;
}

- (NSMutableArray*)parseAuthChunk:(NSData*)getFilesResponse {
    NSMutableArray *resps = [[[NSMutableArray alloc] init] autorelease];
    PBCodedInputStream *authCis = [PBCodedInputStream streamWithData:getFilesResponse];
    
    for (int i = 0; ![authCis isAtEnd]; i++) {
        int len = [authCis readRawVarint32];
        AuthChunkL *ac = nil;
        @try {
            ac = [AuthChunkL parseFromData:[authCis readRawData:len]];
        }
        @catch (NSException *exception) {
            [_logManager writeInfoLog:[NSString stringWithFormat:@"exception reason(AuthChunk):%@",exception.reason]];
        }
        [resps addObject:ac];
    }
    return resps;
}

- (NSData *)buildGetFiles:(NSArray*)files {
    NSData *retData = nil;
    NSOutputStream *memoryStream = [NSOutputStream outputStreamToMemory];
    [memoryStream open];
    PBCodedOutputStream *oust = [PBCodedOutputStream streamWithOutputStream:memoryStream];
    if (_filesDic != nil) {
        [_filesDic release];
        _filesDic = nil;
    }
    _filesDic = [[NSMutableDictionary alloc] init];
    for (FileL *f in files) {
        if (f == nil || [f fileSize] == 0) {
            continue;
        }
        GetFilesL_Builder *getFilesBuild = [GetFilesL builder];
        [getFilesBuild setHash:f.fileName];
        GetFilesL *getFiles = [getFilesBuild build];
        [oust writeRawVarint32:getFiles.serializedSize];
        [getFiles writeToCodedOutputStream:oust];
        [_filesDic setObject:f forKey:f.altFileName];
    }
    [oust flush];
    [memoryStream close];
    retData = [memoryStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    return retData;
}

- (NSMutableDictionary*)buildHashDictionary:(NSArray*)files {
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    for (FileL *sauce in files) {
        [dict setObject:sauce.altFileName forKey:sauce.fileName];
    }
    return dict;
}

- (IMBKeyValuePair*)buildAuthorizeGetA:(NSArray*)auch withHashDict:(NSDictionary*)hashDict {
    FileAuthL_Builder *builder = [FileAuthL builder];
    for (AuthChunkL *ac in auch) {
        AuthChunkL_Builder *subBuilder = [AuthChunkL builder];
        [subBuilder setAuthToken:ac.authToken];
        [subBuilder setChecksum:[hashDict objectForKey:[ac checksum]]];
        [builder addMain:[subBuilder build]];
    }
    
    AuthChunkL *fac = [auch objectAtIndex:0];
    NSData *altFileNameData = [hashDict objectForKey:[fac checksum]];
    return [[[IMBKeyValuePair alloc] initWithKey:[NSString stringWithFormat:@"%@ %@", [NSString stringToHex:(uint8_t*)(altFileNameData.bytes) length:(int)altFileNameData.length], [fac authToken]] withValue:[builder build]] autorelease];
}

- (NSArray*)buildAuthorizeGet:(NSArray*)auch withHashDict:(NSDictionary*)hashDict {
    NSMutableArray *outPut = [[[NSMutableArray alloc] init] autorelease];
    for (AuthChunkL *ac in auch) {
        FileAuthL_Builder *builder = [FileAuthL builder];
        AuthChunkL_Builder *subBuilder = [AuthChunkL builder];
        [subBuilder setAuthToken:ac.authToken];
        [subBuilder setChecksum:[hashDict objectForKey:[ac checksum]]];
        [builder addMain:[subBuilder build]];
        IMBKeyValuePair *item = [[IMBKeyValuePair alloc] initWithKey:[NSString stringWithFormat:@"%@ %@", [NSString stringToHex:(uint8_t*)ac.checksum.bytes length:(int)ac.checksum.length], [ac authToken]] withValue:[builder build]];
        [outPut addObject:item];
        [item release];
        item = nil;
    }
    return outPut;
}

- (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)compareWithData:(NSData*)data1 withData:(NSData*)data2 {
    if (data1.length != data2.length) {
        return NO;
    }
    if (data1 == nil || data2 == nil) {
        return NO;
    }
    Byte *b1 = (Byte*)data1.bytes;
    Byte *b2 = (Byte*)data2.bytes;
    for (int i = 0; i < data1.length; i++) {
        if (b1[i] != b2[i]) {
            return NO;
        }
    }
    return YES;
}

@end

@implementation IMBKeyValuePair
@synthesize key = _key;
@synthesize value = _value;

- (id)initWithKey:(id)k withValue:(id)v {
    self = [super init];
    if (self) {
        [self setKey:k];
        [self setValue:v];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end


