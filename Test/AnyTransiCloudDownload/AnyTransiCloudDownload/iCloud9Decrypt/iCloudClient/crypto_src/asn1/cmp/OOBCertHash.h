//
//  OOBCertHash.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "CertIdCRMF.h"
#import "DERBitString.h"

@interface OOBCertHash : ASN1Object {
@private
    AlgorithmIdentifier *_hashAlg;
    CertIdCRMF *_certId;
    DERBitString *_hashVal;
}

+ (OOBCertHash *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramCertId:(CertIdCRMF *)paramCertId paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramCertId:(CertIdCRMF *)paramCertId paramDERBitString:(DERBitString *)paramDERBitString;
- (AlgorithmIdentifier *)getHashAlg;
- (CertIdCRMF *)getCertId;
- (DERBitString *)getHashVal;
- (ASN1Primitive *)toASN1Primitive;

@end
