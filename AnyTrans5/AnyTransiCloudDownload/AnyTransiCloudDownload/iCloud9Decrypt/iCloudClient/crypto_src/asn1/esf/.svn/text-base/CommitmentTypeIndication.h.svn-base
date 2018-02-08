//
//  CommitmentTypeIndication.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface CommitmentTypeIndication : ASN1Object {
@private
    ASN1ObjectIdentifier *_commitmentTypeId;
    ASN1Sequence *_commitmentTypeQualifier;
}

+ (CommitmentTypeIndication *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (ASN1ObjectIdentifier *)getCommitmentTypeId;
- (ASN1Sequence *)getCommitmentTypeQualifier;
- (ASN1Primitive *)toASN1Primitive;

@end
