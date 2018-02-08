//
//  SignerLocation.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERUTF8String.h"
#import "ASN1Sequence.h"

@interface SignerLocation : ASN1Object {
@private
    DERUTF8String *_countryName;
    DERUTF8String *_localityName;
    ASN1Sequence *_postalAddress;
}

+ (SignerLocation *)getInstance:(id)paramObject;
- (instancetype)initParamDERUTF8String1:(DERUTF8String *)paramDERUTF8String1 paramDERUTF8String2:(DERUTF8String *)paramDERUTF8String2 paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (DERUTF8String *)getCountryName;
- (DERUTF8String *)getLocalityName;
- (ASN1Sequence *)getPostalAddress;
- (ASN1Primitive *)toASN1Primitive;

@end
