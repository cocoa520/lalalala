//
//  Controls.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "AttributeTypeAndValueCRMF.h"

@interface Controls : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (Controls *)getInstance:(id)paramObject;
- (instancetype)initParamAttributeTypeAndValue:(AttributeTypeAndValueCRMF *)paramAttributeTypeAndValue;
- (instancetype)initParamArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue;
- (NSMutableArray *)toAttributeTypeAndValueArray;
- (ASN1Primitive *)toASN1Primitive;

@end
