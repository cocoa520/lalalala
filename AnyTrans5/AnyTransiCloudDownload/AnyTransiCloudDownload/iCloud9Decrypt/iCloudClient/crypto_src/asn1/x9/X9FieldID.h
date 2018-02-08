//
//  X9FieldID.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ObjectIdentifiers.h"
#import "BigInteger.h"
#import "ASN1Primitive.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface X9FieldID : X9ObjectIdentifiers {
@private
    ASN1ObjectIdentifier *_id;
    ASN1Primitive *_parameters;
}

+ (X9FieldID *)getInstance:(id)paramObject;

- (instancetype)initParamBI:(BigInteger *)paramBigInteger;
- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (instancetype)initParamInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 paramInt4:(int)paramInt4;
- (ASN1ObjectIdentifier *)getIdentifier;
- (ASN1Primitive *)getParameters;
- (ASN1Primitive *)toASN1Primitive;

@end
