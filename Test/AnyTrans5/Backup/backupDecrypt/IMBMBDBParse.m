//
//  IMBMdbdParse.m
//  TestPipeDemo
//
//  Created by Pallas on 4/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBMBDBParse.h"
#import "IMBCommonEnum.h"
#import "TempHelper.h"
#import "NSString+Category.h"
#import "NSDictionary+Category.h"
#import "DateHelper.h"
#import "NSData+EncryptDecrypt.h"
@implementation IMBMBDBParse
@synthesize recordArray = _recordArray;
@synthesize appArray = _appArray;
@synthesize device   = _device;

- (id)init {
    self = [super init];
    if (self) {
        fm = [NSFileManager defaultManager];
    }
    return self;
}

+ (NSString *)getBackupFileFloatVersion:(NSString *)backupPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fileManager fileExistsAtPath:desfilePath]) {
        [fileManager removeItemAtPath:desfilePath error:nil];
    }
    [fileManager copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"%@",mpDic]];
    NSDictionary *lockDic  = [mpDic objectForKey:@"Lockdown"];
    NSString *productVersion = [lockDic objectForKey:@"ProductVersion"];
    NSString *versionstrone = nil;
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"%@",productVersion]];
    if (productVersion.length>=3) {
        NSRange range;
        NSString *str = [productVersion substringWithRange:NSMakeRange(2, 1)];
        if ([str isEqualToString:@"."]) {
            range.length = 4;
            range.location = 0;
        }else{
            range.length = 3;
            range.location = 0;
        }
        versionstrone = [productVersion substringWithRange:range];
        return versionstrone;
    }
    [[IMBLogManager singleton] writeInfoLog:@"version error"];
    return @"10.0";
}


- (id)initWithAMDevice:(AMDevice *)dev withbackupfilePath:(NSString *)backupfilePath  {
    self = [self init];
    if (self) {
        _device = [dev retain];
        _backupfilePath = [backupfilePath retain];
        _iosVersion = [[IMBMBDBParse getBackupFileFloatVersion:backupfilePath] retain];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"backupfilePath:%@\niOSVersion:%@",_backupfilePath,_iosVersion]];
       
    }
    return self;
}

- (id)initWithPath:(NSString *)backupPath withIosVersion:(NSString *)iosVersion {
    self = [self init];
    if (self) {
        _iosVersion = [iosVersion retain];
        _backupPath = [backupPath retain];
        _backupfilePath = [backupPath retain];
    }
    return self;
}

- (void)setIosVersion:(NSString *)iosVersion {
    if (_iosVersion != nil) {
        [_iosVersion release];
        _iosVersion = nil;
    }
    _iosVersion = [iosVersion retain];
}

- (void)dealloc {
    if (_iosVersion != nil) {
        [_iosVersion release];
        _iosVersion = nil;
    }
    if (_backupPath != nil) {
        [_backupPath release];
        _backupPath = nil;
    }
    
    if (_recordArray != nil) {
        [_recordArray release];
        _recordArray = nil;
    }
    
    if (_appArray != nil) {
        [_appArray release];
        _appArray = nil;
    }
    
    if (_device != nil) {
        [_device release];
        _device = nil;
    }
    
    if (_backupfilePath != nil) {
        [_backupfilePath release];
        _backupfilePath = nil;
    }
    
    [super dealloc];
}

