//
//  ECDSAPublicKey.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PublicKeyDataObject.h"
#import "ASN1Sequence.h"
#import "ASN1ObjectIdentifier.h"
#import "BigInteger.h"

@interface ECDSAPublicKey : PublicKeyDataObject {
@private
    ASN1ObjectIdentifier *_usage;
    BigInteger *_primeModulusP;
    BigInteger *_firstCoefA;
    BigInteger *_secondCoefB;
    NSMutableData *_basePointG;
    BigInteger *_orderOfBasePointR;
    NSMutableData *_publicPointY;
    BigInteger *_cofactorF;
    int _options;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2 paramBigInteger3:(BigInteger *)paramBigInteger3 paramArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramBigInteger4:(BigInteger *)paramBigInteger4 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2 paramInt:(int)paramInt;
- (ASN1ObjectIdentifier *)getUsage;
- (NSMutableData *)getBasePointG;
- (BigInteger *)getCofactorF;
- (BigInteger *)getFirstCoefA;
- (BigInteger *)getOrderOfBasePointR;
- (BigInteger *)getPrimeModulusP;
- (NSMutableData *)getPublicPointY;
- (BigInteger *)getSecondCoefB;
- (BOOL)hasParameters;
- (ASN1EncodableVector *)getASN1EncodableVector:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean;
- (ASN1Primitive *)toASN1Primitive;

@end
