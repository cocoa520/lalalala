//
//  V3TBSCertificateGenerator.h
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DERTaggedObject.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"
#import "X500Name.h"
#import "X509Name.h"
#import "Time.h"
#import "SubjectPublicKeyInfo.h"
#import "Extensions.h"
#import "TBSCertificate.h"
#import "ASN1UTCTime.h"
#import "X509Extensions.h"

@interface V3TBSCertificateGenerator : NSObject {
@private
    BOOL _altNamePresentAndCritical;
    DERBitString *_issuerUniqueID;
    DERBitString *_subjectUniqueID;
@public
    ASN1Integer *_serialNumber;
    AlgorithmIdentifier *_signature;
    X500Name *_issuer;
    Time *_startDate;
    Time *_endDate;
    X500Name *_subject;
    SubjectPublicKeyInfo *_subjectPublicKeyInfo;
    Extensions *_extensions;
}

@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signature;
@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) Time *startDate;
@property (nonatomic, readwrite, retain) Time *endDate;
@property (nonatomic, readwrite, retain) X500Name *subject;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *subjectPublicKeyInfo;
@property (nonatomic, readwrite, retain) Extensions *extensions;

+ (DERTaggedObject *)version;
- (TBSCertificate *)generateTBSCertificate;
- (void)setIssuerParamX509Name:(X509Name *)paramX509Name;
- (void)setStartDateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime;
- (void)setEndDateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime;
- (void)setSubjectParamX509Name:(X509Name *)paramX509Name;
- (void)setExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions;
- (void)setExtensionsParamExtensions:(Extensions *)paramExtensions;

@end
