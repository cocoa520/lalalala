//
//  PrivateKeyUsagePeriod.h
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1GeneralizedTime.h"

@interface PrivateKeyUsagePeriod : ASN1Object {
@private
    ASN1GeneralizedTime *_notBefore;
    ASN1GeneralizedTime *_notAfter;
}

+ (PrivateKeyUsagePeriod *)getInstance:(id)paramObject;
- (ASN1GeneralizedTime *)getNotBefore;
- (ASN1GeneralizedTime *)getNotAfter;
- (ASN1Primitive *)toASN1Primitive;

@end
