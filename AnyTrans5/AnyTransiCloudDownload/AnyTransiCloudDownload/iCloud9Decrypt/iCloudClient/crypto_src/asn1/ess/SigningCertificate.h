//
//  SigningCertificate.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ESSCertID.h"

@interface SigningCertificate : ASN1Object {
    ASN1Sequence *_certs;
    ASN1Sequence *_policies;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *certs;
@property (nonatomic, readwrite, retain) ASN1Sequence *policies;

+ (SigningCertificate *)getInstance:(id)paramObject;
- (instancetype)initParamESSCertID:(ESSCertID *)paramESSCertID;
- (NSMutableArray *)getCerts;
- (NSMutableArray *)getPolicies;
- (ASN1Primitive *)toASN1Primitive;

@end
