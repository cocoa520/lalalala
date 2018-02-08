//
//  IMBKeybag.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/13/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBKeybag.h"
#import "IMBCommonEnum.h"
@implementation IMBKeybag
@synthesize uuid = _uuid;
@synthesize manifestKey = _manifestKey;

- (id)initWithManifest:(NSDictionary *)manifest {
    if (self=[super init]) {
        _deviceKey = nil;
        _uuid = nil;
        _wrap = nil;
        
        _attrs = [[NSMutableDictionary alloc] init];
        _classKeys = [[NSMutableDictionary alloc] init];
        _classKeyTags = [NSArray arrayWithObjects:@"CLAS", @"WRAP", @"WPKY", @"KTYP", @"PBKY", nil];
        NSData *data = [manifest objectForKey:@"BackupKeyBag"];
        _manifestKey = [manifest objectForKey:@"ManifestKey"];
        [self parseBinaryBlob:data];
    }
	return self;
}

- (id)initWithKeybagData:(NSData*)keybagData {
    if (self = [super init]) {
        _deviceKey = nil;
        _uuid = nil;
        _wrap = nil;
        
        _attrs = [[NSMutableDictionary alloc] init];
        _classKeys = [[NSMutableDictionary alloc] init];
        _classKeyTags = [NSArray arrayWithObjects:@"CLAS", @"WRAP", @"WPKY", @"KTYP", @"PBKY", nil];
        [self parseBinaryBlob:keybagData];
    }
    return self;
}

- (void)dealloc {
    if (_deviceKey != nil) {
        [_deviceKey release];
        _deviceKey = nil;
    }
    
    if (_uuid != nil) {
        [_uuid release];
        _uuid = nil;
    }
    
    if (_wrap != nil) {
        [_wrap release];
        _wrap = nil;
    }
    
    if (_attrs != nil) {
        [_attrs release];
        _attrs = nil;
    }
    
    if (_classKeys != nil) {
        [_classKeys release];
        _classKeys = nil;
    }

    [super dealloc];
}

- (void)parseBinaryBlob:(NSData *)blob {
    NSMutableDictionary *currClassKey = nil;
    
    int64_t totalLength = [blob length];
    int64_t currPos = 0;
    int readLength = 0;
    
    while (currPos != totalLength) {
        Byte tagBytes[5];
        memset(tagBytes, 0x00, 5);
        readLength = 4;
        [blob getBytes:tagBytes range:NSMakeRange((int)currPos, readLength)];
        currPos += readLength;
        NSString *tag = [NSString stringWithCString:(char*)tagBytes encoding:NSASCIIStringEncoding];
        
        int length = 0;
        readLength = 4;
        Byte *lenBytes = malloc(readLength + 1);
        memset(lenBytes, 0x00, readLength + 1);
        [blob getBytes:lenBytes range:NSMakeRange((int)currPos, readLength)];
        currPos += readLength;
        length = [IMBBigEndianBitConverter bigEndianToInt32:lenBytes byteLength:readLength];
        free(lenBytes);
        
        NSData *data = nil;
        Byte dataByte[length + 1];
        readLength = length;
        memset(dataByte, 0x00, readLength + 1);
        [blob getBytes:dataByte range:NSMakeRange((int)currPos, readLength)];
        currPos += readLength;
        data = [NSData dataWithBytes:dataByte length:readLength];
        
        if (data.length == 4) {
            data = [IMBLittleEndianBitConverter littleEndianBytes:(Byte*)data.bytes byteLength:(int)data.length];
        }
        if ([tag isEqualToString:@"TYPE"]) {
            _keybagType = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)data.bytes byteLength:(int)data.length] & 0x3FFFFFFF;
            if (_keybagType > 3) {
                NSLog(@"FAIL: Keybag type > 3 : %d", _keybagType);
            }
        } else if ([tag isEqualToString:@"UUID"] && _uuid == nil) {
            _uuid = [data retain];
        } else if ([tag isEqualToString:@"WRAP"] && _wrap == nil) {
            _wrap = [data retain];
        } else if ([tag isEqualToString:@"UUID"]) {
            if (currClassKey != nil && currClassKey.allKeys.count > 0) {
                NSData *keyData = [currClassKey objectForKey:@"CLAS"];
                int key = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)keyData.bytes byteLength:(int)keyData.length];
                [_classKeys setObject:currClassKey forKey:[NSNumber numberWithInt:key]];
            }
            if (currClassKey != nil) {
                [currClassKey release];
                currClassKey = nil;
            }
            currClassKey = [[NSMutableDictionary alloc] init];
            [currClassKey setObject:data forKey:@"UUID"];
        } else if ([_classKeyTags containsObject:tag]) {
            [currClassKey setObject:data forKey:tag];
        } else {
            [_attrs setObject:data forKey:tag];
        }
        
        if (currClassKey != nil && currClassKey.allKeys.count > 0) {
            if ([currClassKey.allKeys containsObject:@"CLAS"]) {
                NSData *keyData = [currClassKey objectForKey:@"CLAS"];
                int key = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)keyData.bytes byteLength:(int)keyData.length];
                [_classKeys setObject:currClassKey forKey:[NSNumber numberWithInt:key]];
            }
        }
    }
    
    if (currClassKey != nil) {
        [currClassKey release];
        currClassKey = nil;
    }
}

