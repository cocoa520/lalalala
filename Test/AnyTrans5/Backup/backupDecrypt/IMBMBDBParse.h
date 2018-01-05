//
//  IMBMdbdParse.h
//  TestPipeDemo
//
//  Created by Pallas on 4/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <malloc/malloc.h>
//#import "NSString+NSStringHexToBytes.h"
//#import "NSString+Compare.h"
#import "IMBBigEndianBitConverter.h"
//#import "IMBCommonDefine.h"
#import "MobileDeviceAccess.h"
#import "IMBUtilTool.h"
#import "FMDatabase.h"

typedef enum {
    FileType_Backup = 0,
    DirectoryType_Backup = 1,
    LinkType_Backup = 2,
} BackUpFileType;

@class IMBMBFileRecord;

@interface IMBMBDBParse : NSObject {
//@private
    NSMutableArray *_recordArray;
    NSMutableArray *_appArray;
    AMDevice *_device;
    NSFileManager *fm;
    
    NSString *_backupfilePath;
    NSString *_backupPath;
    NSString *_iosVersion;
}

@property (nonatomic, readwrite, retain) NSMutableArray *recordArray;
@property (nonatomic, readwrite, retain) NSMutableArray *appArray;

@property (nonatomic, readwrite, retain) AMDevice *device;

- (id)initWithAMDevice:(AMDevice*)dev withbackupfilePath:(NSString *)backupfilePath;
- (id)initWithPath:(NSString *)backupPath withIosVersion:(NSString *)iosVersion;

- (BOOL)readMBDB:(NSString*)folderPath;
- (BOOL)parseManifest;
- (BOOL)saveMBDB:(NSArray*)recordsArray cacheFilePath:(NSString *)cacheFilePath backupFolderPath:(NSString*)backupFolderPath;
//- (void)backFileToBackupFolder:(NSString*)backupFolder;
- (void)copyBackFilesToBackupFolder:(NSString*)filePath mbfileRecord:(IMBMBFileRecord *)mbfileRecord backupFolderPath:(NSString *)backupFolderPath;
// 得到备份文件中的单个文件记录
- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path;
- (void)setIosVersion:(NSString *)iosVersion;
@end

#define MASK_SYMBOLIC_LINK 0xa000
#define MASK_REGULAR_FILE 0x8000
#define MASK_DIRECTORY 0x4000

@interface IMBMBFileRecord : NSObject {
@private
    NSString *_key;                 // filename in the backup directory: SHA.1 of Domain + "-" + Path
    NSString *_domain;
    NSString *_path;
    NSString *_linkTarget;
    NSString *_dataHash;            // SHA.1 for 'important' files
    NSData *_encryptionKey;
    
    NSString *_data;                // the 40-byte block (some fields still need to be explained)
    
    ushort _mode;                   // 4xxx=dir, 8xxx=file, Axxx=symlink
    int _alwaysZero;
    uint _inode;                    // without any doubt
    uint _userId;                   // 501/501 for apps
    uint _groupId;
    NSDate *_aTime;                 // aTime or bTime is the former ModificationTime
    NSDate *_bTime;
    NSDate *_cTime;
    int64_t _aTimeInterval;
    int64_t _bTimeInterval;
    int64_t _cTimeInterval;
    int64_t _fileLength;            // always 0 for link or directory
    Byte _protectionClass;          // 0 for link, 4 for directory, otherwise values unknown (4 3 1)
    Byte _propertyCount;
    
    NSArray *_properties;           // Property object
    BackUpFileType _filetype;
    
    
    NSString *_localPath; //本地图片缓存路径
    
    //iOS10 相对路径
    NSString *_relativePath;
}
@property (nonatomic,assign)int64_t aTimeInterval;
@property (nonatomic,assign)int64_t bTimeInterval;
@property (nonatomic,assign)int64_t cTimeInterval;
@property (nonatomic,retain) NSString *relativePath;
@property (nonatomic, readwrite, retain) NSString *key;
@property (nonatomic, readwrite, retain) NSString *domain;
@property (nonatomic, readwrite, retain) NSString *path;
@property (nonatomic, readwrite, retain) NSString *linkTarget;
@property (nonatomic, readwrite, retain) NSString *dataHash;
@property (nonatomic, readwrite, retain) NSData *encryptionKey;
@property (nonatomic, readwrite, retain) NSString *data;
@property (nonatomic, readwrite, retain) NSString *localPath;

@property (assign) BackUpFileType filetype;
@property ushort mode;
@property int alwaysZero;
@property uint inode;
@property uint userId;
@property uint groupId;
@property (nonatomic, readwrite, retain) NSDate *aTime;
@property (nonatomic, readwrite, retain) NSDate *bTime;
@property (nonatomic, readwrite, retain) NSDate *cTime;
@property (nonatomic, getter = fileLength, setter = setFileLength:, readwrite) int64_t fileLength;
@property Byte protectionClass;
@property Byte propertyCount;
@property (nonatomic, readwrite, retain) NSArray *properties;

- (int)type;

- (BOOL)is_symbolic_link;
- (BOOL)is_regular_file;
- (BOOL)is_directory;

- (int64_t)fileLength;
- (void)setFileLength:(int64_t)fileLength;

- (void)changeFileLength:(int64_t)fileLength;

@end

@interface IMBFileProperties : NSObject {
@private
    NSString *_name;
    NSString *_value;
}

@property (copy) NSString *name;
@property (copy) NSString *value;

@end

@interface IMBiPhoneApp : NSObject {
@private
    NSString *_key;
    NSString *_displayName;                 // CFBundleDisplayName
    NSString *_name;                        // CFBundleName
    NSString *_identifier;                  // CFBundleIdentifier
    NSString *_container;                   // le chemin d'install sur l'iPhone
    NSMutableArray *_files;
    long _filesLength;                      // taille totale des fichiers
}
@property (nonatomic, readwrite, retain) NSString *key;
@property (nonatomic, readwrite, retain) NSString *displayName;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *identifier;
@property (nonatomic, readwrite, retain) NSString *container;
@property (nonatomic, readwrite, retain) NSMutableArray *files;
@property long filesLength;

@end

@interface IMBAppFiles : NSObject {
@private
    NSMutableArray *_keyArray;
    long _filesLength;
}

@property (nonatomic, readwrite, retain) NSMutableArray *keyArray;
@property long filesLength;

- (void)addFile:(NSString*)key fileLength:(long)fileLenth;

@end