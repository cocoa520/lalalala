//
//  CertificatePair.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "Certificate.h"

@interface CertificatePair : ASN1Object {
@private
    Certificate *_forward;
    Certificate *_reverse;
}

+ (CertificatePair *)getInstance:(id)paramObject;
- (instancetype)initParamCertificate1:(Certificate *)paramCertificate1 paramCertificate2:(Certificate *)paramCertificate2;
- (Certificate *)getForward;
- (Certificate *)getReverse;
- (ASN1Primitive *)toASN1Primitive;

@end
