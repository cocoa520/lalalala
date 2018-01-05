//
//  DSTU4145Params.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "DSTU4145ECBinary.h"

@interface DSTU4145Params : ASN1Object {
@private
    ASN1ObjectIdentifier *_namedCurve;
    DSTU4145ECBinary *_ecbinary;
    NSMutableData *_dke;
}

+ (DSTU4145Params *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamDSTU4145ECBinary:(DSTU4145ECBinary *)paramDSTU4145ECBinary;
- (BOOL)isNamedCurve;
- (DSTU4145ECBinary *)getECBinary;
- (NSMutableData *)getDKE;
+ (NSMutableData *)getDefaultDKE;
- (ASN1ObjectIdentifier *)getNamedCurve;
- (ASN1Primitive *)toASN1Primitive;

@end
