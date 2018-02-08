//
//  CertificateList.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "TBSCertList.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "X500Name.h"
#import "Time.h"

@interface CertificateList : ASN1Object {
    TBSCertList *_tbsCertList;
    AlgorithmIdentifier *_sigAlgId;
    DERBitString *_sig;
    BOOL _isHashCodeSet;
    int _hashCodeValue;
}

@property (nonatomic, readwrite, retain) TBSCertList *tbsCertList;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *sigAlgId;
@property (nonatomic, readwrite, retain) DERBitString *sig;
@property (nonatomic, assign) BOOL isHashCodeSet;
@property (nonatomic, assign) int hashCodeValue;

+ (CertificateList *)getInstance:(id)paramObject;
+ (CertificateList *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (TBSCertList *)getTBSCertList;
- (NSMutableArray *)getRevokedCertificates;
- (NSEnumerator *)getRevokedCertificateEnumeration;
- (AlgorithmIdentifier *)getSignatureAlgorithm;
- (DERBitString *)getSignature;
- (int)getVersionNumber;
- (X500Name *)getIssuer;
- (Time *)getThisUpdate;
- (Time *)getNextUpdate;
- (ASN1Primitive *)toASN1Primitive;

@end
