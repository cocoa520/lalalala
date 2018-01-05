//
//  KeySpecificInfo.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1OctetString.h"

@interface KeySpecificInfo : ASN1Object {
@private
    ASN1ObjectIdentifier *_algorithm;
    ASN1OctetString *_counter;
}

+ (KeySpecificInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;

@end
