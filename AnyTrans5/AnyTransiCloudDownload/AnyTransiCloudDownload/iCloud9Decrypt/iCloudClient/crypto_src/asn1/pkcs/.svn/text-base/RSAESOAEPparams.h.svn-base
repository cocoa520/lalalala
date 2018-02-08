//
//  RSAESOAEPparams.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Sequence.h"

@interface RSAESOAEPparams : ASN1Object {
@private
    AlgorithmIdentifier *_hashAlgorithm;
    AlgorithmIdentifier *_maskGenAlgorithm;
    AlgorithmIdentifier *_pSourceAlgorithm;
}

+ (AlgorithmIdentifier *)DEFAULT_HASH_ALGORITHM;
+ (AlgorithmIdentifier *)DEFAULT_MASK_GEN_FUNCTION;
+ (AlgorithmIdentifier *)DEFAULT_P_SOURCE_ALGORITHM;
+ (RSAESOAEPparams *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)init;
- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramAlgorithmIdentifier3:(AlgorithmIdentifier *)paramAlgorithmIdentifier3;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (AlgorithmIdentifier *)getMaskGenAlgorithm;
- (AlgorithmIdentifier *)getPSourceAlgorithm;
- (ASN1Primitive *)toASN1Primitive;

@end
