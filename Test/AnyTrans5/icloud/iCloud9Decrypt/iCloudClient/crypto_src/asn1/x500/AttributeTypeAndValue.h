//
//  AttributeTypeAndValue.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface AttributeTypeAndValue : ASN1Object {
@private
    ASN1ObjectIdentifier *_type;
    ASN1Encodable *_value;
}

+ (AttributeTypeAndValue *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getType;
- (ASN1Encodable *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
