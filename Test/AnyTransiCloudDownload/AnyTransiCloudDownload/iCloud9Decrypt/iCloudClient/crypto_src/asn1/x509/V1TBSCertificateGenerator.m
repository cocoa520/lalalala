//
//  V1TBSCertificateGenerator.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "V1TBSCertificateGenerator.h"
#import "DERSequence.h"

@implementation V1TBSCertificateGenerator
@synthesize version = _version;
@synthesize serialNumber = _serialNumber;
@synthesize signature = _signature;
@synthesize issuer = _issuer;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize subject = _subject;
@synthesize subjectPublicKeyInfo = _subjectPublicKeyInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_serialNumber) {
        [_serialNumber release];
        _serialNumber = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_startDate) {
        [_startDate release];
        _startDate = nil;
    }
    if (_endDate) {
        [_endDate release];
        _endDate = nil;
    }
    if (_subject) {
        [_subject release];
        _subject = nil;
    }
    if (_subjectPublicKeyInfo) {
        [_subjectPublicKeyInfo release];
        _subjectPublicKeyInfo = nil;
    }
    [super dealloc];
#endif
}

- (TBSCertificate *)generateTBSCertificate {
    if (!self.serialNumber || !self.signature || !self.issuer || !self.startDate || !self.endDate || !self.subject || !self.subjectPublicKeyInfo) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"not all mandatory fields set in V1 TBScertificate generator" userInfo:nil];
    }
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector1 add:self.serialNumber];
    [localASN1EncodableVector1 add:self.signature];
    [localASN1EncodableVector1 add:self.issuer];
    ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector2 add:self.startDate];
    [localASN1EncodableVector2 add:self.endDate];
    ASN1Encodable *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
    [localASN1EncodableVector1 add:derSequence];
    [localASN1EncodableVector1 add:self.subject];
    [localASN1EncodableVector1 add:self.subjectPublicKeyInfo];
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1];
    TBSCertificate *tbs = [TBSCertificate getInstance:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (derSequence) [derSequence release]; derSequence = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    return tbs;
}

- (void)setIssuerParamX509Name:(X500Name *)paramX509Name {
    self.issuer = [X500Name getInstance:[paramX509Name toASN1Primitive]];
}

- (void)setStartDateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime {
    Time *startTime = [[Time alloc] initParamASN1Primitive:paramASN1UTCTime];
    self.startDate = startTime;
#if !__has_feature(objc_arc)
    if (startTime) [startTime release]; startTime = nil;
#endif
}

- (void)setEndDateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime {
    Time *endTime = [[Time alloc] initParamASN1Primitive:paramASN1UTCTime];
    self.endDate = endTime;
#if !__has_feature(objc_arc)
    if (endTime) [endTime release]; endTime = nil;
#endif
}

- (void)setSubjectParamX509Name:(X509Name *)paramX509Name {
    self.subject = [X500Name getInstance:[paramX509Name toASN1Primitive]];
}

@end
