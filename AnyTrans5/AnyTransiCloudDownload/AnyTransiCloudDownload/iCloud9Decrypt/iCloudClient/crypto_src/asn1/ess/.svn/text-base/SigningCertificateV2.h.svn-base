//
//  SigningCertificateV2.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ESSCertIDv2.h"

@interface SigningCertificateV2 : ASN1Object {
    ASN1Sequence *_certs;
    ASN1Sequence *_policies;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *certs;
@property (nonatomic, readwrite, retain) ASN1Sequence *policies;

+ (SigningCertificateV2 *)getInstance:(id)paramObject;
- (instancetype)initParamESSCertIDv2:(ESSCertIDv2 *)paramESSCertIDv2;
- (instancetype)initParamArrayOfESSCertIDv2:(NSMutableArray *)paramArrayOfESSCertIDv2;
- (instancetype)initParamArrayOfESSCertIDv2:(NSMutableArray *)paramArrayOfESSCertIDv2 paramArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation;
- (NSMutableArray *)getCerts;
- (NSMutableArray *)getPolicies;
- (ASN1Primitive *)toASN1Primitive;

@end
