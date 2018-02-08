//
//  Curve25519Field.h
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface Curve25519Field : NSObject

// return == uint[]
+ (NSMutableArray*)P;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)addExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x;
// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)multiplyAddToExt:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)reduce27:(uint)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)subtractExt:(NSMutableArray*)xx withYY:(NSMutableArray*)yy withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (uint)addPTo:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (uint)addPExtTo:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (int)subPFrom:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (int)subPExtFrom:(NSMutableArray*)zz;

@end
