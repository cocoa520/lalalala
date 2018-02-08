//
//  CMPCertificate.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "Certificate.h"
#import "AttributeCertificate.h"

@interface CMPCertificate : ASN1Choice {
@private
    Certificate *_x509v3PKCert;
    int _otherTagValue;
    ASN1Object *_otherCert;
}

+ (CMPCertificate *)getInstance:(id)paramObject;
- (instancetype)initParamAttributeCertificate:(AttributeCertificate *)paramAttributeCertificate;
- (instancetype)initParamInt:(int)paramInt paramASN1Object:(ASN1Object *)paramASN1Object;
- (instancetype)initParamCertificate:(Certificate *)paramCertificate;
- (BOOL)isX509v3PKCert;
- (Certificate *)getX509v3PKCert;
- (AttributeCertificate *)getX509v2AttrCert;
- (int)getOtherCertTag;
- (ASN1Object *)getOtherCert;
- (ASN1Primitive *)toASN1Primitive;

@end
