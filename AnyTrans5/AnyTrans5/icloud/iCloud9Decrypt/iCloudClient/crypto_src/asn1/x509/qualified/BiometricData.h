//
//  BiometricData.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "TypeOfBiometricData.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"
#import "DERIA5String.h"

@interface BiometricData : ASN1Object {
@private
    TypeOfBiometricData *_typeOfBiometricData;
    AlgorithmIdentifier *_hashAlgorithm;
    ASN1OctetString *_biometricDataHash;
    DERIA5String *_sourceDataUri;
}

+ (BiometricData *)getInstance:(id)paramObject;
- (instancetype)initParamTypeOfBiometricData:(TypeOfBiometricData *)paramTypeOfBiometricData paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamTypeOfBiometricData:(TypeOfBiometricData *)paramTypeOfBiometricData paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramDERIA5String:(DERIA5String *)paramDERIA5String;
- (TypeOfBiometricData *)getTypeOfBiometricData;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (ASN1OctetString *)getBiometricDataHash;
- (DERIA5String *)getSourceDataUri;
- (ASN1Primitive *)toASN1Primitive;

@end
