//
//  ESSCertIDv2.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "IssuerSerial.h"

@interface ESSCertIDv2 : ASN1Object {
@private
    AlgorithmIdentifier *_hashAlgorithm;
    NSMutableData *_certHash;
    IssuerSerial *_issuerSerial;
}

+ (ESSCertIDv2 *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte paramIssuerSerial:(IssuerSerial *)paramIssuerSerial;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (NSMutableData *)getCertHash;
- (IssuerSerial *)getIssuerSerial;
- (ASN1Primitive *)toASN1Primitive;

@end
