//
//  Certificate.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "TBSCertificate.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1TaggedObject.h"
#import "X500Name.h"
#import "Time.h"
#import "SubjectPublicKeyInfo.h"

@interface Certificate : ASN1Object {
    ASN1Sequence *_seq;
    TBSCertificate *_tbsCert;
    AlgorithmIdentifier *_sigAlgId;
    DERBitString *_sig;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;
@property (nonatomic, readwrite, retain) TBSCertificate *tbsCert;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *sigAlgId;
@property (nonatomic, readwrite, retain) DERBitString *sig;

+ (Certificate *)getInstance:(id)paramObject;
+ (Certificate *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (TBSCertificate *)getTBSCertificate;
- (ASN1Integer *)getVersion;
- (int)getVersionNumber;
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
