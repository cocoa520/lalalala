//
//  X9FieldElement.h
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ECFieldElement.h"
#import "ASN1Primitive.h"

@interface X9FieldElement : ASN1Object {
@protected
    ECFieldElement *_f;
}

- (instancetype)initParamECFieldElement:(ECFieldElement *)paramECFieldElement;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 paramInt4:(int)paramInt4 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ECFieldElement *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
