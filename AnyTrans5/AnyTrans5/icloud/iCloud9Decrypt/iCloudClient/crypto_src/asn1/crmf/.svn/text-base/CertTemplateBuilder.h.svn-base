//
//  CertTemplateBuilder.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CertTemplate.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "X509Extensions.h"
#import "OptionalValidity.h"
#import "SubjectPublicKeyInfo.h"
#import "DERBitString.h"
#import "Extensions.h"

@interface CertTemplateBuilder : NSObject {
@private
    ASN1Integer *_version;
    ASN1Integer *_serialNumber;
    AlgorithmIdentifier *_signingAlg;
    X500Name *_issuer;
    OptionalValidity *_validity;
    X500Name *_subject;
    SubjectPublicKeyInfo *_publicKey;
    DERBitString *_issuerUID;
    DERBitString *_subjectUID;
    Extensions *_extensions;
}

- (CertTemplate *)build;
- (CertTemplateBuilder *)getVersion:(int)paramInt;
- (CertTemplateBuilder *)getSerialNumber:(ASN1Integer *)paramASN1Integer;
- (CertTemplateBuilder *)getSigningAlg:(AlgorithmIdentifier *)paramAlgorithmIdentifier;
- (CertTemplateBuilder *)getIssuer:(X500Name *)paramX500Name;
- (CertTemplateBuilder *)getValidity:(OptionalValidity *)paramOptionalValidity;
- (CertTemplateBuilder *)getSubject:(X500Name *)paramX500Name;
- (CertTemplateBuilder *)getPublicKey:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo;
- (CertTemplateBuilder *)getIssuerUID:(DERBitString *)paramDERBitString;
- (CertTemplateBuilder *)getSubjectUID:(DERBitString *)paramDERBitString;
- (CertTemplateBuilder *)getExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions;
- (CertTemplateBuilder *)getExtensionsParamExtensions:(Extensions *)paramExtensions;

@end
