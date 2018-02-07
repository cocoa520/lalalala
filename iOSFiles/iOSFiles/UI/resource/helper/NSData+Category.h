//
//  NSData+Category.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
//void *NewBase64Decode(
//                      const char *inputBuffer,
//                      size_t length,
//                      size_t *outputLength);
//
//char *NewBase64Encode(
//                      const void *inputBuffer,
//                      size_t length,
//                      bool separateLines,
//                      size_t *outputLength);
@interface NSData (Category)
/**
base64加密解密   见---NSData+Base64.h
 */
//+ (NSData *)dataFromBase64String:(NSString *)aString;
//- (NSString *)base64EncodedString;
//// added by Hiroshi Hashiguchi
//- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;
/**
 AES256加密解密
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

// Returns range [start, null byte), or (NSNotFound, 0).
- (NSRange) rangeOfNullTerminatedBytesFrom:(int)start;

// Canonical Base32 encoding/decoding.
+ (NSData *) dataWithBase32String:(NSString *)base32;
- (NSString *) base32String;

// COBS is an encoding that eliminates 0x00.
- (NSData *) encodeCOBS;
- (NSData *) decodeCOBS;



- (BOOL)bytesEqual:(NSData*)data;

- (NSString*)dataToHex;
- (NSData*)sha1;

+(NSData *)intToBytes:(long int)value;
@end
