//
//  IMBExactDeviceDBFiles.h
//  iMobieTrans
//
//  Created by apple on 8/12/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"
#import "IMBLogManager.h"
#import "IMBFileSystem.h"

typedef enum {
    iTunesCDB,
    MediaLibrary,
    PhotoData,
    BooksType,
}ExtractType;

@interface IMBExtractDeviceDBFiles : NSObject{
    IMBiPod *_toIPod;
    NSString *_deviceName;
    ExtractType _extractType;
    NSString *_tmpFolder;
    NSMutableDictionary *_DBPaths;
    NSString *_nativeDbPath;
    BOOL _isMediaLibraryExist;
    IMBLogManager *_logHandle;
}

@property (nonatomic,retain) NSString *nativeDbPath;
@property (nonatomic,assign) BOOL isMediaLibraryExist;

- (id)initWithToIpod:(IMBiPod *)toIPod extractType:(ExtractType)extractType;
- (void)getDBFilePath;
- (void)startExtract;
- (BOOL)checkDeviceDBFile:(NSString *)path;
- (void)createLocalTempFolder;
- (void)copyFilesToTempFolder:(NSString *)folderpath;
- (BOOL)deleteTempFile:(NSString *)path;
- (long)getChildeFolder:(NSString *)folderPath;

@end
