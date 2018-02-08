//
//  AttributeX509.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Set.h"

@interface AttributeX509 : ASN1Object {
@private
    ASN1ObjectIdentifier *_attrType;
    ASN1Set *_attrValues;
}

+ (AttributeX509 *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Set:(ASN1Set *)paramASN1Set;
- (ASN1ObjectIdentifier *)getAttrType;
- (NSMutableArray *)getAttributeValues;
- (ASN1Set *)getAttrValues;
- (ASN1Primitive *)toASN1Primitive;

@end
