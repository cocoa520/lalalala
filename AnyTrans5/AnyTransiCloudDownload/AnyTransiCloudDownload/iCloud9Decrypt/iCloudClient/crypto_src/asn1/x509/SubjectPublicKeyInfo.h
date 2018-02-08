//
//  SubjectPublicKeyInfo.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "ASN1Encodable.h"

@interface SubjectPublicKeyInfo : ASN1Object {
@private
    AlgorithmIdentifier *_algId;
    DERBitString *_keyData;
}

+ (SubjectPublicKeyInfo *)getInstance:(id)paramObject;
+ (SubjectPublicKeyInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getAlgorithm;
- (AlgorithmIdentifier *)getAlgorithmId;
- (ASN1Primitive *)parsePublicKey;
- (ASN1Primitive *)getPublicKey;
- (DERBitString *)getPublicKeyData;

@end
