//
//  ECPrivateKey.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "BigInteger.h"
#import "DERBitString.h"

@interface ECPrivateKey : ASN1Object {
@private
    ASN1Sequence *_seq;
}

+ (ECPrivateKey *)getInstance:(id)paramObject;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger paramDERBitString:(DERBitString *)paramDERBitString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger paramDERBitString:(DERBitString *)paramDERBitString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (BigInteger *)getKey;
- (DERBitString *)getPublicKey;
- (ASN1Primitive *)getParameters;
- (ASN1Primitive *)toASN1Primitive;

@end
