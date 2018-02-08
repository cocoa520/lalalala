//
//  IMBBackupDecryptAbove4.h
//  DataRecovery
//
//  Created by iMobie on 3/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBackupDecrypt.h"
//#import "NSData+EncryptDecrypt.h"
//#import "NSMutableDictionary+Convert.h"
//#import "IMBBigEndianBitConverter.h"
//#import "IMBUtilTool.h"
#import "NSString+Category.h"
#import "IMBKeybag.h"
#import "IMBMBDBParse.h"
#import "IMBAES_256_CBC.h"

@interface IMBBackupDecryptAbove4 : IMBBackupDecrypt{
@private
    IMBMBDBParse *mbdbParse;
    IMBKeybag *_keybag;
    Byte auth_key[32];
}

@property (nonatomic, readwrite, retain) IMBKeybag *keybag;

- (BOOL)decodeManifestDBFile:(NSString *)password withPath:(NSString *)manifestPath;
-(BOOL)verifyPasswordIsRight;
- (BOOL)againParseManifestDB:(NSString *)backupFolderPath;

@end
