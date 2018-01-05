//
//  RSAPublicKeyEAC.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PublicKeyDataObject.h"
#import "ASN1ObjectIdentifier.h"
#import "BigInteger.h"
#import "ASN1Sequence.h"

@interface RSAPublicKeyEAC : PublicKeyDataObject {
@private
    ASN1ObjectIdentifier *_usage;
    BigInteger *_modulus;
    BigInteger *_exponent;
    int _valid;
}

+ (int)modulusValid;
+ (int)exponentValid;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2;
- (ASN1ObjectIdentifier *)getUsage;
- (BigInteger *)getModulus;
- (BigInteger *)getPublicExponent;
- (ASN1Primitive *)toASN1Primitive;

@end
