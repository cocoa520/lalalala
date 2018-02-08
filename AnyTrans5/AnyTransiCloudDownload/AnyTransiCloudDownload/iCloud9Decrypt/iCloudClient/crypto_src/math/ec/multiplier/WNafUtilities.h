//
//  WNafUtilities.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class WNafPreCompInfo;
@class ECPoint;
@class PreCompInfo;
@class ECPointMap;

@interface WNafUtilities : NSObject

+ (NSString*)PRECOMP_NAME;
// NSArray == int[]
+ (NSArray*)DEFAULT_WINDOW_SIZE_CUTOFFS;
// NSArray == byte[]
+ (NSData*)EMPTY_BYTES;
// NSArray == int[]
+ (NSArray*)EMPTY_INTS;
// NSArray == ECPoint[]
+ (NSArray*)EMPTY_POINTS;

// return == int[]
+ (NSMutableArray*)generateCompactNaf:(BigInteger*)k;
// return == int[]
+ (NSMutableArray*)generateCompactWindowNaf:(int)width withK:(BigInteger*)k;
// return == byte[]
+ (NSMutableData*)generateJsf:(BigInteger*)g withH:(BigInteger*)h;
// return == byte[]
+ (NSMutableData*)generateNaf:(BigInteger*)k;
// return == byte[]
+ (NSMutableData*)generateWindowNaf:(int)width withK:(BigInteger*)k;

+ (int)getNafWeight:(BigInteger*)k;
+ (WNafPreCompInfo*)getWNafPreCompInfoWithECPoint:(ECPoint*)p;
+ (WNafPreCompInfo*)getWNafPreCompInfoWithPreCompInfo:(PreCompInfo*)preCompInfo;
+ (int)getWindowSize:(int)bits;
// windowSizeCutoffs == int[]
+ (int)getWindowSize:(int)bits withWindowSizeCutoffs:(NSMutableArray*)windowSizeCutoffs;
+ (ECPoint*)mapPointWithPrecomp:(ECPoint*)p withWidth:(int)width withIncludeNegated:(BOOL)includeNegated withPointMap:(ECPointMap*)pointMap;
+ (WNafPreCompInfo*)precompute:(ECPoint*)p withWidth:(int)width withIncludeNegated:(BOOL)includeNegated;

@end
