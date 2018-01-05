//
//  OtherHashAlgAndValue.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"

@interface OtherHashAlgAndValue : ASN1Object {
@private
    AlgorithmIdentifier *_hashAlgorithm;
    ASN1OctetString *_hashValue;
}

+ (OtherHashAlgAndValue *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (ASN1OctetString *)getHashValue;
- (ASN1Primitive *)toASN1Primitive;

@end
