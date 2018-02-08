//
//  SignerInfo.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "IssuerAndSerialNumber.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Set.h"
#import "ASN1OctetString.h"
#import "ASN1Sequence.h"

@interface SignerInfo : ASN1Object {
@private
    ASN1Integer *_version;
    IssuerAndSerialNumber *_issuerAndSerialNumber;
    AlgorithmIdentifier *_digAlgorithm;
    ASN1Set *_authenticatedAttributes;
    AlgorithmIdentifier *_digEncryptionAlgorithm;
    ASN1OctetString *_encryptedDigest;
    ASN1Set *_unauthenticatedAttributes;
}

+ (SignerInfo *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramIssuerAndSerialNumber:(IssuerAndSerialNumber *)paramIssuerAndSerialNumber paramAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramASN1Set1:(ASN1Set *)paramASN1Set1 paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2 paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramASN1Set2:(ASN1Set *)paramASN1Set2;
- (ASN1Integer *)getVersion;
- (IssuerAndSerialNumber *)getIssuerAndSerialNumber;
- (ASN1Set *)getAuthenticatedAttributes;
- (AlgorithmIdentifier *)getDigestAlgorithm;
- (ASN1OctetString *)getEncryptedDigest;
- (AlgorithmIdentifier *)getDigestEncryptionAlgorithm;
- (ASN1Set *)getUnauthenticatedAttributes;
- (ASN1Primitive *)toASN1Primitive;

@end
