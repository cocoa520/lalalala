//
//  SecP521R1Field.h
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface SecP521R1Field : NSObject

// return == uint[]
+ (NSMutableArray*)P;

// NSMutableArray == uint[]
+ (void)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)addOne:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x;
// NSMutableArray == uint[]
+ (void)half:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)multiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)negate:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)reduce:(NSMutableArray*)xx withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)reduce23:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)squareN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)subtract:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)twice:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)implMultiply:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz;
// NSMutableArray == uint[]
+ (void)implSquare:(NSMutableArray*)x withZZ:(NSMutableArray*)zz;

@end
