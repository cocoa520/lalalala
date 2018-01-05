//
//  CertificationRequestInfo.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "X500Name.h"
#import "X509Name.h"
#import "SubjectPublicKeyInfo.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"

@interface CertificationRequestInfo : ASN1Object {
    ASN1Integer *_version;
    X500Name *_subject;
    SubjectPublicKeyInfo *_subjectPKInfo;
    ASN1Set *_attributes;
}

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) X500Name *subject;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *subjectPKInfo;
@property (nonatomic, readwrite, retain) ASN1Set *attributes;

+ (CertificationRequestInfo *)getInstance:(id)paramObject;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo paramASN1Set:(ASN1Set *)paramASN1Set;
- (instancetype)initParamX509Name:(X509Name *)paramX509Name paramSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo paramASN1Set:(ASN1Set *)paramASN1Set;
- (ASN1Integer *)getVersion;
- (X500Name *)getSubject;
- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo;
- (ASN1Set *)getAttributes;
- (ASN1Primitive *)toASN1Primitive;

@end
