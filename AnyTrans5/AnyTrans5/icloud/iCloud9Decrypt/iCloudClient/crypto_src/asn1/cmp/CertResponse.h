//
//  CertResponse.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "PKIStatusInfo.h"
#import "CertifiedKeyPair.h"
#import "ASN1OctetString.h"

@interface CertResponse : ASN1Object {
@private
    ASN1Integer *_certReqId;
    PKIStatusInfo *_status;
    CertifiedKeyPair *_certifiedKeyPair;
    ASN1OctetString *_rspInfo;
}

+ (CertResponse *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramCertifiedKeyPair:(CertifiedKeyPair *)paramCertifiedKeyPair paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1Integer *)getCertReqId;
- (PKIStatusInfo *)getStatus;
- (CertifiedKeyPair *)getCertifiedKeyPair;
- (ASN1Primitive *)toASN1Primitive;

@end
