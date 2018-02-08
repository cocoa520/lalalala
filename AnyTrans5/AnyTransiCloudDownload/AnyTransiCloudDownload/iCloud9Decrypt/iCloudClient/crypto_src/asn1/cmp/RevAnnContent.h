//
//  RevAnnContent.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PKIStatus.h"
#import "CertIdCRMF.h"
#import "ASN1GeneralizedTime.h"
#import "Extensions.h"

@interface RevAnnContent : ASN1Object {
@private
    PKIStatus *_status;
    CertIdCRMF *_certId;
    ASN1GeneralizedTime *_willBeRevokedAt;
    ASN1GeneralizedTime *_badSinceDate;
    Extensions *_crlDetails;
}

+ (RevAnnContent *)getInstance:(id)paramObject;
- (PKIStatus *)getStatus;
- (CertIdCRMF *)getCertId;
- (ASN1GeneralizedTime *)getWillBeRevodedAt;
- (ASN1GeneralizedTime *)getBadSinceDate;
- (Extensions *)getCrlDetails;
- (ASN1Primitive *)toASN1Primitive;

@end
