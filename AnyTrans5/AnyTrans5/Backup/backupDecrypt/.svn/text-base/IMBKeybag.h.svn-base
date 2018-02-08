//
//  IMBKeybag.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/13/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+EncryptDecrypt.h"
#import "IMBBigEndianBitConverter.h"
#import "IMBLittleEndianBitConverter.h"
//#import "IMBRfc2898DeriveBytes.h"
//#import "CommonType.h"
//#import "IMBCommonDefine.h"

#define SYSTEM_KEYBAG   0
#define BACKUP_KEYBAG   1
#define ESCROW_KEYBAG   2
#define OTA_KEYBAG      3

#define WRAP_DEVICE     1
#define WRAP_PASSCODE   2

@interface IMBKeybag : NSObject {
@private
    int _keybagType;
    NSData *_deviceKey;
    NSData *_uuid;
    NSData *_wrap;
    BOOL _unlocked;
    
    NSMutableDictionary *_attrs;
    NSMutableDictionary *_classKeys;
    NSArray *_classKeyTags;
    
    NSData *_manifestKey;
}

@property (nonatomic, readwrite, retain) NSData *uuid;
@property (nonatomic, retain) NSData *manifestKey;

- (id)initWithManifest:(NSDictionary *)manifest;

- (id)initWithKeybagData:(NSData*)keybagData;

- (BOOL)unlockBackupKeybagWithPasscode:(NSString *)password;

- (BOOL)unlockBackupKeybagWithPasscodeData:(NSData*)passcodeData;

- (NSMutableData *)unwrapKeyForClass:(int)clas withPersistentKey:(NSData *)persistentKey;

@end