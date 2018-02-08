//
//  PrivateKeyInfo.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"

@interface PrivateKeyInfo : ASN1Object {
@private
    ASN1OctetString *_privKey;
    AlgorithmIdentifier *_algId;
    ASN1Set *_attributes;
}

+ (PrivateKeyInfo *)getInstance:(id)paramObject;
+ (PrivateKeyInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable paramASN1Set:(ASN1Set *)paramASN1Set;
- (AlgorithmIdentifier *)getPrivateKeyAlgorithm;
- (AlgorithmIdentifier *)getAlgorithmId;
- (ASN1Encodable *)parsePrivateKey;
- (ASN1Primitive *)getPrivateKey;
- (ASN1Set *)getAttributes;
- (ASN1Primitive *)toASN1Primitive;

@end
