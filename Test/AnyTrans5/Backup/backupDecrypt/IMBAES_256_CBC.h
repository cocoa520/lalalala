//
//  IMBAES_256_CBC.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
//#import "CommonType.h"

@interface IMBAES_256_CBC : NSObject {
@private
    Byte *_key;
    Byte *_iv;
}

- (id)initWithKey:(Byte *)key withIV:(Byte *)iv;

- (NSMutableData *)encryptCBCWithBytes:(Byte*)data withLength:(int)length;
- (NSMutableData *)decryptCBCWithBytes:(Byte*)data withLength:(int)length;

+ (NSMutableData *)removePadding:(Byte *)data withLength:(size_t)length withBlockSize:(int)blockSize;

+ (NSMutableData *)aesEncryptWithData:(NSData*)data withKey:(NSData*)key withIV:(NSData*)iv;
+ (NSMutableData *)aesDecryptWithData:(NSData*)data withKey:(NSData*)key withIV:(NSData*)iv;

@end
