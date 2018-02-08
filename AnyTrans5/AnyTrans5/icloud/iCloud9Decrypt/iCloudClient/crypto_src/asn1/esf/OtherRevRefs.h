//
//  OtherRevRefs.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface OtherRevRefs : ASN1Object {
@private
    ASN1ObjectIdentifier *_otherRevRefType;
    ASN1Encodable *_otherRevRefs;
}

+ (OtherRevRefs *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getOtherRevRefType;
- (ASN1Encodable *)getOtherRevRefs;
- (ASN1Primitive *)toASN1Primitive;

@end
