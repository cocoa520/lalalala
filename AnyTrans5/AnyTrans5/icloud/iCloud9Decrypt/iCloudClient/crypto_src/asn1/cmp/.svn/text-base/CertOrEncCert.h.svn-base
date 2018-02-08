//
//  CertOrEncCert.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "CMPCertificate.h"
#import "EncryptedValue.h"

@interface CertOrEncCert : ASN1Choice {
@private
    CMPCertificate *_certificate;
    EncryptedValue *_encryptedCert;
}

+ (CertOrEncCert *)getInstance:(id)paramObject;
- (instancetype)initParamCMPCertificate:(CMPCertificate *)paramCMPCertificate;
- (instancetype)initParamEncryptedValue:(EncryptedValue *)paramEncryptedValue;
- (CMPCertificate *)getCertificate;
- (EncryptedValue *)getEncryptedCert;
- (ASN1Primitive *)toASN1Primitive;

@end
