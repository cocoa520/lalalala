//
//  RSAPrivateKey.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "BigInteger.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"

@interface RSAPrivateKey : ASN1Object {
@private
    BigInteger *_version;
    BigInteger *_modulus;
    BigInteger *_publicExponent;
    BigInteger *_privateExponent;
    BigInteger *_prime1;
    BigInteger *_prime2;
    BigInteger *_exponent1;
    BigInteger *_exponent2;
    BigInteger *_coefficient;
    ASN1Sequence *_otherPrimeInfos;
}

+ (RSAPrivateKey *)getInstance:(id)paramObject;
+ (RSAPrivateKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramBigInteger4:(BigInteger *)paramBigInteger4 paramBigInteger5:(BigInteger *)paramBigInteger5 paramBigInteger6:(BigInteger *)paramBigInteger6 paramBigInteger7:(BigInteger *)paramBigInteger7 paramBigInteger8:(BigInteger *)paramBigInteger8;
- (BigInteger *)getVersion;
- (BigInteger *)getModulus;
- (BigInteger *)getPublicExponent;
- (BigInteger *)getPrivateExponent;
- (BigInteger *)getPrime1;
- (BigInteger *)getPrime2;
- (BigInteger *)getExponent1;
- (BigInteger *)getExponent2;
- (BigInteger *)getCoefficient;
- (ASN1Primitive *)toASN1Primitive;

@end
