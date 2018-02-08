//
//  PolicyInformation.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface PolicyInformation : ASN1Object {
@private
    ASN1ObjectIdentifier *_policyIdentifier;
    ASN1Sequence *_policyQualifiers;
}

+ (PolicyInformation *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (ASN1ObjectIdentifier *)getPolicyIdentifer;
- (ASN1Sequence *)getPolicyQualifiers;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
