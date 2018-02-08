//
//  Attribute.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Set.h"

@interface Attribute : ASN1Object {
@private
    ASN1ObjectIdentifier *_attrType;
    ASN1Set *_attrValues;
}

+ (Attribute *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Set:(ASN1Set *)paramASN1Set;
- (ASN1ObjectIdentifier *)getAttrType;
- (ASN1Set *)getAttrValues;
- (NSMutableArray *)getAttributeValues;
- (ASN1Primitive *)toASN1Primitive;

@end