- (BOOL)getAllApp:(NSString*)plistFilePath {
    _appArray = [[NSMutableArray alloc] init];
    NSDictionary *plDic = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
    IMBiPhoneApp *iphoneApp = nil;
    
    NSDictionary *appsdic = [plDic objectForKey:@"Applications"];
    if (appsdic == nil) {
        return NO;
    }
    
    // 去遍历所有的备份文件
    NSMutableDictionary *filesByDomain = [[NSMutableDictionary alloc] init];
    for (IMBMBFileRecord *fileRecord in _recordArray) {
//        if (([fileRecord mode] & 0xF000) == 0x8000) {
        if (fileRecord.filetype == FileType_Backup) {
            NSString *domain = [fileRecord domain];
            NSArray *fKeys = [filesByDomain allKeys];
            IMBAppFiles *appFiles = nil;
            if (![fKeys containsObject:domain]) {
                appFiles = [[IMBAppFiles alloc] init];
                [filesByDomain setValue:appFiles forKey:domain];
            } else {
                appFiles = [[filesByDomain valueForKey:domain] retain];
            }
            [appFiles addFile:[fileRecord key] fileLength:(long)[fileRecord fileLength]];
            [appFiles release];
        }
        
    }
    
    for (id appkey in appsdic) {
        NSDictionary *tempDic = [appsdic valueForKey:appkey];
        NSArray *appKeys = [tempDic allKeys];
        for (NSString *key in appKeys) {
            iphoneApp = [[IMBiPhoneApp alloc] init];
            [iphoneApp setKey:key];
//            NSDictionary *appDic = [tempDic valueForKey:key];
//            if (tempDic != nil) {
            if ([appKeys containsObject:@"CFBundleIdentifier"]) {
                [iphoneApp setIdentifier:[tempDic valueForKey:@"CFBundleIdentifier"]];
            } else {
                [iphoneApp setIdentifier:@""];
            }
            
            if ([appKeys containsObject:@"Path"]) {
                [iphoneApp setContainer:[tempDic valueForKey:@"Path"]];
            } else {
                [iphoneApp setContainer:@""];
            }
            
            NSArray *dKeys = [filesByDomain allKeys];
            NSString *appDomainKey = [@"AppDomain-" stringByAppendingString:[iphoneApp key]];
            if ([dKeys containsObject:appDomainKey]) {
                NSMutableArray *files = [[NSMutableArray alloc] init];
                IMBAppFiles *appFiles = [filesByDomain valueForKey:key];
                if (appFiles != nil) {
                    NSArray *tempArray = [appFiles keyArray];
                    for (NSString *item in tempArray) {
                        [files addObject:item];
                    }
                }
                [iphoneApp setFiles:files];
                [files release];
                
                
                [iphoneApp setFilesLength:(long)[[filesByDomain valueForKey:appDomainKey] fileLength]];
                [filesByDomain removeObjectForKey:appDomainKey];
            }
//            }
            [_appArray addObject:iphoneApp];
            [iphoneApp release];
        }
    }
    
    IMBiPhoneApp *system  = [[IMBiPhoneApp alloc] init];
    [system setKey:@"---"];
    [system setIdentifier:@"---"];
    [system setContainer:@"---"];
    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    long filesLength = 0;
    for (id key in filesByDomain) {
        IMBAppFiles *appFiles = [filesByDomain valueForKey:key];
        if (appFiles != nil) {
            NSArray *tempArray = [appFiles keyArray];
            for (NSString *item in tempArray) {
                [files addObject:item];
            }
            filesLength += [appFiles filesLength];
        }
    }
    [iphoneApp setFiles:files];
    [iphoneApp setFilesLength:filesLength];
    [files release];
    
    [_appArray addObject:system];
    [system release];
    
    [filesByDomain release];
    
    return YES;
}

