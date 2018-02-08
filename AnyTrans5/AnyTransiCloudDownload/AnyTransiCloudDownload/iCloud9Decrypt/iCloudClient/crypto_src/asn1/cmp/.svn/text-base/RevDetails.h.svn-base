//
//  RevDetails.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertTemplate.h"
#import "Extensions.h"
#import "X509Extensions.h"

@interface RevDetails : ASN1Object {
@private
    CertTemplate *_certDetails;
    Extensions *_crlEntryDetails;
}

+ (RevDetails *)getInstance:(id)paramObject;
- (instancetype)initParamCertTemplate:(CertTemplate *)paramCertTemplate;
- (instancetype)initParamCertTemplate:(CertTemplate *)paramCertTemplate paramX509Extensions:(X509Extensions *)paramX509Extensions;
- (instancetype)initParamCertTemplate:(CertTemplate *)paramCertTemplate paramExtensions:(Extensions *)paramExtensions;
- (CertTemplate *)getCertDetails;
- (Extensions *)getCrlEntryDetails;
- (ASN1Primitive *)toASN1Primitive;

@end
