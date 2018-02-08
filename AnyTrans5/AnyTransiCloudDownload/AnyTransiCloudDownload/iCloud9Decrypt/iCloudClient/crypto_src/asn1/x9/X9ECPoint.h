//
//  X9ECPoint.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "ASN1OctetString.h"

@interface X9ECPoint : ASN1Object {
@private
    ASN1OctetString *_encoding;
    ECCurve *_c;
    ECPoint *_p;
}

- (instancetype)initParamECPoint:(ECPoint *)paramECPoint;
- (instancetype)initParamECPoint:(ECPoint *)paramECPoint paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamECCurve:(ECCurve *)paramECCurve paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamECCurve:(ECCurve *)paramECCurve paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (NSMutableData *)getPointEncoding;
- (ECPoint *)getPoint;
- (BOOL)isPointCompressed;
- (ASN1Primitive *)toASN1Primitive;

@end
