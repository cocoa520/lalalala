//
//  ECPrivateKey.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECKey.h"

@class BigInteger;
@class ECPublicKey;

@interface ECPrivateKeyEx : ECKey {
@private
    ECPublicKey *                               _publicKey;
    BigInteger *                                _d;
}

- (BigInteger*)d;
- (ECPublicKey*)publicKey;

+ (ECPrivateKeyEx*)create:(BigInteger*)x withY:(BigInteger*)y withD:(BigInteger*)d withCurveName:(NSString*)curveName;

- (NSMutableData*)agreement:(ECPublicKey*)publicKey;
- (NSMutableData*)dEncoded;

@end