- (BOOL)parseManifest {
    BOOL copySuccess = [self copyManifestToFolder:[TempHelper getAppTempPath]];
    if (copySuccess) {
        BOOL parseSuccess = [self readMBDB:[TempHelper getAppTempPath]];
        if (parseSuccess) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (BOOL)readMBDB:(NSString*)folderPath {
    if (_recordArray != nil) {
        [_recordArray release];
        _recordArray = nil;
    }
    _recordArray = [[NSMutableArray alloc] init];
    if ([_iosVersion isVersionMajorEqual:@"10"]) {
        [[IMBLogManager singleton] writeInfoLog:@"readIOSAboveDB"];
        return [self readIOSAboveDB:folderPath];
    }else {
        [[IMBLogManager singleton] writeInfoLog:@"readIOSBelowMBDB"];
        return [self readIOSBelowMBDB:folderPath];
    }
}

- (BOOL)readIOSBelowMBDB:(NSString *)folderPath {
    NSString *parseFilePath = [folderPath stringByAppendingPathComponent:@"Manifest.mbdb"];
    NSData *reader = [NSData dataWithContentsOfFile:parseFilePath];
    int64_t totalLength = [reader length];
    int64_t currPos = 0;
    int readLength = 0;
    Byte signature[6];
    Byte data[40];
    
    IMBMBFileRecord *fileRecord = nil;
    
    readLength = 6;
    [reader getBytes:signature range:NSMakeRange((int)currPos, readLength)];
    currPos += readLength;//currPos = 6
    
    //读取开头的6个字节
    
    NSString *signatureStr = [NSString stringToHex:signature length:6];
    // 比较取出的值是否为mbdb\5\0
    if (![[signatureStr lowercaseString] isEqualToString:[@"6D6264620500" lowercaseString]]) {
        NSLog(@"bad .mbdb file");
        [_recordArray release];
        _recordArray = nil;
        return NO;
    }
    
    while (currPos != totalLength) {
        fileRecord = [[IMBMBFileRecord alloc] init];
        [fileRecord setDomain:[self getStr:reader currPos:&currPos]];
        [fileRecord setPath:[self getStr:reader currPos:&currPos]];
        [fileRecord setLinkTarget:[self getStr:reader currPos:&currPos]];
        [fileRecord setDataHash:[self getDataHex:reader currPos:&currPos]];
        [fileRecord setEncryptionKey:[self getData:reader currPos:&currPos]];
        
        
        
        readLength = 40;
        [reader getBytes:data range:NSMakeRange((int)currPos, readLength)];
        currPos += readLength;
        [fileRecord setData:[NSString stringToHex:data length:readLength]];
        // 根据获取出来的data分析出所有的剩余数据
        
        //----------rec.AlwaysByte0, ref rec.AlwaysByte1, ref rec.AlwaysBytes---------
        
        
        //----------------------------------
        //从这里开始就是组成Data的属性
        int parsePos = 0;
        NSData *dataParse = [NSData dataWithBytes:data length:readLength];
        ushort mode = 0;
        readLength = sizeof(mode);
        
        Byte *modeByte = malloc(readLength);  //mode 2
        memset(modeByte, 0x00, readLength);
        [dataParse getBytes:modeByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        mode = [IMBBigEndianBitConverter bigEndianToUInt16:modeByte byteLength:readLength];
        [fileRecord setMode:mode];
        free(modeByte);
        [fileRecord setFiletype:[self recordType:fileRecord.mode]];
        
        int alwaysZero = 0;
        readLength = sizeof(alwaysZero);  //alwaysZero 4
        Byte *alwaysZeroByte = malloc(readLength);
        memset(alwaysZeroByte, 0x00, readLength);
        [dataParse getBytes:alwaysZeroByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        alwaysZero = [IMBBigEndianBitConverter bigEndianToInt32:alwaysZeroByte byteLength:readLength];
        [fileRecord setAlwaysZero:alwaysZero];
        free(alwaysZeroByte);
        
        uint32 inode = 0;
        readLength = sizeof(inode); //inode 4
        Byte *inodeByte = malloc(readLength);
        memset(inodeByte, 0x00, readLength);
        [dataParse getBytes:inodeByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        inode = [IMBBigEndianBitConverter bigEndianToUInt32:inodeByte byteLength:readLength];
        [fileRecord setInode:inode];
        free(inodeByte);
        
        uint32 userId = 0;
        readLength = sizeof(userId); //userId 4
        Byte *userIdByte = malloc(readLength);
        memset(userIdByte, 0x00, readLength);
        [dataParse getBytes:userIdByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        userId = [IMBBigEndianBitConverter bigEndianToUInt32:userIdByte byteLength:readLength];
        [fileRecord setUserId:userId];
        free(userIdByte);
        
        uint32 groupId = 0;
        readLength = sizeof(groupId);//groupId 4
        Byte *groupIdByte = malloc(readLength);
        memset(groupIdByte, 0x00, readLength);
        [dataParse getBytes:groupIdByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        groupId = [IMBBigEndianBitConverter bigEndianToUInt32:groupIdByte byteLength:readLength];
        [fileRecord setGroupId:groupId];
        free(groupIdByte);
        
        uint32 atime = 0;//atime 4
        readLength = sizeof(atime);
        Byte *atimeByte = malloc(readLength);
        memset(atimeByte, 0x00, readLength);
        [dataParse getBytes:atimeByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        atime = [IMBBigEndianBitConverter bigEndianToUInt32:atimeByte byteLength:readLength];
        [fileRecord setATime:[self getDateTimeFromTimeStamp1970:atime]];
        free(atimeByte);
        
        uint32 btime = 0;//btime 4
        readLength = sizeof(btime);
        Byte *btimeByte = malloc(readLength);
        memset(btimeByte, 0x00, readLength);
        [dataParse getBytes:btimeByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        btime = [IMBBigEndianBitConverter bigEndianToUInt32:btimeByte byteLength:readLength];
        [fileRecord setBTime:[self getDateTimeFromTimeStamp1970:btime]];
        free(btimeByte);
        
        uint32 ctime = 0;
        readLength = sizeof(ctime);//ctime 4

        Byte *ctimeByte = malloc(readLength);
        memset(ctimeByte, 0x00, readLength);
        [dataParse getBytes:ctimeByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        ctime = [IMBBigEndianBitConverter bigEndianToUInt32:ctimeByte byteLength:readLength];
        [fileRecord setCTime:[self getDateTimeFromTimeStamp1970:ctime]];
        free(ctimeByte);
        //--------------------------------------
        

        
        int64_t fileLength = 0;
        readLength = sizeof(fileLength); // 8
        Byte *fileLengthByte = malloc(readLength);
        memset(fileLengthByte, 0x00, fileLength);
        [dataParse getBytes:fileLengthByte range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        fileLength = [IMBBigEndianBitConverter bigEndianToInt64:fileLengthByte byteLength:readLength];
        [fileRecord setFileLength:fileLength];
        free(fileLengthByte);
        
        //------------rec.flag = rec.flagbyte[0];
        
        Byte protectionClass;
        readLength = sizeof(protectionClass);
        [dataParse getBytes:&protectionClass range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        [fileRecord setProtectionClass:protectionClass];
        
        Byte propertyCount;
        readLength = sizeof(propertyCount);
        [dataParse getBytes:&propertyCount range:NSMakeRange(parsePos, readLength)];
        parsePos += readLength;
        [fileRecord setPropertyCount:propertyCount];
        
        NSMutableArray *properties = [[NSMutableArray alloc] init];
        IMBFileProperties *filePropertie = nil;
        for (int i = 0; i < propertyCount; i++) {
            filePropertie = [[IMBFileProperties alloc] init];
            [filePropertie setName:[self getStr:reader currPos:&currPos]];
            [filePropertie setValue:[self getDataHex:reader currPos:&currPos]];
            [properties addObject:filePropertie];
            [filePropertie release];
        }
        [fileRecord setProperties:properties];
        [properties release];
        
        //-----------------------------
        
        uint8_t hash[20] = { 0x00 };
        NSString *fileName = nil;
        NSString *temp = [[[fileRecord domain] stringByAppendingString:@"-"] stringByAppendingString:[fileRecord path]];
        const char *buf = [temp UTF8String];
        int len = (int)strlen(buf);
        CC_SHA1_CTX content;
        CC_SHA1_Init(&content);
        CC_SHA1_Update(&content, buf, len);
        CC_SHA1_Final(hash, &content);
        fileName = [[NSString stringToHex:hash length:CC_SHA1_DIGEST_LENGTH] lowercaseString];
        [fileRecord setKey:fileName];
        [_recordArray addObject:fileRecord];
        [fileRecord release];
        fileRecord = nil;
    }
//    [self getAllApp:[folderPath stringByAppendingPathComponent:@"Manifest.plist"]];
    return YES;
}

- (BOOL)readIOSAboveDB:(NSString *)folderPath {
    NSString *parseFilePath = [folderPath stringByAppendingPathComponent:@"Manifest.db"];
    if ([fm fileExistsAtPath:parseFilePath]) {
        [[IMBLogManager singleton] writeInfoLog:@"Manifest.db exsited"];
        FMDatabase *fmDB = [[FMDatabase databaseWithPath:parseFilePath] retain];
        if ([fmDB open]) {
            FMResultSet *rs =[fmDB executeQuery:@"SELECT * FROM Files"];
            while ([rs next]) {
                @autoreleasepool {
                    IMBMBFileRecord *fileRecord = [[IMBMBFileRecord alloc] init];
                    if (![rs columnIsNull:@"fileID"]) {
                        NSString *key = [rs stringForColumn:@"fileID"];
                        [fileRecord setKey:key];
                    }
                    if (![rs columnIsNull:@"domain"]) {
                        [fileRecord setDomain:[rs stringForColumn:@"domain"]];
                    }
                    if (![rs columnIsNull:@"relativePath"]) {
                        [fileRecord setPath:[rs stringForColumn:@"relativePath"]];
                    }
                    
                    if (![rs columnIsNull:@"file"]) {
                        NSData *data = [rs dataForColumn:@"file"];
                        NSDictionary *fileDic = [NSDictionary dictionaryFromData:data];
                        if ([fileDic.allKeys containsObject:@"$objects"]) {
                            id resultobj = [fileDic objectForKey:@"$objects"];
                            if ([resultobj isKindOfClass:[NSArray class]]) {
                                for (id item in resultobj) {
                                    if ([item isKindOfClass:[NSDictionary class]]) {
                                        NSDictionary *oDIC = (NSDictionary *)item;
                                        if ([oDIC.allKeys containsObject:@"Digest"]) {
                                            NSKeyedArchiver *digest = [oDIC objectForKey:@"Digest"];
                                            int value = [self valueForKeyedArchiverUID:digest];
                                            
                                            if ([(NSArray *)resultobj count] > value) {
                                                NSData *digestData = [(NSArray *)resultobj objectAtIndex:value];
                                                if (digestData != nil&&[digestData isKindOfClass:[NSData class]]) {
                                                    fileRecord.dataHash = [[digestData hexString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                                }
                                            }
                                        }
                                        if ([oDIC.allKeys containsObject:@"EncryptionKey"]) {
                                            NSKeyedArchiver *encryptionKey = [oDIC objectForKey:@"EncryptionKey"];
                                            int value = [self valueForKeyedArchiverUID:encryptionKey];
                                            if ([(NSArray *)resultobj count] > value) {
                                                NSDictionary *keyDic = [(NSArray *)resultobj objectAtIndex:value];
                                                if ([keyDic isKindOfClass:[NSDictionary class]]) {
                                                    if ([keyDic.allKeys containsObject:@"NS.data"]) {
                                                        fileRecord.encryptionKey = [keyDic objectForKey:@"NS.data"];
                                                    }
                                                }
                                            }
                                            
                                        }
                                        if ([oDIC.allKeys containsObject:@"Size"]) {
                                            fileRecord.fileLength = [[item objectForKey:@"Size"] longLongValue];
                                        }
                                        if ([oDIC.allKeys containsObject:@"Birth"]) {
                                            fileRecord.aTimeInterval = [[item objectForKey:@"Birth"] longLongValue];
                                            fileRecord.aTime = [DateHelper dateFrom1970:fileRecord.aTimeInterval];
                                            
                                        }
                                        if ([oDIC.allKeys containsObject:@"LastModified"]) {
                                            fileRecord.bTimeInterval = [[item objectForKey:@"LastModified"] longLongValue];
                                            fileRecord.bTime = [DateHelper dateFrom1970:fileRecord.bTimeInterval];
                                        }
                                        if ([oDIC.allKeys containsObject:@"LastStatusChange"]) {
                                            fileRecord.cTimeInterval = [[item objectForKey:@"LastStatusChange"] longLongValue];
                                            fileRecord.cTime = [DateHelper dateFrom1970:fileRecord.cTimeInterval];
                                        }
                                        if ([oDIC.allKeys containsObject:@"GroupID"]) {
                                            fileRecord.groupId = [[item objectForKey:@"GroupID"] intValue];
                                        }
                                        if ([oDIC.allKeys containsObject:@"UserID"]) {
                                            fileRecord.userId = [[item objectForKey:@"UserID"] intValue];
                                            
                                        }
                                        if ([oDIC.allKeys containsObject:@"InodeNumber"]) {
                                            fileRecord.inode = [[item objectForKey:@"InodeNumber"] intValue];
                                        }
                                        if ([oDIC.allKeys containsObject:@"Mode"]) {
                                            fileRecord.mode = [[item objectForKey:@"Mode"] intValue];
                                        }
                                        if ([oDIC.allKeys containsObject:@"ProtectionClass"]) {
                                            fileRecord.alwaysZero = 0;
                                            int protectionClass = [[item objectForKey:@"ProtectionClass"] intValue];
                                            Byte byte[1];
                                            byte[0] = (Byte)protectionClass;
                                            fileRecord.protectionClass = (Byte)byte[0];
                                            
                                            Byte byte1[1];
                                            byte1[0] = (Byte)0;
                                            fileRecord.propertyCount = (Byte)byte1[0];
                                            
                                            NSMutableData *listData = [NSMutableData data];
                                            uint_16.ui16 = fileRecord.mode;
                                            Byte modeByte[2];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(modeByte, uint_16.c, 2);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:modeByte offset:0 count:2];
                                                [listData appendBytes:reverseByte length:2];
                                            } else {
                                                memcpy(modeByte, uint_16.c, 2);
                                                [listData appendBytes:modeByte length:2];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.alwaysZero;
                                            Byte alwaysZeroByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(alwaysZeroByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:alwaysZeroByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(alwaysZeroByte, uint_32.c, 4);
                                                [listData appendBytes:alwaysZeroByte length:4];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.inode;
                                            Byte inodeByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(inodeByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:inodeByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(inodeByte, uint_32.c, 4);
                                                [listData appendBytes:inodeByte length:4];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.userId;
                                            Byte useridByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(useridByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:useridByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(useridByte, uint_32.c, 4);
                                                [listData appendBytes:useridByte length:4];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.groupId;
                                            Byte groupIdByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(groupIdByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:groupIdByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(groupIdByte, uint_32.c, 4);
                                                [listData appendBytes:groupIdByte length:4];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.aTimeInterval;
                                            Byte atimeByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(atimeByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:atimeByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(atimeByte, uint_32.c, 4);
                                                [listData appendBytes:atimeByte length:4];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.bTimeInterval;
                                            Byte btimeByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(btimeByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:btimeByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(btimeByte, uint_32.c, 4);
                                                [listData appendBytes:btimeByte length:4];
                                            }
                                            
                                            uint_32.ui32 = fileRecord.cTimeInterval;
                                            Byte ctimeByte[4];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(ctimeByte, uint_32.c, 4);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:ctimeByte offset:0 count:4];
                                                [listData appendBytes:reverseByte length:4];
                                            } else {
                                                memcpy(ctimeByte, uint_32.c, 4);
                                                [listData appendBytes:ctimeByte length:4];
                                            }
                                            
                                            int_64.i64 = fileRecord.fileLength;
                                            Byte fileSizeByte[8];
                                            if ([IMBBigEndianBitConverter isLitte_Endian]) {
                                                memcpy(fileSizeByte, int_64.c, 8);
                                                Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:fileSizeByte offset:0 count:8];
                                                [listData appendBytes:reverseByte length:8];
                                            } else {
                                                memcpy(fileSizeByte, int_64.c, 8);
                                                [listData appendBytes:fileSizeByte length:8];
                                            }
                                            [listData appendBytes:byte length:1];
                                            [listData appendBytes:byte1 length:1];
                                            [fileRecord setData:[NSString stringToHex:[listData bytes] length:(int)[listData length]]];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (![rs columnIsNull:@"flags"]) {
                        int flag = [rs intForColumn:@"flags"];
                        if (flag == 1) {
                            [fileRecord setMode:33152];
                        }else if (flag == 2) {
                            [fileRecord setMode:16877];
                        }else {
                            [fileRecord setMode:41453];
                        }
                        [fileRecord setFiletype:[self recordType:flag]];
                    }
                    [_recordArray addObject:fileRecord];
                    [fileRecord release];
                    fileRecord = nil;
                }
            }
            [rs close];
            [fmDB close];
            [fmDB release];
        }
    }else {
        [[IMBLogManager singleton] writeInfoLog:@"Manifest.db isn't exsited"];
        NSLog(@"Manifest.db file isn't exist");
        return NO;
    }
//    [self getAllApp:[folderPath stringByAppendingPathComponent:@"Manifest.plist"]];
    return YES;
}

- (uint32_t)valueForKeyedArchiverUID: (id)keyedArchiverUID {
    void *uid = (__bridge void*)keyedArchiverUID;
    uint32_t *valuePtr = uid+16;
    return *valuePtr;
}

//将备份文件中的manifest.mbdb文件拷贝到指定的目录下，解析时需要这样做
- (BOOL)copyManifestToFolder:(NSString *)folderPath {
    NSString *sourceManifestPath = [_backupfilePath stringByAppendingPathComponent:@"Manifest.mbdb"];
    if ([_iosVersion isVersionMajorEqual:@"10"]) {
        sourceManifestPath = [_backupfilePath stringByAppendingPathComponent:@"Manifest.db"];
    }
    if ([fm fileExistsAtPath:sourceManifestPath]) {
        NSString *desManifestPath = [folderPath stringByAppendingPathComponent:@"Manifest.mbdb"];
        if ([_iosVersion isVersionMajorEqual:@"10"]) {
            desManifestPath = [folderPath stringByAppendingPathComponent:@"Manifest.db"];
        }
        if ([fm fileExistsAtPath:desManifestPath] ) {
            [fm removeItemAtPath:desManifestPath error:nil];
        }
        [fm copyItemAtPath:sourceManifestPath toPath:desManifestPath error:nil];
        return YES;
    } else {
        //NSLog(@"你还没有备份，先备份");
        return NO;
    }
}


// todo 将联系人 备忘录 日历 书签的备份数据文件全部拷贝到对应的备份目录中去
//- (void)backFileToBackupFolder:(NSString*)backupFolder {
//    return;
//}

// todo 将需要还原的数据拷贝回需要还原的备份目录中去
// filePath为要拷贝进备份文件夹的路径,mbfileRecord为记录文件的实例类,backupFolderPath为备份的文件夹
- (void)copyBackFilesToBackupFolder:(NSString*)filePath mbfileRecord:(IMBMBFileRecord *)mbfileRecord backupFolderPath:(NSString *)backupFolderPath {
    NSMutableArray *fileRecords = [[self recordArray] retain];
    if (fileRecords != nil && [fileRecords count] > 0) {
        // 拷贝文件并进行datahash计算
        if (mbfileRecord != nil) {
            NSString *targetFilePath = [backupFolderPath stringByAppendingPathComponent:[mbfileRecord key]];
            if (![TempHelper stringIsNilOrEmpty:filePath] && ![filePath isEqualToString:targetFilePath]) {
                if ([fm fileExistsAtPath:targetFilePath]) {
                    [fm removeItemAtPath:targetFilePath error:nil];
                }
                
                [fm copyItemAtPath:filePath toPath:targetFilePath error:nil];
            }
            
            // 得到文件的大小并进行赋值
            int64_t fileSize = [IMBUtilTool fileSizeAtPath:targetFilePath];
            [mbfileRecord changeFileLength:fileSize];
            
            // 计算hash的值并赋与DataHash
            uint8_t hash[20] = { 0x00 };
            NSData *cont = [NSData dataWithContentsOfFile:targetFilePath];
            const char *buf = [cont bytes];
            long len = cont.length;
            CC_SHA1_CTX content;
            CC_SHA1_Init(&content);
            CC_SHA1_Update(&content, buf, (int)len);
            CC_SHA1_Final(hash, &content);
            NSString *dataHashStr = [NSString stringToHex:hash length:CC_SHA1_DIGEST_LENGTH];
            [mbfileRecord setDataHash:dataHashStr];
        }
    }
    [fileRecords release];
}

- (NSDate*)getDateTimeFromTimeStamp1970:(uint)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *returnDate = nil;
    NSDate *originDate = [dateFormatter dateFromString:@"1970-01-01 08:00:00"];
    returnDate = [[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate];
    [dateFormatter release];
    return [returnDate autorelease];
}

- (NSString *)getStr:(NSData*)reader currPos:(int64_t*)currPos {
    int dataLength = 0;
    Byte b0, b1;
    [reader getBytes:&b0 range:NSMakeRange((int)*currPos, 1)];
    *currPos = *currPos + 1;
    [reader getBytes:&b1 range:NSMakeRange((int)*currPos, 1)];
    *currPos = *currPos + 1;
    if ((int)b0 == 255 && (int)b1 == 255) {
        return nil;
    }
    dataLength = (int)b0 * 256 + (int)b1;
    
    NSString *resStr = nil;
    Byte *byteData = (Byte*)malloc(dataLength + 1);
    memset(byteData, 0, malloc_size(byteData));
    [reader getBytes:byteData range:NSMakeRange((int)*currPos, dataLength)];
    resStr = [NSString stringWithCString:(char*)byteData encoding:NSUTF8StringEncoding];
    *currPos = *currPos + dataLength;
    free(byteData);
    return resStr;
}

- (NSString *)getDataHex:(NSData*)reader currPos:(int64_t*)currPos {
    int dataLength = 0;
    Byte b0, b1;
    [reader getBytes:&b0 range:NSMakeRange((int)*currPos, 1)];
    *currPos = *currPos + 1;
    [reader getBytes:&b1 range:NSMakeRange((int)*currPos, 1)];
    *currPos = *currPos + 1;
    if ((int)b0 == 255 && (int)b1 == 255) {
        return nil;
    }
    dataLength = (int)b0 * 256 + (int)b1;
    
    NSString *resStr = nil;
    Byte *byteData = (Byte*)malloc(dataLength + 1);
    memset(byteData, 0, malloc_size(byteData));
    [reader getBytes:byteData range:NSMakeRange((int)*currPos, dataLength)];
    resStr = [NSString stringToHex:byteData length:dataLength];
    *currPos = *currPos + dataLength;
    free(byteData);
    return resStr;
}

- (NSMutableData *)getData:(NSData*)reader currPos:(int64_t*)currPos {
    int dataLength = 0;
    Byte b0, b1;
    [reader getBytes:&b0 range:NSMakeRange((int)*currPos, 1)];
    *currPos = *currPos + 1;
    [reader getBytes:&b1 range:NSMakeRange((int)*currPos, 1)];
    *currPos = *currPos + 1;
    if ((int)b0 == 255 && (int)b1 == 255) {
        return nil;
    }
    dataLength = (int)b0 * 256 + (int)b1;
    
    Byte *byteData = (Byte*)malloc(dataLength + 1);
    memset(byteData, 0, malloc_size(byteData));
    [reader getBytes:byteData range:NSMakeRange((int)*currPos, dataLength)];
    NSMutableData *outdata = [NSMutableData dataWithBytes:byteData length:dataLength];
    *currPos = *currPos + dataLength;
    free(byteData);
    return outdata;
}

// 将修改号了的Manifest文件保存到备份文件中去,recordsArray修改后的记录,cacheFilePath文件写入的缓存的路径,backupFolderPath备份的文件夹下面
- (BOOL)saveMBDB:(NSArray*)recordsArray cacheFilePath:(NSString *)cacheFilePath backupFolderPath:(NSString*)backupFolderPath {
    //[[IMBHelper getBackupCacheFolder] stringByAppendingPathComponent:@"Manifest.mbdb"];
    NSString *cacheMBDBFilePath = cacheFilePath;
    NSMutableData *writer = [[NSMutableData alloc] init];
    if (recordsArray != nil && [recordsArray count] > 0) {
        NSData *sigData = [@"6D6264620500" hexToBytes];
        [writer appendData:sigData];
        for (IMBMBFileRecord *fileRecord in recordsArray) {
            [self writeStr:writer str:[fileRecord domain]];
            [self writeStr:writer str:[fileRecord path]];
            [self writeStr:writer str:[fileRecord linkTarget]];
            [self writeDataHex:writer hexStr:[fileRecord dataHash]]; //
            [self writeData:writer withData:[fileRecord encryptionKey]]; //
            //------40 字节----
            NSData *lpdata = [[fileRecord data] hexToBytes];
            if (lpdata != nil) {
                [writer appendData:lpdata];
            }
            
            //--------
            
            NSArray *properties = [[fileRecord properties] retain];
            
            
            if (properties != nil && [properties count] > 0) {
                for (IMBFileProperties *filePropertie in properties) {
                    [self writeStr:writer str:[filePropertie name]];
                    [self writeDataHex:writer hexStr:[filePropertie value]];
                }
            }
            [properties release];
        }
    }
    [writer writeToFile:cacheMBDBFilePath atomically:YES];
    [writer release];
    
    if ([fm fileExistsAtPath:cacheMBDBFilePath] && [IMBUtilTool fileSizeAtPath:cacheMBDBFilePath] > 0) {
        NSString *targetFilePath = [backupFolderPath stringByAppendingPathComponent:@"Manifest.mbdb"];
        if ([fm fileExistsAtPath:targetFilePath]) {
            [fm removeItemAtPath:targetFilePath error:nil];
        }
        [fm copyItemAtPath:cacheMBDBFilePath toPath:targetFilePath error:nil];
    }
    return YES;
}

- (void)writeStr:(NSMutableData*)writer str:(NSString*)str {
    int dataLength = 0;
    Byte b0, b1;
    if (str == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

- (void)writeDataHex:(NSMutableData*)writer hexStr:(NSString*)hexStr {
    int dataLength = 0;
    Byte b0, b1;
    if (hexStr == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        NSData *data = [hexStr hexToBytes];
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

- (void)writeData:(NSMutableData*)writer withData:(NSData*)data {
    int dataLength = 0;
    Byte b0, b1;
    if (data == nil) {
        b0 = (Byte)255;
        b1 = (Byte)255;
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
    } else {
        dataLength = (int)[data length];
        b0 = (Byte)(dataLength / 256);
        b1 = (Byte)(dataLength % 256);
        [writer appendBytes:&b0 length:1];
        [writer appendBytes:&b1 length:1];
        [writer appendData:data];
    }
}

- (BackUpFileType)recordType:(ushort)mode {
    if ([_iosVersion isVersionMajorEqual:@"10"]) {
        if (mode == 1) {
            return FileType_Backup;
        }else if (mode == 2) {
            return DirectoryType_Backup;
        }
    }else {
        int type = mode & 0xf000;
        if (type == MASK_SYMBOLIC_LINK) {
            return LinkType_Backup;
        }
        
        if (type == MASK_REGULAR_FILE) {
            return FileType_Backup;
        }
        
        if (type == MASK_DIRECTORY) {
            return DirectoryType_Backup;
        }
    }
    return 5;
}

// 得到备份文件中的单个文件记录
- (IMBMBFileRecord *)getDBFileRecord:(NSString *)domainName path:(NSString *)path {
    IMBMBFileRecord *SMSDBFileItem = nil;
    if (_recordArray != nil && [_recordArray count] > 0) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBMBFileRecord *item = (IMBMBFileRecord *)evaluatedObject;
            if ([[item domain] isEqualToString:domainName] && [[item path] rangeOfString:path].length > 0) {
                return YES;
            } else {
                return NO;
            }
        }];
        
        NSArray *preArray = [_recordArray filteredArrayUsingPredicate:pre];
        if (preArray != nil && [preArray count] > 0) {
            SMSDBFileItem = [preArray objectAtIndex:0];
        }
    }
    return SMSDBFileItem;
}

@end

@implementation IMBMBFileRecord
@synthesize key = _key;
@synthesize relativePath = _relativePath;
@synthesize domain = _domain;
@synthesize path = _path;
@synthesize linkTarget = _linkTarget;
@synthesize dataHash = _dataHash;
@synthesize encryptionKey = _encryptionKey;
@synthesize data = _data;

@synthesize mode = _mode;
@synthesize alwaysZero = _alwaysZero;
@synthesize inode = _inode;
@synthesize userId = _userId;
@synthesize groupId = _groupId;
@synthesize aTime = _aTime;
@synthesize bTime = _bTime;
@synthesize cTime = _cTime;
@synthesize filetype = _filetype;
@synthesize protectionClass = _protectionClass;
@synthesize propertyCount = _propertyCount;

@synthesize properties = _properties;
@synthesize aTimeInterval = _aTimeInterval;
@synthesize bTimeInterval = _bTimeInterval;
@synthesize cTimeInterval = _cTimeInterval;
@synthesize localPath = _localPath;

- (int)type {
    return self.mode & 0xf000;
}

- (BOOL)is_symbolic_link {
    return self.type == MASK_SYMBOLIC_LINK;
}

- (BOOL)is_regular_file {
    return self.type == MASK_REGULAR_FILE;
}

- (BOOL)is_directory {
    return self.type == MASK_DIRECTORY;
}

- (int64_t)fileLength {
    return _fileLength;
}

- (void)setFileLength:(int64_t)fileLength {
    if (_fileLength != fileLength) {
        _fileLength = fileLength;
    }
}

- (void)changeFileLength:(int64_t)fileLength {
    [self setFileLength:fileLength];
    NSMutableData *data = [NSMutableData dataWithData:[_data hexToBytes]];
    int_64.i64 = fileLength;
    if ([IMBBigEndianBitConverter isLitte_Endian]) {
        int length = sizeof(fileLength);
        Byte fileLengthByte[length];
        memcpy(fileLengthByte, int_64.c, length);
        Byte *reverseByte = [IMBBigEndianBitConverter reverseBytes:fileLengthByte offset:0 count:length];
        [data replaceBytesInRange:NSMakeRange(30, 8) withBytes:reverseByte];
        free(reverseByte);
    } else {
        int length = sizeof(fileLength);
        Byte fileLengthByte[length];
        memcpy(fileLengthByte, int_64.c, length);
        [data replaceBytesInRange:NSMakeRange(30, 8) withBytes:fileLengthByte];
    }
    _data = [NSString stringToHex:(uint8_t*)[data bytes] length:(int)[data length]];
}

- (void)dealloc
{
    [_relativePath release],_relativePath = nil;
    [_key release],_key = nil;
    [_domain release],_domain = nil;
    [_path release],_path = nil;
    [_linkTarget release],_linkTarget = nil;
    [_dataHash release],_dataHash = nil;
    [_encryptionKey release],_encryptionKey = nil;
    [_data release],_data = nil;
    [_bTime release],_bTime = nil;
    [_cTime release],_cTime = nil;
    [_properties release],_properties = nil;
    [_localPath release],_localPath = nil;
    [super dealloc];
}
@end

@implementation IMBFileProperties
@synthesize name = _name;
@synthesize value = _value;

@end

@implementation IMBiPhoneApp
@synthesize key = _key;
@synthesize displayName = _displayName;
@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize container = _container;
@synthesize files = _files;
@synthesize filesLength = _filesLength;

@end

@implementation IMBAppFiles
@synthesize keyArray = _keyArray;
@synthesize filesLength = _filesLength;

- (id)init {
    self = [super init];
    if (self) {
        _keyArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_keyArray != nil) {
        [_keyArray dealloc];
        _keyArray = nil;
    }
    [super dealloc];
}

- (void)addFile:(NSString*)key fileLength:(long)fileLenth {
    [_keyArray addObject:key];
    _filesLength += fileLenth;
}

@end