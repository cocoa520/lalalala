//
//  TBSCertificateStructure.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509ObjectIdentifiers.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "Time.h"
#import "SubjectPublicKeyInfo.h"
#import "DERBitString.h"
#import "X509Extensions.h"

@interface TBSCertificateStructure : X509ObjectIdentifiers {
    ASN1Sequence *_seq;
    ASN1Integer *_version;
    ASN1Integer *_serialNumber;
    AlgorithmIdentifier *_signature;
    X500Name *_issuer;
    Time *_startDate;
    Time *_endDate;
    X500Name *_subject;
    SubjectPublicKeyInfo *_subjectPublicKeyInfo;
    DERBitString *_issuerUniqueId;
    DERBitString *_subjectUniqueId;
    X509Extensions *_extensions;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;
@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signature;
@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) Time *startDate;
@property (nonatomic, readwrite, retain) Time *endDate;
@property (nonatomic, readwrite, retain) X500Name *subject;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *subjectPublicKeyInfo;
@property (nonatomic, readwrite, retain) DERBitString *issuerUniqueId;
@property (nonatomic, readwrite, retain) DERBitString *subjectUniqueId;
@property (nonatomic, readwrite, retain) X509Extensions *extensions;

+ (TBSCertificateStructure *)getInstance:(id)paramObject;
+ (TBSCertificateStructure *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (int)getVersion;
- (ASN1Integer *)getVersionNumber;
- (ASN1Integer *)getSerialNumber;
- (AlgorithmIdentifier *)getSignature;
- (X500Name *)getIssuer;
- (Time *)getStartDate;
- (Time *)getEndDate;
- (X500Name *)getSubject;
- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo;
- (DERBitString *)getIssuerUniqueId;
- (DERBitString *)getSubjectUniqueId;
- (X509Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
