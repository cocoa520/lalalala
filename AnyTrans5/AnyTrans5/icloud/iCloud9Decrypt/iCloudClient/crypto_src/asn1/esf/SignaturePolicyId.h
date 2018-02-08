//
//  SignaturePolicyId.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "OtherHashAlgAndValue.h"
#import "SigPolicyQualifiers.h"

@interface SignaturePolicyId : ASN1Object {
@private
    ASN1ObjectIdentifier *_sigPolicyId;
    OtherHashAlgAndValue *_sigPolicyHash;
    SigPolicyQualifiers *_sigPolicyQualifiers;
}

+ (SignaturePolicyId *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramOtherHashAlgAndValue:(OtherHashAlgAndValue *)paramOtherHashAlgAndValue;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramOtherHashAlgAndValue:(OtherHashAlgAndValue *)paramOtherHashAlgAndValue paramSigPolicyQualifiers:(SigPolicyQualifiers *)paramSigPolicyQualifiers;
- (ASN1ObjectIdentifier *)getSigPolicyId;
- (OtherHashAlgAndValue *)getSigPolicyHash;
- (SigPolicyQualifiers *)getSigPolicyQualifiers;
- (ASN1Primitive *)toASN1Primitive;

@end
