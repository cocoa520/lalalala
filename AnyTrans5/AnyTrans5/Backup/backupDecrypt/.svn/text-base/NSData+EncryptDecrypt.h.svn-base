//
//  NSData+EncryptDecrypt.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonSymmetricKeywrap.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#include <sys/gmon.h>
#import "curve25519.h"

@interface NSData (EncryptDecrypt)

- (NSString *)hexString;

+ (NSData *)dataWithHexString:(NSString *)hexString;

- (NSMutableData *)AES256EncryptWithKey:(Byte *)key withIV:(Byte *)iv;

- (NSMutableData *)AES256DecryptWithKey:(Byte *)key withIV:(Byte *)iv withPadding:(BOOL)padding;

- (NSMutableData *)sha1;

- (NSMutableData *)sha256;

- (NSMutableData *)aes_wrap_key:(Byte *)kek withKekLength:(int)kekLength;

- (NSMutableData *)aes_unwrap_key:(Byte *)kek withKekLength:(int)kekLength;

+ (NSMutableData *)Rfc2898DeriveBytes:(NSString *)passcode withSalt:(NSData *)salt withIterations:(int)iterations;

+ (NSMutableData *)Rfc2898DeriveBytes256:(NSString *)passcode withSalt:(NSData *)salt withIterations:(int)iterations;

+ (NSMutableData *)Rfc2898DeriveBytesWithPasscodeData:(NSData *)passcode withSalt:(NSData *)salt withIterations:(int)iterations;

+ (NSMutableData *)curve25519:(NSData *)privateKey withPeerPublicKey:(NSData *)peerPublicKey;

@end
