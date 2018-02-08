//
//  ECDSASignature.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class BigInteger;

@interface ECDSASignature : ASN1Object {
@private
    BigInteger *                            _r;
    BigInteger *                            _s;
}

- (id)initWithR:(BigInteger*)r withS:(BigInteger*)s;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (BigInteger*)getR;
- (BigInteger*)getS;

@end
