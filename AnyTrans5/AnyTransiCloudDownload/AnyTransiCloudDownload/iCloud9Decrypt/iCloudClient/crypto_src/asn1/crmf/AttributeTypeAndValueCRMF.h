//
//  AttributeTypeAndValueCRMF.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface AttributeTypeAndValueCRMF : ASN1Object {
@private
    ASN1ObjectIdentifier *_type;
    ASN1Encodable *_value;
}

+ (AttributeTypeAndValueCRMF *)getInstance:(id)paramObject;
- (instancetype)initParamString:(NSString *)paramString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getType;
- (ASN1Encodable *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
