//
//  AttributePKCS.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"

@interface AttributePKCS : ASN1Object {
@private
    ASN1ObjectIdentifier *_attrType;
    ASN1Set *_attrValues;
}

+ (AttributePKCS *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Set:(ASN1Set *)paramASN1Set;
- (ASN1ObjectIdentifier *)getAttrType;
- (ASN1Set *)getAttrValues;
- (NSMutableArray *)getAttributeValues;

@end
