//
//  CertRequest.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "CertTemplate.h"
#import "Controls.h"

@interface CertRequest : ASN1Object {
@private
    ASN1Integer *_certReqId;
    CertTemplate *_certTemplate;
    Controls *_controls;
}

+ (CertRequest *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt paramCertTemplate:(CertTemplate *)paramCertTemplate paramControls:(Controls *)paramControls;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramCertTemplate:(CertTemplate *)paramCertTemplate paramControls:(Controls *)paramControls;
- (ASN1Integer *)getCertReqId;
- (CertTemplate *)getCertTemplate;
- (Controls *)getControls;
- (ASN1Primitive *)toASN1Primitive;

@end
