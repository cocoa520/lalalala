//
//  SigPolicyQualifierInfo.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface SigPolicyQualifierInfo : ASN1Object {
@private
    ASN1ObjectIdentifier *_sigPolicyQualifierId;
    ASN1Encodable *_sigQualifier;
}

+ (SigPolicyQualifierInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getSigPolicyQualifierId;
- (ASN1Encodable *)getSigQualifier;
- (ASN1Primitive *)toASN1Primitive;

@end