- (BOOL)unlockBackupKeybagWithPasscode:(NSString *)password {
    if (_keybagType != BACKUP_KEYBAG && _keybagType != OTA_KEYBAG) {
        NSLog(@"UnlockBackupKeybagWithPasscode: not a backup Keybag.");
        return NO;
    }
    return [self unlockWithPasscodeKey:[self getPasscodekeyFromPasscode:password]];
}

- (BOOL)unlockBackupKeybagWithPasscodeData:(NSData*)passcodeData {
    if (_keybagType != BACKUP_KEYBAG && _keybagType != OTA_KEYBAG) {
        NSLog(@"UnlockBackupKeybagWithPasscode: not a backup Keybag.");
        return NO;
    }
    NSMutableData *passcodekey = nil;
    if (_keybagType == BACKUP_KEYBAG || _keybagType == OTA_KEYBAG) {
        NSData *iterData = [_attrs objectForKey:@"ITER"];
        int iter = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)iterData.bytes byteLength:(int)iterData.length];
        passcodekey = [NSData Rfc2898DeriveBytesWithPasscodeData:passcodeData withSalt:[_attrs objectForKey:@"SALT"] withIterations:iter];
    } else {
        passcodekey = [NSData Rfc2898DeriveBytesWithPasscodeData:passcodeData withSalt:[_attrs objectForKey:@"SALT"] withIterations:1];
    }
    
    return [self unlockWithPasscodeKey:passcodekey];
}

- (BOOL)unlockWithPasscodeKey:(NSData*)key {
    if (_keybagType != BACKUP_KEYBAG && _keybagType != OTA_KEYBAG) {
        return NO;
    }
    
    for (NSDictionary *classKey in [_classKeys allValues]) {
        if (![classKey.allKeys containsObject:@"WPKY"]) {
            continue;
        }
        
        NSData *kData = [classKey objectForKey:@"WPKY"];
        NSData *wrapData = [classKey objectForKey:@"WRAP"];
        int wrap = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)wrapData.bytes byteLength:(int)wrapData.length];
        if ((wrap & WRAP_PASSCODE) > 0) {
            NSLog(@"%@", [[[classKey objectForKey:@"WPKY"] hexString] stringByReplacingOccurrencesOfString:@"-" withString:@""]);
            kData =[self aesUnwrap:key withWrapped:[classKey objectForKey:@"WPKY"]];
            if (kData == nil) {
                return NO;
            }
        }
        
        if ((wrap & WRAP_DEVICE) > 0) {
            if (_deviceKey == nil) {
                continue;
            }
            kData = [kData AES256DecryptWithKey:(Byte*)_deviceKey.bytes withIV:ZERO_IV withPadding:NO];
        }
        [classKey setValue:kData forKey:@"KEY"];
    }
    _unlocked = YES;
    return YES;
}

- (NSMutableData *)getPasscodekeyFromPasscode:(NSString *)passcode {
    NSMutableData *retData = nil;
    if (_keybagType == BACKUP_KEYBAG || _keybagType == OTA_KEYBAG) {
        NSData *dpicData = [_attrs objectForKey:@"DPIC"];
        if (dpicData != nil && dpicData.length > 0) {//iOS10以上的备份解密，增加双重保护盐加密https://gxnotes.com/article/53484.html
            //双重保护盐加密（SHA256）
            int dpic = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)dpicData.bytes byteLength:(int)dpicData.length];
            NSData *passcode1 = [NSData Rfc2898DeriveBytes256:passcode withSalt:[_attrs objectForKey:@"DPSL"] withIterations:dpic];
            
            //（SHA1）
            NSData *iterData = [_attrs objectForKey:@"ITER"];
            int iter = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)iterData.bytes byteLength:(int)iterData.length];
            retData = [NSData Rfc2898DeriveBytesWithPasscodeData:passcode1 withSalt:[_attrs objectForKey:@"SALT"] withIterations:iter];
        }else {
            NSData *iterData = [_attrs objectForKey:@"ITER"];
            int iter = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)iterData.bytes byteLength:(int)iterData.length];
            retData = [NSData Rfc2898DeriveBytes:passcode withSalt:[_attrs objectForKey:@"SALT"] withIterations:iter];
        }
    } else {
        retData = [NSData Rfc2898DeriveBytes:passcode withSalt:[_attrs objectForKey:@"SALT"] withIterations:1];
    }
    return retData;
}

