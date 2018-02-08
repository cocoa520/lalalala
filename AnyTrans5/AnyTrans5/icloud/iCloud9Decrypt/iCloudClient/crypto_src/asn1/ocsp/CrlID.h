//
//  CrlID.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERIA5String.h"
#import "ASN1Integer.h"
#import "ASN1GeneralizedTime.h"

@interface CrlID : ASN1Object {
@private
    DERIA5String *_crlUrl;
    ASN1Integer *_crlNum;
    ASN1GeneralizedTime *_crlTime;
}

+ (CrlID *)getInstance:(id)paramObject;
- (DERIA5String *)getCrlUrl;
- (ASN1Integer *)getCrlNum;
- (ASN1GeneralizedTime *)getCrlTime;
- (ASN1Primitive *)toASN1Primitive;

@end
