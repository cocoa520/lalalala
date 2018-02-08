//
//  CRLAnnContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "CertificateList.h"

@interface CRLAnnContent : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (CRLAnnContent *)getInstance:(id)paramObject;
- (instancetype)initParamCertificateList:(CertificateList *)paramCertificateList;
- (NSMutableArray *)getCertificateLists;
- (ASN1Primitive *)toASN1Primitive;

@end
