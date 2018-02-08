//
//  IMBBackupDecryptAbove4.m
//  DataRecovery
//
//  Created by iMobie on 3/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBackupDecryptAbove4.h"
#import "TempHelper.h"
#import "IMBCommonEnum.h"

@implementation IMBBackupDecryptAbove4
@synthesize keybag = _keybag;

-(id)initWithPath:(NSString *)backupPath withOutputPath:(NSString *)outputPath withIOSProductVersion:(NSString *)iosProductVersion{
    self = [super initWithPath:backupPath withOutputPath:outputPath withIOSProductVersion:iosProductVersion];
    if (self) {
        @try {
            mbdbParse = [[IMBMBDBParse alloc]init];
            _iosVersion = iosProductVersion;
//            [nc postNotificationName:DECRYPT_PROGRESS_MESSAGE object:CustomLocalizedString(@"MSG_DECRYPT_Begin_ReadMBDM", nil) userInfo:nil];
            [mbdbParse setIosVersion:_iosVersion];
            if ([_iosVersion isVersionLess:@"10.0"]) {
                if (![fm fileExistsAtPath:outputPath]) {
                    [fm createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSString *path = [outputPath stringByAppendingPathComponent:@"Manifest.mbdb"];
                if ([fm fileExistsAtPath:path]) {
                    [fm removeItemAtPath:path error:nil];
                }
                [fm copyItemAtPath:[_backupFilePath stringByAppendingPathComponent:@"Manifest.mbdb"] toPath:path error:nil];
            }
            [mbdbParse readMBDB:_backupFilePath];
            _fileRecordArray = [[mbdbParse recordArray] retain];
            
        }
        @catch (NSException *exception) {
            NSLog(@"Above4:%@", exception.reason);
        }
    }
    return self;
}

- (BOOL)againParseManifestDB:(NSString *)backupFolderPath {
    if ([fm fileExistsAtPath:backupFolderPath]) {
        if ([mbdbParse readMBDB:backupFolderPath]) {
            if (_fileRecordArray != nil) {
                [_fileRecordArray release];
                _fileRecordArray = nil;
            }
            _fileRecordArray = [[mbdbParse recordArray] retain];
            if (_fileRecordArray != nil) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (void)dealloc
{
    if (_fileRecordArray != nil) {
        [_fileRecordArray release];
        _fileRecordArray = nil;
    }
    
    if (mbdbParse != nil) {
        [mbdbParse release];
        mbdbParse = nil;
    }
    
    [super dealloc];
}

//判断密码是否匹配；
-(BOOL)verifyPassword:(NSString *)password withPath:(NSString *)manidestPath {
    BOOL ret = NO;
    _keybag = [[IMBKeybag alloc]initWithManifest:[TempHelper getPlistFileDir:manidestPath]];//[_backupFilePath stringByAppendingPathComponent:@"Manifest.plist"]
    if (_keybag == nil) {
        return NO;
    }
    ret = [_keybag unlockBackupKeybagWithPasscode:password];
    if (ret) {
        NSString *name = [self decryptSingleFile:@"KeychainDomain" withFilePath:@"keychain-backup.plist"];
        NSMutableDictionary *keyChain = [TempHelper getPlistFileDir:[_outputPath stringByAppendingPathComponent:name]];
        if (keyChain != nil) {
            ret = YES;
        }else {
            ret = NO;
        }
    }
    return ret;
}


- (BOOL)decodeManifestDBFile:(NSString *)password withPath:(NSString *)manifestPath {
    BOOL ret = NO;
    if (_keybag != nil) {
        [_keybag release];
        _keybag = nil;
    }
    _keybag = [[IMBKeybag alloc] initWithManifest:[TempHelper getPlistFileDir:manifestPath]];
    if (_keybag == nil) {
        return NO;
    }
    ret = [_keybag unlockBackupKeybagWithPasscode:password];
    if (ret) {
        @autoreleasepool {
            ret = [self extractFileManifestDB];
        }
    }
    
    return ret;
}

-(BOOL)verifyPasswordIsRight {
    BOOL ret = NO;
    NSString *name = [self decryptSingleFile:@"KeychainDomain" withFilePath:@"keychain-backup.plist"];
    NSString *path = [_outputPath stringByAppendingPathComponent:name];
    NSMutableDictionary *keyChain = [TempHelper getPlistFileDir:path];
    if (keyChain != nil) {
        ret = YES;
    }else {
        ret = NO;
    }
    return ret;
}

//提取文件
- (BOOL)extractFileManifestDB {
    if (![fm fileExistsAtPath:_outputPath]) {
        [fm createDirectoryAtPath:_outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *oldFolderPath = nil;
    oldFolderPath = [_outputPath stringByAppendingPathComponent:@"Manifest.db"];
    
    //    NSString *sourcePath = @"/Users/imobie/Desktop/Manifest.db";
    
    NSString *sourcePath = [_backupFilePath stringByAppendingPathComponent:@"Manifest.db"];
    
    NSFileHandle *sourceFile,*targetFile;
    if (![fm fileExistsAtPath:sourcePath]) {
        return NO;
    } else {
        sourceFile = [NSFileHandle fileHandleForReadingAtPath:sourcePath];
    }
    
    if ([fm fileExistsAtPath:oldFolderPath]) {
        [fm removeItemAtPath:oldFolderPath error:nil];
    }
    [fm createFileAtPath:oldFolderPath contents:nil attributes:nil];
    targetFile = [NSFileHandle fileHandleForWritingAtPath:oldFolderPath];
    if (sourceFile != nil && targetFile != nil) {
        IMBAES_256_CBC *aes_cbc = nil;
        if (self.keybag.manifestKey != nil && self.keybag != nil) {
            Byte paiClass[4];
            memset(paiClass, 0x00, 4);
            Byte *encryptionKey = (Byte*)self.keybag.manifestKey.bytes;
            memcpy(paiClass, encryptionKey, 4);
            int class = [IMBLittleEndianBitConverter littleEndianToInt32:paiClass byteLength:4];
            
            NSInteger length = self.keybag.manifestKey.length - 4;
            Byte enc_key[length];
            memset(enc_key, 0x00, length);
            memcpy(enc_key, encryptionKey + 4, length);
            NSMutableData *enc_key_data = [NSMutableData dataWithBytes:enc_key length:length];
            
            NSMutableData *keyData = [self.keybag unwrapKeyForClass:class withPersistentKey:enc_key_data];
            if (keyData == nil || keyData.length == 0) {
                [[IMBLogManager singleton] writeInfoLog:@"Cannot unwrap key"];
                return NO;
            }
            aes_cbc = [[IMBAES_256_CBC alloc] initWithKey:(Byte *)keyData.bytes withIV:ZERO_IV];
        }
        
        NSData *desdata = nil;
        while (YES) {
            NSData *data = [sourceFile readDataToEndOfFile];
            if (data == nil || data.length == 0) {
                break;
            }
            
            if (aes_cbc != nil) {
                desdata = [aes_cbc decryptCBCWithBytes:(Byte*)data.bytes withLength:(int)data.length];
                data = desdata;
                //NSLog(@"data:%@",desdata);
            }
            
            [targetFile writeData:data];
        }
        
        if (aes_cbc != nil && desdata.length != 0) {
            Byte* desBytes = (Byte*)desdata.bytes;
            Byte c = desBytes[desdata.length - 1];
            int i = (int)c;
            if ([desdata length] >= i + 1)
            {
                Byte verifyByte[i];
                memset(verifyByte, 0x00, i);
                memcpy(verifyByte, desBytes + (desdata.length - i), i);
                
                Byte verify[i];
                memset(verify, c, i);
                if (i < 17 && memcmp(verifyByte, verify, i) == 0) {
                    [targetFile truncateFileAtOffset:(desdata.length - i)];
                } else {
                    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"Bad padding, last byte = %d!  _currentDecryptFile:%d",i,_currentDecryptFile]];
                }
            }
        }
    }
    [sourceFile closeFile];
    [targetFile closeFile];
    return YES;
}

//解密所有文件；
-(void)decryptAllFile{
    [self addUpFileCounts];
    if (![fm fileExistsAtPath:_outputPath]) {
        [fm createDirectoryAtPath:_outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (IMBMBFileRecord *fr in self.fileRecordArray) {
        if ([fr is_directory]) {
            continue;
        }
        if ([fr is_regular_file]) {
            _currentDecryptFile += 1;
            @autoreleasepool {
                [self extractFile:fr.key withRecord:fr withOutputPath:_outputPath];
            }
        }
    }
}

//解密单个文件；
-(NSString *)decryptSingleFile:(NSString *)domain withFilePath:(NSString *)filePath{
    [self addUpSingleFileCounts:domain withFilePath:filePath];
    NSString *decryptName = nil;
    if (![fm fileExistsAtPath:_outputPath]) {
        [fm createDirectoryAtPath:_outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (IMBMBFileRecord *fr in self.fileRecordArray) {
        if ([fr.domain isEqualToString:domain]) {
            if ([fr.path contains:filePath]) {
                if ([fr is_directory]) {
                    continue;
                }
                if ([fr is_regular_file]) {
                    _currentDecryptFile += 1;
                    @autoreleasepool {
                        [self extractFile:fr.key withRecord:fr withOutputPath:_outputPath];
                    }
                    decryptName = fr.key;
                }
            }
        }
    }
    return decryptName;
}

//解密domain文件；
-(void)decryptDomainFile:(NSString *)domain{
    [self addUpDomainFileCounts:domain];
    if (![fm fileExistsAtPath:_outputPath]) {
        [fm createDirectoryAtPath:_outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (IMBMBFileRecord *fr in self.fileRecordArray) {
        if ([fr.domain contains:domain]) {
            if ([fr is_directory]) {
                continue;
            }
            if ([fr is_regular_file]) {
                _currentDecryptFile += 1;
                @autoreleasepool {
                    [self extractFile:fr.key withRecord:fr withOutputPath:_outputPath];
                }
            }
        }
    }
}

//提取文件
- (void)extractFile:(NSString *)fileName withRecord:(IMBMBFileRecord *)record withOutputPath:(NSString *)outputPath {
    NSString *oldFolderPath = [outputPath stringByAppendingPathComponent:fileName];
    
    NSString *sourcePath = [_backupFilePath stringByAppendingPathComponent:fileName];
    if ([_iosVersion isVersionMajorEqual:@"10"]) {
        NSString *fd = @"";
        if (record.key.length > 2) {
            fd = [record.key substringWithRange:NSMakeRange(0, 2)];
        }
        sourcePath = [[_backupFilePath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:record.key];
        if (![[record.path lastPathComponent] isEqualToString:@"keychain-backup.plist"]) {
            oldFolderPath = [outputPath stringByAppendingPathComponent:fd];
            if (![fm fileExistsAtPath:oldFolderPath]) {
                [fm createDirectoryAtPath:oldFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            oldFolderPath = [oldFolderPath stringByAppendingPathComponent:fileName];
        }
    }
    NSFileHandle *sourceFile,*targetFile;
    if (![fm fileExistsAtPath:sourcePath]) {
        return;
    } else {
        sourceFile = [NSFileHandle fileHandleForReadingAtPath:sourcePath];
    }
    
    if ([fm fileExistsAtPath:oldFolderPath]) {
        [fm removeItemAtPath:oldFolderPath error:nil];
    }
    [fm createFileAtPath:oldFolderPath contents:nil attributes:nil];
    targetFile = [NSFileHandle fileHandleForWritingAtPath:oldFolderPath];
    if (sourceFile != nil && targetFile != nil) {
        IMBAES_256_CBC *aes_cbc = nil;
        if (record.encryptionKey != nil && self.keybag != nil) {
            int length = (int)record.encryptionKey.length - 4;
            Byte enc_key[length];
            memset(enc_key, 0x00, length);
            Byte *encryptionKey = (Byte*)record.encryptionKey.bytes;
            memcpy(enc_key, encryptionKey + 4, length);
            NSMutableData *enc_key_data = [NSMutableData dataWithBytes:enc_key length:length];
            
            NSMutableData *keyData = [self.keybag unwrapKeyForClass:record.protectionClass withPersistentKey:enc_key_data];
            if (keyData == nil || keyData.length == 0) {
                NSLog(@"Cannot unwrap key");
                return;
            }
            aes_cbc = [[IMBAES_256_CBC alloc] initWithKey:(Byte *)keyData.bytes withIV:ZERO_IV];
        }
        
        NSData *desdata = nil;
        while (YES) {
            NSData *data = [sourceFile readDataToEndOfFile];
            if (data == nil || data.length == 0) {
                break;
            }
            
            if (aes_cbc != nil) {
                desdata = [aes_cbc decryptCBCWithBytes:(Byte*)data.bytes withLength:(int)data.length];
                data = desdata;
                //NSLog(@"data:%@",desdata);
            }
            
            [targetFile writeData:data];
        }
        
        if (aes_cbc != nil && desdata.length != 0) {
            Byte* desBytes = (Byte*)desdata.bytes;
            Byte c = desBytes[desdata.length - 1];
            int i = (int)c;
            if ([desdata length] >= i + 1)
            {
                Byte verifyByte[i];
                memset(verifyByte, 0x00, i);
                memcpy(verifyByte, desBytes + (desdata.length - i), i);
                
                Byte verify[i];
                memset(verify, c, i);
                if (i < 17 && memcmp(verifyByte, verify, i) == 0) {
                    [targetFile truncateFileAtOffset:(desdata.length - i)];
                } else {
                    NSLog(@"Bad padding, last byte = %d!", i);
                }
            }
        }
    }
    [sourceFile closeFile];
    [targetFile closeFile];
}

//统计需解密的文件个数
- (void)addUpFileCounts{
    for (IMBMBFileRecord *fr in _fileRecordArray) {
        if ([fr is_regular_file]) {
            _totalDecryptFiles += 1;
        }
    }
}

//统计需解密域下的文件个数
- (void)addUpDomainFileCounts:(NSString *)domain{
    for (IMBMBFileRecord *fr in _fileRecordArray) {
        if ([fr.domain contains:domain]) {
            if ([fr is_regular_file]) {
                _totalDecryptFiles += 1;
            }
        }
    }
}

//统计需解密单个的文件个数
- (void)addUpSingleFileCounts:(NSString *)domain  withFilePath:(NSString *)filePath{
    for (IMBMBFileRecord *fr in _fileRecordArray) {
        if ([fr.domain isEqualToString:domain] && [fr.path contains:filePath]) {
            if ([fr is_regular_file]) {
                _totalDecryptFiles += 1;
            }
        }
    }
}

@end
