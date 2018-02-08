//
//  X9ECParameters.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X9ObjectIdentifiers.h"
#import "BigInteger.h"
#import "X9FieldID.h"
#import "X9ECPoint.h"
#import "ECCurve.h"
#import "X9Curve.h"

@interface X9ECParameters : X9ObjectIdentifiers {
@private
    BigInteger *_n;
    BigInteger *_h;
    X9FieldID *_fieldID;
    X9ECPoint *_g;
    ECCurve *_curve;
    NSMutableData *_seed;
}

- (ECCurve*)curve;

+ (X9ECParameters *)getInstance:(id)paramObject;
- (instancetype)init:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamECPoint:(ECPoint *)paramECPoint ECParamBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamX9ECPoint:(X9ECPoint *)paramX9ECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2;
- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamECPoint:(ECPoint *)paramECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2;
- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamX9ECPoint:(X9ECPoint *)paramX9ECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2 ECParamArrayOfByte:(NSMutableData *)arrayOfByte;
- (instancetype)initX9ECParametersECCurve:(ECCurve *)paramECCurve ECParamECPoint:(ECPoint *)paramECPoint ECParamBigInteger1:(BigInteger *)paramBigInteger1 ECParamBigInteger2:(BigInteger *)paramBigInteger2 ECParamArrayOfByte:(NSMutableData *)arrayOfByte;

- (ECPoint *)getG;
- (X9Curve *)getCurveEntry;
- (BigInteger *)getN;
- (BigInteger *)getH;
- (NSMutableData *)getSeed;
- (X9FieldID *)getFieldIDEntry;
- (X9ECPoint *)getBaseEntry;
- (ASN1Primitive *)toASN1Primitive;

@end
