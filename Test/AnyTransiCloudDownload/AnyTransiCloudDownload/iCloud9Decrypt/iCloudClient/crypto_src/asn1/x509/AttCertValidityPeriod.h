//
//  AttCertValidityPeriod.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1GeneralizedTime.h"

@interface AttCertValidityPeriod : ASN1Object {
    ASN1GeneralizedTime *_notBeforeTime;
    ASN1GeneralizedTime *_notAfterTime;
}

@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *notBeforeTime;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *notAfterTime;

+ (AttCertValidityPeriod *)getInstance:(id)paramObject;
- (instancetype)initParamASN1GeneralizedTime1:(ASN1GeneralizedTime *)paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:(ASN1GeneralizedTime *)paramASN1GeneralizedTime2;
- (ASN1GeneralizedTime *)getNotBeforeTime;
- (ASN1GeneralizedTime *)getNotAfterTime;
- (ASN1Primitive *)toASN1Primitive;

@end
