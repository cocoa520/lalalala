//
//  Nat192.h
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface Nat192 : NSObject

// NSMutableArray == uint[]
+ (uint)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (uint)addBothTo:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (uint)addTo:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (uint)addTo:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff withCin:(uint)cIn;
// NSMutableArray == uint[]
+ (uint)addToEachOther:(NSMutableArray*)u withUoff:(int)uOff withV:(NSMutableArray*)v withVoff:(int)vOff;
// NSMutableArray == uint[]
+ (void)copy:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)copy64:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// return == uint[6]
+ (NSMutableArray*)create;
// return == uint64_t[3]
+ (NSMutableArray*)create64;
// return == uint[12]
+ (NSMutableArray*)createExt;
// return == uint64_t[6]
+ (NSMutableArray*)createExt64;
// NSMutableArray == uint[]
+ (BOOL)diff:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (BOOL)eq:(NSMutableArray*)x withY:(NSMutableArray*)y;
// NSMutableArray == uint64_t[]
+ (BOOL)eq64:(NSMutableArray*)x withY:(NSMutableArray*)y;
// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x;
// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger64:(BigInteger*)x;
// NSMutableArray == uint[]
+ (uint)getBit:(NSMutableArray*)x withBit:(int)bit;
// NSMutableArray == uint[]
+ (BOOL)gte:(NSMutableArray*)x withY:(NSMutableArray*)y;
// NSMutableArray == uint[]
+ (BOOL)gte:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff;
// NSMutableArray == uint[]
+ (BOOL)isOne:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (BOOL)isOne64:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (BOOL)isZero:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (BOOL)isZero64:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff;
// NSMutableArray == uint[]
+ (uint)mulAddTo:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (uint)mulAddTo:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff;
// NSMutableArray == uint[]
+ (uint64_t)mul33Add:(uint)w withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (uint)mulWordAddExt:(uint)x withYY:(NSMutableArray*)yy withYYoff:(int)yyOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff;
// NSMutableArray == uint[]
+ (uint)mul33DWordAdd:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (uint)mul33WordAdd:(uint)x withY:(uint)y withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (uint)mulWordDwordAdd:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (uint)mulWord:(uint)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withXoff:(int)xOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff;
// NSMutableArray == uint[]
+ (int)sub:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (int)sub:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (int)subBothFrom:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (int)subFrom:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (int)subFrom:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint[]
+ (BigInteger*)toBigInteger:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (BigInteger*)toBigInteger64:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (void)zero:(NSMutableArray*)z;

@end