- (NSMutableData *)unwrapKeyForClass:(int)clas withPersistentKey:(NSData *)persistentKey {
    if (![_classKeys.allKeys containsObject:[NSNumber numberWithInt:clas]]
        || ![[[_classKeys objectForKey:[NSNumber numberWithInt:clas]] allKeys] containsObject:@"KEY"]) {
        return nil;
    }
    
    NSData *ck = [[_classKeys objectForKey:[NSNumber numberWithInt:clas]] objectForKey:@"KEY"];
    int vars = 0;
    if ([_attrs.allKeys containsObject:@"VERS"]) {
        NSData *versData = [_attrs objectForKey:@"VERS"];
        vars = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)versData.bytes byteLength:(int)versData.length];
    } else {
        vars = 2;
    }
    
    int ktyp = 0;
    id obj = [_classKeys objectForKey:[NSNumber numberWithInt:clas]];
    if (obj != nil) {
        NSDictionary *tmpClassDic = (NSDictionary*)obj;
        if ([tmpClassDic.allKeys containsObject:@"KTYP"]) {
            NSData *ktypData = [tmpClassDic objectForKey:@"KTYP"];
            ktyp = [IMBBigEndianBitConverter bigEndianToInt32:(Byte*)ktypData.bytes byteLength:(int)ktypData.length];
        } else {
            ktyp = 0;
        }
    } else {
        ktyp = 0;
    }
    
    if (vars >= 3 && ktyp == 1) {
        return [self unwrapCurve25519:clas withPersistentKey:persistentKey];
    }
    if (persistentKey.length == 0x28) {
        return [self aesUnwrap:ck withWrapped:persistentKey];
    }
    return nil;
}

- (NSMutableData *)unwrapCurve25519:(int)persistentClass withPersistentKey:(NSData *)persistentKey {
    if (persistentKey.length != 0x48) {
        return nil;
    }
    NSData *mysecret = [[_classKeys objectForKey:[NSNumber numberWithInt:persistentClass]] objectForKey:@"KEY"];
    NSData *mypublic = [[_classKeys objectForKey:[NSNumber numberWithInt:persistentClass]] objectForKey:@"PBKY"];
    Byte hispublic[32];
    memset(hispublic, 0x00, 32);
    memcpy(hispublic, persistentKey, 32);
    NSData *hispublicData = [NSData dataWithBytes:hispublic length:32];
    NSMutableData *shared = [NSData curve25519:mysecret withPeerPublicKey:hispublicData];
    
    long dataLength = 4 + shared.length + hispublicData.length + mypublic.length;
    Byte dataByte[dataLength];
    memset(dataByte, 0x00, dataLength);
    Byte tmp[4] = { 0x00, 0x00, 0x00, 0x01 };
    int pos = 0;
    memcpy(dataByte, tmp, 4);
    pos += 4;
    memcpy(dataByte + pos, shared.bytes, shared.length);
    pos += shared.length;
    memcpy(dataByte + pos, hispublicData.bytes, hispublicData.length);
    pos += hispublicData.length;
    memcpy(dataByte + pos, mypublic.bytes, mypublic.length);
    pos += mypublic.length;
    NSData *data = [NSData dataWithBytes:dataByte length:dataLength];
    NSMutableData *md = [data sha256];
    
    long wrappedLegth = persistentKey.length - 32;
    Byte wrappedBytes[wrappedLegth];
    memset(wrappedBytes, 0x00, wrappedLegth);
    memcpy(wrappedBytes, (char*)(persistentKey.bytes) + 32, wrappedLegth);
    NSData *wrapped = [NSData dataWithBytes:wrappedBytes length:wrappedLegth];
    
    return [self aesUnwrap:md withWrapped:wrapped];
}

- (NSMutableData *)aesUnwrap:(NSData *)kek withWrapped:(NSData *)wrapped {
    return [wrapped aes_unwrap_key:(Byte*)kek.bytes withKekLength:(int)kek.length];
}

@end
