//
//  PolicyMappings.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "CertPolicyId.h"

@interface PolicyMappings : ASN1Object {
    ASN1Sequence *_seq;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;

+ (PolicyMappings *)getInstance:(id)paramObject;
- (instancetype)initParamHashtable:(NSMutableDictionary *)paramHashtable;
- (instancetype)initParamCertPolicyId1:(CertPolicyId *)paramCertPolicyId1 paramCertPolicyId2:(CertPolicyId *)paramCertPolicyId2;
- (instancetype)initParamArrayOfCertPolicyId1:(NSMutableArray *)paramArrayOfCertPolicyId1 paramArrayOfCertPolicyId2:(NSMutableArray *)paramArrayOfCertPolicyId2;
- (ASN1Primitive *)toASN1Primitive;

@end
