//
//  NSData+Category.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Category)

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

//// ZLIB
//- (NSData *) zlibInflate;
//- (NSData *) zlibDeflate;
//
//// GZIP
//- (NSData *) gzipInflate;
//- (NSData *) gzipDeflate;

- (BOOL)bytesEqual:(NSData*)data;

- (NSString*)dataToHex;
- (NSData*)sha1;

+(NSData *)intToBytes:(long int)value;
@end
