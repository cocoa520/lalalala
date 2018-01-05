//
//  RSAPublicKeyStructure.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "BigInteger.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"

@interface RSAPublicKeyStructure : ASN1Object {
@private
    BigInteger *_modulus;
    BigInteger *_publicExponent;
}

+ (RSAPublicKeyStructure *)getInstance:(id)paramObject;
+ (RSAPublicKeyStructure *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2;
- (BigInteger *)getModulus;
- (BigInteger *)getPublicExponent;
- (ASN1Primitive *)toASN1Primitive;

@end
