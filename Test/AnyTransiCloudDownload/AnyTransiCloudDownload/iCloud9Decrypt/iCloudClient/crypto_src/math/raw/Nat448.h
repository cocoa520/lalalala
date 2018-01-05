//
//  Nat448.h
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface Nat448 : NSObject

// NSMutableArray == uint64_t[]
+ (void)copy64:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// return == uint64_t[7]
+ (NSMutableArray*)create64;
// return == uint64_t[14]
+ (NSMutableArray*)createExt64;
// NSMutableArray == uint64_t[]
+ (BOOL)eq64:(NSMutableArray*)x withY:(NSMutableArray*)y;
// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger64:(BigInteger*)x;
// NSMutableArray == uint64_t[]
+ (BOOL)isOne64:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (BOOL)isZero64:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (BigInteger*)toBigInteger64:(NSMutableArray*)x;

@end
