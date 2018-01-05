//
//  CertificatePolicies.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "Extensions.h"
#import "PolicyInformation.h"

@interface CertificatePolicies : ASN1Object {
@private
    NSMutableArray *_policyInformation;
}

+ (CertificatePolicies *)getInstance:(id)paramObject;
+ (CertificatePolicies *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (CertificatePolicies *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamPolicyInformation:(PolicyInformation *)paramPolicyInformation;
- (instancetype)initParamArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation;
- (NSMutableArray *)getPolicyInformation;
- (PolicyInformation *)getPolicyInformation:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
