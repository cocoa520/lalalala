//
//  TBSCertificate.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "Time.h"
#import "SubjectPublicKeyInfo.h"
#import "DERBitString.h"
#import "Extensions.h"

@interface TBSCertificate : ASN1Object {
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
    Extensions *_extensions;
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
@property (nonatomic, readwrite, retain) Extensions *extensions;

+ (TBSCertificate *)getInstance:(id)paramObject;
+ (TBSCertificate *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (int)getVersionNumber;
- (ASN1Integer *)getVersion;
- (ASN1Integer *)getSerialNumber;
- (AlgorithmIdentifier *)getSignature;
- (X500Name *)getIssuer;
- (Time *)getStartDate;
- (Time *)getEndDate;
- (X500Name *)getSubject;
- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo;
- (DERBitString *)getIssuerUniqueId;
- (DERBitString *)getSubjectUniqueId;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end
