//
//  CertReqMsg.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertRequest.h"
#import "ProofOfPossession.h"
#import "ASN1Sequence.h"

@interface CertReqMsg : ASN1Object {
@private
    CertRequest *_certReq;
    ProofOfPossession *_pop;
    ASN1Sequence *_regInfo;
}

+ (CertReqMsg *)getInstance:(id)paramObject;
- (instancetype)initParamCertRequest:(CertRequest *)paramCertRequest paramProofOfPossession:(ProofOfPossession *)paramProofOfPossession paramArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue;
- (CertRequest *)getCertReq;
- (ProofOfPossession *)getPop;
- (ProofOfPossession *)getPopo;
- (NSMutableArray *)getReqInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
