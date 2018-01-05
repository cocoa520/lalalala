//
//  CertTemplate.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "OptionalValidity.h"
#import "SubjectPublicKeyInfo.h"
#import "DERBitString.h"
#import "Extensions.h"

@interface CertTemplate : ASN1Object {
@private
    ASN1Sequence *_seq;
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

+ (CertTemplate *)getInstance:(id)paramObject;
- (int)getVersion;
- (ASN1Integer *)getSerialNumber;
- (AlgorithmIdentifier *)getSigningAlg;
- (X500Name *)getIssuer;
- (OptionalValidity *)getValidity;
- (X500Name *)getSubject;
- (SubjectPublicKeyInfo *)getPublicKey;
- (DERBitString *)getIssuerUID;
- (DERBitString *)getSubjectUID;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
