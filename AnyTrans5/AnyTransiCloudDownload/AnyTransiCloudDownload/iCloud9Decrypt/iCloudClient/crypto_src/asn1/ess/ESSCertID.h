//
//  ESSCertID.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "IssuerSerial.h"

@interface ESSCertID : ASN1Object {
@private
    ASN1OctetString *_certHash;
    IssuerSerial *_issuerSerial;
}

+ (ESSCertID *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramIssuerSerial:(IssuerSerial *)paramIssuerSerial;
- (NSMutableData *)getCertHash;
- (IssuerSerial *)getIssuerSerial;
- (ASN1Primitive *)toASN1Primitive;

@end
