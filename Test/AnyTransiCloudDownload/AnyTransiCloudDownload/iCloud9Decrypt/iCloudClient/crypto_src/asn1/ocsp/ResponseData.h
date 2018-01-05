//
//  ResponseData.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ResponderID.h"
#import "ASN1GeneralizedTime.h"
#import "ASN1Sequence.h"
#import "Extensions.h"
#import "ASN1TaggedObject.h"
#import "X509Extensions.h"

@interface ResponseData : ASN1Object {
@private
    BOOL _versionPresent;
    ASN1Integer *_version;
    ResponderID *_responderID;
    ASN1GeneralizedTime *_producedAt;
    ASN1Sequence *_responses;
    Extensions *_responseExtensions;
}

+ (ResponseData *)getInstance:(id)paramObject;
+ (ResponseData *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramX509Extensions:(X509Extensions *)paramX509Extensions;
- (instancetype)initParamResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramExtensions:(Extensions *)paramExtensions;
- (ASN1Integer *)getVersion;
- (ResponderID *)getResponderID;
- (ASN1GeneralizedTime *)getProducedAt;
- (ASN1Sequence *)getResponses;
- (Extensions *)getResponseExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
