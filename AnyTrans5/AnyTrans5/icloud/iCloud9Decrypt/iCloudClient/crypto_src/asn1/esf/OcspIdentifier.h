//
//  OcspIdentifier.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ResponderID.h"
#import "ASN1GeneralizedTime.h"

@interface OcspIdentifier : ASN1Object {
@private
    ResponderID *_ocspResponderID;
    ASN1GeneralizedTime *_producedAt;
}

+ (OcspIdentifier *)getInstance:(id)paramObject;
- (instancetype)initParamResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime;
- (ResponderID *)getOcspResponderID;
- (ASN1GeneralizedTime *)getProducedAt;
- (ASN1Primitive *)toASN1Primitive;

@end
