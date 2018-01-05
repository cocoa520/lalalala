//
//  OtherCertID.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Encodable.h"
#import "IssuerSerial.h"
#import "AlgorithmIdentifier.h"

@interface OtherCertID : ASN1Object {
@private
    ASN1Encodable *_otherCertHash;
    IssuerSerial *_issuerSerial;
}

+ (OtherCertID *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte paramIssuerSerial:(IssuerSerial *)paramIssuerSerial;
- (AlgorithmIdentifier *)getAlgorithmHash;
- (NSMutableData *)getCertHash;
- (IssuerSerial *)getIssuerSerial;
- (ASN1Primitive *)toASN1Primitive;

@end
