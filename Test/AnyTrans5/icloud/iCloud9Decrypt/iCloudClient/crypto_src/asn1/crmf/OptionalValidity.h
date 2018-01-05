//
//  OptionalValidity.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "Time.h"

@interface OptionalValidity : ASN1Object {
@private
    Time *_notBefore;
    Time *_notAfter;
}

+ (OptionalValidity *)getInstance:(id)paramObject;
- (instancetype)initParamTime1:(Time *)paramTime1 paramTime2:(Time *)paramTime2;
- (Time *)getNotBefore;
- (Time *)getNotAfter;
- (ASN1Primitive *)toASN1Primitive;

@end
