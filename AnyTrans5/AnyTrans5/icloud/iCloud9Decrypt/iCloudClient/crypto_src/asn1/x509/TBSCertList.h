//
//  TBSCertList.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1TaggedObject.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "Time.h"
#import "Extensions.h"
#import "ASN1Sequence.h"

@interface TBSCertList : ASN1Object {
    ASN1Integer *_version;
    AlgorithmIdentifier *_signature;
    X500Name *_issuer;
    Time *_thisUpdate;
    Time *_nextUpdate;
    ASN1Sequence *_revokedCertificates;
    Extensions *_crlExtensions;
}

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signature;
@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) Time *thisUpdate;
@property (nonatomic, readwrite, retain) Time *nextUpdate;
@property (nonatomic, readwrite, retain) ASN1Sequence *revokedCertificates;
@property (nonatomic, readwrite, retain) Extensions *crlExtensions;

+ (TBSCertList *)getInstance:(id)paramObject;
+ (TBSCertList *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (int)getVersionNumber;
- (ASN1Integer *)getVersion;
- (AlgorithmIdentifier *)getSignature;
- (X500Name *)getIssuer;
- (Time *)getThisUpdate;
- (Time *)getNextUpdate;
- (NSMutableArray *)getRevokedCertificates;
- (NSEnumerator *)getRevokedCertificateEnumeration;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;

@end

@interface CRLEntry : ASN1Object {
    ASN1Sequence *_seq;
    Extensions *_crlEntryExtensions;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;
@property (nonatomic, readwrite, retain) Extensions *crlEntryExtensions;

+ (CRLEntry *)getInstance:(id)paramObject;
- (ASN1Integer *)getUserCertificate;
- (Time *)getRevocationDate;
- (Extensions *)getExtensions;
- (ASN1Primitive *)toASN1Primitive;
- (BOOL)hasExtensions;

@end

@interface EmptyEnumeration : NSEnumerator

- (BOOL)hasMoreElements;
- (id)nextElement;

@end

@interface RevokedCertificatesEnumeration : NSEnumerator {
@private
    NSEnumerator *_en;
}

- (instancetype)initParamEnumeration:(NSEnumerator *)paramEnumeration;
- (BOOL)hasMoreElements;
- (id)nextElement;

@end

