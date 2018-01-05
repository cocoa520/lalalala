//
//  PBKDF2Params.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"

@interface PBKDF2Params : ASN1Object {
@private
    ASN1OctetString *_octStr;
    ASN1Integer *_iterationCount;
    ASN1Integer *_keyLength;
    AlgorithmIdentifier *_prf;
}

+ (PBKDF2Params *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier;
- (NSMutableData *)getSalt;
- (BigInteger *)getIterationCount;
- (BigInteger *)getKeyLength;
- (BOOL)isDefaultPrf;
- (AlgorithmIdentifier *)getPrf;
- (ASN1Primitive *)toASN1Primitive;

@end
