//
//  GcmUtilities.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface GcmUtilities : NSObject

+ (NSMutableData*)oneAsBytes;
// return == uint[]
+ (NSMutableArray*)oneAsUints;
// return == uint64_t[]
+ (NSMutableArray*)oneAsUInt64_ts;
// NSMutableArray == uint[]
+ (NSMutableData*)asBytesWithUintArray:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (void)asBytesWithUintArray:(NSMutableArray*)x withZ:(NSMutableData*)z;
// NSMutableArray == uint64_t[]
+ (NSMutableData*)asBytesWithUint64_tArray:(NSMutableArray*)x;
// NSMutableArray == uint64_t[]
+ (void)asBytesWithUint64_tArray:(NSMutableArray*)x withZ:(NSMutableData*)z;
// return == uint[]
+ (NSMutableArray*)asUints:(NSMutableData*)bs;
// NSMutableArray == uint[]
+ (void)asUints:(NSMutableData*)bs withOutput:(NSMutableArray*)output;
// return == uint64_t[]
+ (NSMutableArray*)asUint64_ts:(NSMutableData*)x;
// NSMutableArray == uint64_t[]
+ (void)asUint64_ts:(NSMutableData*)x withUint64_ts:(NSMutableArray*)z;
+ (void)multiplyWithBytes:(NSMutableData*)x withY:(NSMutableData*)y;
// NSMutableArray == uint[]
+ (void)multiplyWithUints:(NSMutableArray*)x withY:(NSMutableArray*)y;
// NSMutableArray == uint64_t[]
+ (void)multiplyWithUint64_ts:(NSMutableArray*)x withY:(NSMutableArray*)y;
// P is the value with only bit i=1 set
// NSMutableArray == uint[]
+ (void)multiplyP:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (void)multiplyP:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (void)multiplyP8:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (void)multiplyP8:(NSMutableArray*)x withY:(NSMutableArray*)y;
// NSMutableArray == uint[]
+ (uint)shiftRight:(NSMutableArray*)x;
// NSMutableArray == uint[]
+ (uint)shiftRight:(NSMutableArray*)x withZ:(NSMutableArray*)z;
// NSMutableArray == uint[]
+ (uint)shiftRightN:(NSMutableArray*)x withN:(int)n;
// NSMutableArray == uint[]
+ (uint)shiftRightN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z;
+ (void)xorWithBytes:(NSMutableData*)x withY:(NSMutableData*)y;
+ (void)xorWithBytes:(NSMutableData*)x withY:(NSMutableData*)y withYoff:(int)yOff withYlen:(int)yLen;
+ (void)xorWithBytes:(NSMutableData*)x withY:(NSMutableData*)y withZ:(NSMutableData*)z;
// NSMutableArray == uint[]
+ (void)xorWithUints:(NSMutableArray*)x withY:(NSMutableArray*)y;
// NSMutableArray == uint[]
+ (void)xorWithUints:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;
// NSMutableArray == uint64_t[]
+ (void)xorWithUint64_ts:(NSMutableArray*)x withY:(NSMutableArray*)y;
// NSMutableArray == uint64_t[]
+ (void)xorWithUint64_ts:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z;

@end
