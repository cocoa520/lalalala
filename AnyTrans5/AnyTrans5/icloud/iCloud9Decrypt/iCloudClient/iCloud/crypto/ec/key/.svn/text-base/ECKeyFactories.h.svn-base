//
//  ECKeyFactories.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class ECPublicKey;
@class ECPrivateKeyEx;

@interface ECKeyFactories : NSObject

+ (ECPublicKey*)publicKeyFactory:(BigInteger*)x withY:(BigInteger*)y withCurveName:(NSString*)curveName;
+ (ECPrivateKeyEx*)privateKeyFactory:(BigInteger*)x withY:(BigInteger*)y withD:(BigInteger*)d withCurveName:(NSString*)curveName;
+ (ECPrivateKeyEx*)privateKeyFactory:(BigInteger*)d withCurveName:(NSString*)curveName;

@end