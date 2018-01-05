//
//  PolicyQualifierInfo.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"
#import "ASN1Sequence.h"

@interface PolicyQualifierInfo : ASN1Object {
@private
    ASN1ObjectIdentifier *_policyQualifierId;
    ASN1Encodable *_qualifier;
}

+ (PolicyQualifierInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getPolicyQualifierId;
- (ASN1Encodable *)getQualifier;
- (ASN1Primitive *)toASN1Primitive;

@end
