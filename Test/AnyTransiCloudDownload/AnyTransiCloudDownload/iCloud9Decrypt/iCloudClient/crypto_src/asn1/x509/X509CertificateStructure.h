//
//  X509CertificateStructure.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509ObjectIdentifiers.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "TBSCertificateStructure.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1Integer.h"
#import "X500Name.h"
#import "Time.h"
#import "SubjectPublicKeyInfo.h"

@interface X509CertificateStructure : X509ObjectIdentifiers {
    ASN1Sequence *_seq;
    TBSCertificateStructure *_tbsCert;
    AlgorithmIdentifier *_sigAlgId;
    DERBitString *_sig;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;
@property (nonatomic, readwrite, retain) TBSCertificateStructure *tbsCert;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *sigAlgId;
@property (nonatomic, readwrite, retain) DERBitString *sig;

+ (X509CertificateStructure *)getInstance:(id)paramObject;
+ (X509CertificateStructure *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (TBSCertificateStructure *)getTBSCertificate;
- (int)getVersion;
- (ASN1Integer *)getSerialNumber;
- (X500Name *)getIssuer;
- (Time *)getStartDate;
- (Time *)getEndDate;
- (X500Name *)getSubject;
- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo;
- (AlgorithmIdentifier *)getSignatureAlgorithm;
- (DERBitString *)getSignature;
- (ASN1Primitive *)toASN1Primitive;

@end
