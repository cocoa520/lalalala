//
//  AttributeCertificate.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AttributeCertificateInfo.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1Sequence.h"

@interface AttributeCertificate : ASN1Object {
    AttributeCertificateInfo *_acinfo;
    AlgorithmIdentifier *_signatureAlgorithm;
    DERBitString *_signatureValue;
}

@property (nonatomic, readwrite, retain) AttributeCertificateInfo *acinfo;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signatureAlgorithm;
@property (nonatomic, readwrite, retain) DERBitString *signatureValue;

+ (AttributeCertificate *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamAttributeCertificateInfo:(AttributeCertificateInfo *)paramAttributeCertificateInfo paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString;
- (AttributeCertificateInfo *)getAcinfo;
- (AlgorithmIdentifier *)getSignatureAlgorithm;
- (DERBitString *)getSignatureValue;
- (ASN1Primitive *)toASN1Primitive;

@end
