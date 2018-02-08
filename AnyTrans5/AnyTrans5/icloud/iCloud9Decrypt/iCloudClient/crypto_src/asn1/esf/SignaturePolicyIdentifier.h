//
//  SignaturePolicyIdentifier.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "SignaturePolicyId.h"

@interface SignaturePolicyIdentifier : ASN1Object {
@private
    SignaturePolicyId *_signaturePolicyId;
    BOOL _isSignaturePolicyImplied;
}

+ (SignaturePolicyIdentifier *)getInstance:(id)paramObject;
- (instancetype)init;
- (instancetype)initParamSignaturePolicyId:(SignaturePolicyId *)paramSignaturePolicyId;
- (SignaturePolicyId *)getSignaturePolicyId;
- (BOOL)isSignaturePolicyImplied;
- (ASN1Primitive *)toASN1Primitive;

@end
