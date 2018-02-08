//
//  RFC6637.h
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Wrapper;
@class RFC6637KDF;
@class BigInteger;

@interface RFC6637 : NSObject {
@private
    Wrapper *                       _wrapperFactory;
    NSString *                      _curveName;
    int                             _symAlgIDKeyLength;
    RFC6637KDF *                    _kdf;
}

- (id)initWithWrapper:(Wrapper*)wrapperFactory withCurveName:(NSString*)curveName withSymAlgIDKeyLength:(int)symAlgIDKeyLength withKdf:(RFC6637KDF*)kdf;

- (NSMutableData*)unwrap:(NSMutableData*)data withFingerprint:(NSMutableData*)fingerprint withD:(BigInteger*)d;
+ (NSMutableData*)finalize:(NSMutableData*)data;

@end