//
//  ECKeyFactories.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECKeyFactories.h"
#import "BigInteger.h"
#import "ECPublicKey.h"
#import "ECPrivateKeyEx.h"

@implementation ECKeyFactories

+ (ECPublicKey*)publicKeyFactory:(BigInteger*)x withY:(BigInteger*)y withCurveName:(NSString*)curveName {
    ECPublicKey *retVal = nil;
    @try {
        retVal = [ECPublicKey create:x withY:y withCurveName:curveName];
    }
    @catch (NSException *exception) {
    }
    return retVal;
}

+ (ECPrivateKeyEx*)privateKeyFactory:(BigInteger*)x withY:(BigInteger*)y withD:(BigInteger*)d withCurveName:(NSString*)curveName {
    ECPrivateKeyEx *retVal = nil;
    @try {
        retVal = [ECPrivateKeyEx create:x withY:y withD:d withCurveName:curveName];
    }
    @catch (NSException *exception) {
    }
    return retVal;
}

+ (ECPrivateKeyEx*)privateKeyFactory:(BigInteger*)d withCurveName:(NSString*)curveName {
    ECPrivateKeyEx *retVal = nil;
    @try {
        retVal = [ECPrivateKeyEx create:nil withY:nil withD:d withCurveName:curveName];
    }
    @catch (NSException *exception) {
    }
    return retVal;
}

@end
