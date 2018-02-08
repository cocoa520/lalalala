//
//  CertifiedKeyPair.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertOrEncCert.h"
#import "EncryptedValue.h"
#import "PKIPublicationInfo.h"

@interface CertifiedKeyPair : ASN1Object {
@private
    CertOrEncCert *_certOrEncCert;
    EncryptedValue *_privateKey;
    PKIPublicationInfo *_publicationInfo;
}

+ (CertifiedKeyPair *)getInstance:(id)paramObject;
- (instancetype)initParamCertOrEncCert:(CertOrEncCert *)paramCertOrEncCert;
- (instancetype)initParamCertOrEncCert:(CertOrEncCert *)paramCertOrEncCert paramEncryptedValue:(EncryptedValue *)paramEncryptedValue paramPKIPublicationInfo:(PKIPublicationInfo *)paramPKIPublicationInfo;
- (CertOrEncCert *)getCertOrEncCert;
- (EncryptedValue *)getPrivateKey;
- (PKIPublicationInfo *)getPublicationInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
