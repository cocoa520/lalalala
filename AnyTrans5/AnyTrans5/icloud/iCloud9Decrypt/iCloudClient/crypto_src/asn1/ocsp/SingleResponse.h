//
//  SingleResponse.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "CertID.h"
#import "CertStatus.h"
#import "ASN1GeneralizedTime.h"
#import "Extensions.h"
#import "ASN1TaggedObject.h"
#import "X509Extensions.h"

@interface SingleResponse : ASN1Object {
@private
    CertID *_certID;
    CertStatus *_certStatus;
    ASN1GeneralizedTime *_thisUpdate;
    ASN1GeneralizedTime *_nextUpdate;
    Extensions *_singleExtensions;
}

+ (SingleResponse *)getInstance:(id)paramObject;
+ (SingleResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamCertID:(CertID *)paramCertID paramCertStatus:(CertStatus *)paramCertStatus paramASN1GeneralizedTime1:(ASN1GeneralizedTime *)paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:(ASN1GeneralizedTime *)paramASN1GeneralizedTime2 paramX509Extensions:(X509Extensions *)paramX509Extensions;
- (instancetype)initParamCertID:(CertID *)paramCertID paramCertStatus:(CertStatus *)paramCertStatus paramASN1GeneralizedTime1:(ASN1GeneralizedTime *)paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:(ASN1GeneralizedTime *)paramASN1GeneralizedTime2 paramExtensions:(Extensions *)paramExtensions;

@end
