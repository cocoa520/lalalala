//
//  V3TBSCertificateGenerator.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "V3TBSCertificateGenerator.h"
#import "DERSequence.h"

@interface V3TBSCertificateGenerator ()

@property (nonatomic, assign) BOOL altNamePresentAndCritical;
@property (nonatomic, readwrite, retain) DERBitString *issuerUniqueID;
@property (nonatomic, readwrite, retain) DERBitString *subjectUniqueID;

@end

@implementation V3TBSCertificateGenerator
@synthesize altNamePresentAndCritical = _altNamePresentAndCritical;
@synthesize issuerUniqueID = _issuerUniqueID;
@synthesize subjectUniqueID = _subjectUniqueID;
@synthesize serialNumber = _serialNumber;
@synthesize signature = _signature;
@synthesize issuer = _issuer;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize subject = _subject;
@synthesize subjectPublicKeyInfo = _subjectPublicKeyInfo;
@synthesize extensions = _extensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
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
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    [super dealloc];
#endif
}

+ (DERTaggedObject *)version {
    DERTaggedObject *_version = nil;
    @synchronized(self) {
        if (!_version) {
            ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:2];
            _version = [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        }
    }
    return _version;
}

- (TBSCertificate *)generateTBSCertificate {
    if (!self.serialNumber || !self.signature || !self.issuer || !self.startDate || !self.endDate || (!self.subject && !self.altNamePresentAndCritical) || !self.subjectPublicKeyInfo) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"not all mandatory fields set in V3 TBScertificate generator" userInfo:nil];
    }
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector1 add:[V3TBSCertificateGenerator version]];
    [localASN1EncodableVector1 add:self.serialNumber];
    [localASN1EncodableVector1 add:self.signature];
    [localASN1EncodableVector1 add:self.issuer];
    ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector2 add:self.startDate];
    [localASN1EncodableVector2 add:self.endDate];
    ASN1Encodable *derSequenceEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
    [localASN1EncodableVector1 add:derSequenceEncodable];
    if (self.subject) {
        [localASN1EncodableVector1 add:self.subject];
    }else {
        ASN1Encodable *encodable = [[DERSequence alloc] init];
        [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector1 add:self.subjectPublicKeyInfo];
    if (self.issuerUniqueID) {
        ASN1Encodable *issuerEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.issuerUniqueID];
        [localASN1EncodableVector1 add:issuerEncodable];
#if !__has_feature(objc_arc)
        if (issuerEncodable) [issuerEncodable release]; issuerEncodable = nil;
#endif
    }
    if (self.subjectUniqueID) {
        ASN1Encodable *subjectEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:2 paramASN1Encodable:self.subjectUniqueID];
        [localASN1EncodableVector1 add:subjectEncodable];
#if !__has_feature(objc_arc)
        if (subjectEncodable) [subjectEncodable release]; subjectEncodable = nil;
#endif
    }
    if (self.extensions) {
        ASN1Encodable *extensionsEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:3 paramASN1Encodable:self.extensions];
        [localASN1EncodableVector1 add:extensionsEncodable];
#if !__has_feature(objc_arc)
        if (extensionsEncodable) [extensionsEncodable release]; extensionsEncodable = nil;
#endif
    }
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1];
    TBSCertificate *tbs = [TBSCertificate getInstance:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (derSequenceEncodable) [derSequenceEncodable release]; derSequenceEncodable = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    return tbs;
}

- (void)setIssuerParamX509Name:(X509Name *)paramX509Name {
    self.issuer = [X500Name getInstance:paramX509Name];
}

- (void)setStartDateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime {
    self.startDate = [Time getInstance:paramASN1UTCTime];
}

- (void)setEndDateParamASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime {
    self.endDate = [Time getInstance:paramASN1UTCTime];
}

- (void)setSubjectParamX509Name:(X509Name *)paramX509Name {
    self.subject = [X500Name getInstance:[paramX509Name toASN1Primitive]];
}

- (void)setExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions {
    [self setExtensionsParamExtensions:[Extensions getInstance:paramX509Extensions]];
}

- (void)setExtensionsParamExtensions:(Extensions *)paramExtensions {
    self.extensions = paramExtensions;
    if (paramExtensions) {
        Extension *localExtension = [paramExtensions getExtension:[Extension subjectAlternativeName]];
        if (localExtension && [localExtension isCritical]) {
            self.altNamePresentAndCritical = YES;
        }
    }
}

@end
