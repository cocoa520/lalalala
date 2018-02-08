//
//  ECAlgorithms.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ECCurve;
@class IFiniteField;
@class ECPoint;
@class BigInteger;
@class ECFieldElement;
@class ECPointMap;
@class GlvEndomorphism;

@interface ECAlgorithms : NSObject

+ (BOOL)isF2mCurve:(ECCurve*)c;
+ (BOOL)isF2mField:(IFiniteField*)field;

+ (BOOL)isFpCurve:(ECCurve*)c;
+ (BOOL)isFpField:(IFiniteField*)field;

// ps == ECPoint[], ks == BigInteger[]
+ (ECPoint*)sumOfMultiplies:(NSMutableArray*)ps withKs:(NSMutableArray*)ks;
+ (ECPoint*)sumOfTwoMultiplies:(ECPoint*)P withA:(BigInteger*)a withQ:(ECPoint*)Q withB:(BigInteger*)b;
+ (ECPoint*)shamirsTrick:(ECPoint*)P withK:(BigInteger*)k withQ:(ECPoint*)Q withL:(BigInteger*)l;
+ (ECPoint*)importPoint:(ECCurve*)c withP:(ECPoint*)p;
+ (void)montgomeryTrick:(NSMutableArray*)zs withOff:(int)off withLen:(int)len;
+ (void)montgomeryTrick:(NSMutableArray*)zs withOff:(int)off withLen:(int)len withScale:(ECFieldElement*)scale;
+ (ECPoint*)referenceMultiply:(ECPoint*)p withK:(BigInteger*)k;
+ (ECPoint*)validatePoint:(ECPoint*)p;
+ (ECPoint*)implShamirsTrickJsf:(ECPoint*)P withK:(BigInteger*)k withQ:(ECPoint*)Q withL:(BigInteger*)l;
+ (ECPoint*)implShamirsTrickWNaf:(ECPoint*)P withK:(BigInteger*)k withQ:(ECPoint*)Q withL:(BigInteger*)l;
+ (ECPoint*)implShamirsTrickWNaf:(ECPoint*)P withK:(BigInteger*)k withPointMapQ:(ECPointMap*)pointMapQ withL:(BigInteger*)l;
// preCompP == ECPoint[], preCompNegP == ECPoint[], preCompQ = ECPoint[], preCompNegQ = ECPoint[]
+ (ECPoint*)implShamirsTrickWNaf:(NSMutableArray*)preCompP withPreCompNegP:(NSMutableArray*)preCompNegP withWnafP:(NSMutableData*)wnafP withPreCompQ:(NSMutableArray*)preCompQ withPreCompNegQ:(NSMutableArray*)preCompNegQ withWnafQ:(NSMutableData*)wnafQ;
+ (ECPoint*)implSumOfMultiplies:(NSMutableArray*)ps withKS:(NSMutableArray*)ks;

// ps == ECPoint[], ks == BigInteger[]
+ (ECPoint*)implSumOfMultipliesGlv:(NSMutableArray*)ps withKS:(NSMutableArray*)ks withGlvEndomorphism:(GlvEndomorphism*)glvEndomorphism;
// ps == ECPoint[], ks = BigInteger[]
+ (ECPoint*)implSumOfMultiplies:(NSMutableArray*)ps withPointMap:(ECPointMap*)pointMap withKS:(NSMutableArray*)ks;
// negs == bool[], infos == WNafPreCompInfo[], wnafs == byte[][]
+ (ECPoint*)implSumOfMultiplies:(NSMutableArray*)negs withInfos:(NSMutableArray*)infos withWnafs:(NSMutableArray*)wnafs;

@end
