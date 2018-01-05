//
//  SRPClient.h
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class Digest;
@class SecureRandom;

@interface SRPClient : NSObject {
@protected
    SecureRandom *                              _random;
    Digest *                                    _digest;
    BigInteger *                                _n;
    BigInteger *                                _g;
    BigInteger *                                _a;
    NSMutableData *                             _ephemeralKeyA;
    NSMutableData *                             _key;
    NSMutableData *                             _m1;
}

- (id)initWithRandom:(SecureRandom*)random withDigest:(Digest*)digest withN:(BigInteger*)n withG:(BigInteger*)g;

- (NSMutableData*)generateClientCredentials;
- (NSMutableData*)generateClientCredentials:(BigInteger*)a;
- (NSMutableData*)calculateClientEvidenceMessage:(NSMutableData*)salt withIdentity:(NSMutableData*)identity withPassword:(NSMutableData*)password withServerB:(NSMutableData*)serverB;
- (NSMutableData*)verifyServerEvidenceMessage:(NSMutableData*)serverM2;

@end
