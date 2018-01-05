//
//  NSString+Category.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
/**
 字符串比较
 */
- (BOOL)isVersionAscending:(NSString*)verStr;
- (BOOL)isVersionAscendingEqual:(NSString*)verStr;
- (BOOL)isVersionLessEqual:(NSString*)verStr;
- (BOOL)isVersionLess:(NSString *)verStr;
- (BOOL)isVersionMajorEqual:(NSString *)verStr;
- (BOOL)isVersionMajor:(NSString *)verStr;
- (BOOL)isNilOrEmpty;
+ (BOOL)isNilOrEmpty:(NSString*)string;
- (BOOL)contains:(NSString *)value;
- (BOOL)isVersionEqual:(NSString *)verStr ;
/**
 字符串SymlinksAndAliases
 */

- (NSString *)stringByResolvingSymlinksAndAliases;
- (NSString *)stringByIterativelyResolvingSymlinkOrAlias;

- (NSString *)stringByResolvingSymlink;
- (NSString *)stringByConditionallyResolvingSymlink;

- (NSString *)stringByResolvingAlias;
- (NSString *)stringByConditionallyResolvingAlias;
/**
 字符串 md5
 */
- (NSString *)md5;
- (NSData*)sha1;
+ (NSString *)MD5FromData:(NSData *)data;
+ (NSString*)generateGUID;
/**
 字符串 ContainsString
 */
- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)startWithString:(NSString *)string;
- (BOOL)startWithString:(NSString *)string options:(NSStringCompareOptions)options;
/**
 字符串与字节的转换
 */
- (NSData*)hexToBytes;
+ (NSString*)stringToHex:(uint8_t*)bytes length:(int)length;
- (NSData*)toDataByEncoding:(NSStringEncoding)encoding;
/**
 字符串子字符串
 */
- (NSRange)rangeOfString:(NSString*)subString atOccurrence:(int)occurrence;
//AES
- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end
