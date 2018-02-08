//
//  Attributes.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Set.h"

@interface Attributes : ASN1Object {
@private
    ASN1Set *_attributes;
}

+ (Attributes *)getInstance:(id)paramObject;
- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (NSMutableArray *)getAttributes;
- (ASN1Primitive *)toASN1Primitive;

@end
