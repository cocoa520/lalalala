//
//  CertificationRequest.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertificationRequestInfo.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1Sequence.h"

@interface CertificationRequest : ASN1Object {
    CertificationRequestInfo *_reqInfo;
    AlgorithmIdentifier *_sigAlgId;
    DERBitString *_sigBits;
}

@property (nonatomic, readwrite, retain) CertificationRequestInfo *reqInfo;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *sigAlgId;
@property (nonatomic, readwrite, retain) DERBitString *sigBits;

+ (CertificationRequest *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamCertificationRequestInfo:(CertificationRequestInfo *)paramCertificationRequestInfo paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString;
- (CertificationRequestInfo *)getCertificationRequestInfo;
- (AlgorithmIdentifier *)getSignatureAlgorithm;
- (DERBitString *)getSignature;
- (ASN1Primitive *)toASN1Primitive;

@end
