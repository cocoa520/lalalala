//
//  StringsEx.h
//  
//
//  Created by Pallas on 5/30/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface StringsEx : NSObject

+ (BOOL)isOneOf:(NSString*)s withCandidates:(NSString*)candidates,...;
+ (NSString*)fromByteArray:(NSData*)bs;
// NSMutableArray == unichar[]
+ (NSMutableData*)toByteArrayWithUnicharArray:(NSMutableArray*)cs;
+ (NSMutableData*)toByteArrayWithString:(NSString*)s;
+ (NSString*)fromAsciiByteArray:(NSData*)bytes;
// NSMutableArray == unichar[]
+ (NSMutableData*)toAsciiByteArrayWithUnicharArray:(NSMutableArray*)cs;
+ (NSMutableData*)toAsciiByteArrayWithString:(NSString*)s;
+ (NSString*)fromUtf8ByteArray:(NSData*)bytes;
// NSMutableArray == unichar[]
+ (NSMutableData*)toUtf8ByteArrayWithUnicharArray:(NSMutableArray*)cs;
+ (NSMutableData*)toUtf8ByteArrayWithString:(NSString*)s;

@end
