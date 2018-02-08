//
//  OriginatorPublicKey.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"

@interface OriginatorPublicKey : ASN1Object {
@private
    AlgorithmIdentifier *_algorithm;
    DERBitString *_publicKey;
}

+ (OriginatorPublicKey *)getInstance:(id)paramObject;
+ (OriginatorPublicKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getAlgorithm;
- (DERBitString *)getPublicKey;
- (ASN1Primitive *)toASN1Primitive;

@end
