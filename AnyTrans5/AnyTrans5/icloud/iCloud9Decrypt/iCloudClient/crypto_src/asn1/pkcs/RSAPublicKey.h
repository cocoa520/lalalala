//
//  RSAPublicKey.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "BigInteger.h"
#import "ASN1TaggedObject.h"

@interface RSAPublicKey : ASN1Object {
@private
    BigInteger *_modulus;
    BigInteger *_publicExponent;
}

+ (RSAPublicKey *)getInstance:(id)paramObject;
+ (RSAPublicKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2;
- (BigInteger *)getModulus;
- (BigInteger *)getPublicExponent;
- (ASN1Primitive *)toASN1Primitive;

@end
