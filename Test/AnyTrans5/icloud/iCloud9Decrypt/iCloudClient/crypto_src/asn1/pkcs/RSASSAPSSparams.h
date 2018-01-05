//
//  RSASSAPSSparams.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Integer.h"
#import "BigInteger.h"

@interface RSASSAPSSparams : ASN1Object {
@private
    AlgorithmIdentifier *_hashAlgorithm;
    AlgorithmIdentifier *_maskGenAlgorithm;
    ASN1Integer *_saltLength;
    ASN1Integer *_trailerField;
}

+ (AlgorithmIdentifier *)DEFAULT_HASH_ALGORITHM;
+ (AlgorithmIdentifier *)DEFAULT_MASK_GEN_FUNCTION;
+ (ASN1Integer *)DEFAULT_SALT_LENGTH;
+ (ASN1Integer *)DEFAULT_TRAILER_FIELD;
+ (RSASSAPSSparams *)getInstance:(id)paramObject;
- (instancetype)init;
- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (AlgorithmIdentifier *)getMaskGenAlgorithm;
- (BigInteger *)getSaltLength;
- (BigInteger *)getTrailerField;
- (ASN1Primitive *)toASN1Primitive;

@end
