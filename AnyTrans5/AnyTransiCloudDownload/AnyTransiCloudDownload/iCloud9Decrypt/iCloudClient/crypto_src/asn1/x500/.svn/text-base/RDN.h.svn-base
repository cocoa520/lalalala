//
//  RDN.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Set.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"
#import "AttributeTypeAndValue.h"

@interface RDN : ASN1Object {
@private
    ASN1Set *_values;
}

+ (RDN *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamAttributeTypeAndValue:(AttributeTypeAndValue *)paramAttributeTypeAndValue;
- (instancetype)initParamArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue;
- (BOOL)isMultiValued;
- (int)size;
- (AttributeTypeAndValue *)getFirst;
- (NSMutableArray *)getTypeAndValues;
- (ASN1Primitive *)toASN1Primitive;

@end
