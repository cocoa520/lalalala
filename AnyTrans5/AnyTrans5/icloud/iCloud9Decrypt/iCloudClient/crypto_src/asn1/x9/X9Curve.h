//
//  X9Curve.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ObjectIdentifiers.h"
#import "ECCurve.h"
#import "ASN1ObjectIdentifier.h"
#import "X9FieldID.h"

@interface X9Curve : X9ObjectIdentifiers {
@private
    ECCurve *_curve;
    NSMutableData *_seed;
    ASN1ObjectIdentifier *_fieldIdentifier;
}

- (instancetype)initParamECCurve:(ECCurve *)paramECCurve;
- (instancetype)initParamECCurve:(ECCurve *)paramECCurve paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamECCurve:(X9FieldID *)paramX9FieldID paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;

- (ECCurve *)getCurve;
- (NSMutableData *)getSeed;
- (ASN1Primitive *)toASN1Primitive;

@end
