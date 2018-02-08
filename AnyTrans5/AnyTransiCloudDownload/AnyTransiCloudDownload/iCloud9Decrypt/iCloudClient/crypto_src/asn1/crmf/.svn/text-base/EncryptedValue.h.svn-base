//
//  EncryptedValue.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1OctetString.h"

@interface EncryptedValue : ASN1Object {
@private
    AlgorithmIdentifier *_intendedAlg;
    AlgorithmIdentifier *_symmAlg;
    DERBitString *_encSymmKey;
    AlgorithmIdentifier *_keyAlg;
    ASN1OctetString *_valueHint;
    DERBitString *_encValue;
}

+ (EncryptedValue *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramDERBitString1:(DERBitString *)paramDERBitString1 paramAlgorithmIdentifier3:(AlgorithmIdentifier *)paramAlgorithmIdentifier3 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramDERBitString2:(DERBitString *)paramDERBitString2;
- (AlgorithmIdentifier *)getIntendedAlg;
- (AlgorithmIdentifier *)getSymmAlg;
- (DERBitString *)getEncSymmKey;
- (AlgorithmIdentifier *)getKeyAlg;
- (ASN1OctetString *)getValueHint;
- (DERBitString *)getEncValue;
- (ASN1Primitive *)toASN1Primitive;

@end
