//
//  SecT571Field.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface SecT571Field : NSObject

// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)add:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint64_t[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint64_t[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x;
// NSMutableArray == uint64_t[]
+ (void)invert:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint64_t[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)reduce5:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint64_t[]
+ (void)sqrt:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)squareAddToExt:(NSMutableArray*)x withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint64_t[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (uint)trace:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint64_t[]
+ (void)implMulwAcc:(NSMutableArray*)xs withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff;
// NSMutableArray == uint64_t[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz;

@end
