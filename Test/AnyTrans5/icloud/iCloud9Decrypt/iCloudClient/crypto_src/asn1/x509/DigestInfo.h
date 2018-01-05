//
//  DigestInfo.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "AlgorithmIdentifier.h"

@interface DigestInfo : ASN1Object {
@private
    NSMutableData *_digest;
    AlgorithmIdentifier *_algId;
}

+ (DigestInfo *)getInstance:(id)paramObject;
+ (DigestInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getAlgorithmId;
- (NSMutableData *)getDigest;
- (ASN1Primitive *)toASN1Primitive;

@end
