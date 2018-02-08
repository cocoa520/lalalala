//
//  OtherKeyAttribute.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface OtherKeyAttribute : ASN1Object {
@private
    ASN1ObjectIdentifier *_keyAttrId;
    ASN1Encodable *_keyAttr;
}

+ (OtherKeyAttribute *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getKeyAttrId;
- (ASN1Encodable *)getKeyAttr;
- (ASN1Primitive *)toASN1Primitive;

@end
