//
//  V2AttributeCertificateInfoGenerator.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "V2AttributeCertificateInfoGenerator.h"
#import "DERSequence.h"
#import "DERSet.h"

@interface V2AttributeCertificateInfoGenerator ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) Holder *holder;
@property (nonatomic, readwrite, retain) AttCertIssuer *issuer;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signature;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) ASN1EncodableVector *attributes;
@property (nonatomic, readwrite, retain) DERBitString *issuerUniqueID;
@property (nonatomic, readwrite, retain) Extensions *extensions;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *startDate;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *endDate;

@end

@implementation V2AttributeCertificateInfoGenerator
@synthesize version = _version;
@synthesize holder = _holder;
@synthesize issuer = _issuer;
@synthesize signature = _signature;
@synthesize serialNumber = _serialNumber;
@synthesize attributes = _attributes;
@synthesize issuerUniqueID = _issuerUniqueID;
@synthesize extensions = _extensions;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_holder) {
        [_holder release];
        _holder = nil;
    }
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
    if (_serialNumber) {
        [_serialNumber release];
        _serialNumber = nil;
    }
    if (_attributes) {
        [_attributes release];
        _attributes = nil;
    }
    if (_issuerUniqueID) {
        [_issuerUniqueID release];
        _issuerUniqueID = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    if (_startDate) {
        [_startDate release];
        _startDate = nil;
    }
    if (_endDate) {
        [_endDate release];
        _endDate = nil;
    }
    [super dealloc];
#endif
}

- (AttributeCertificateInfo *)generateAttributeCertificateInfo {
    if (!self.serialNumber || !self.signature || !self.issuer || !self.startDate || !self.endDate || !self.holder || !self.attributes) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"not all mandatory fields set in V2 AttributeCertificateInfo generator" userInfo:nil];
    }
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.holder];
    [localASN1EncodableVector add:self.issuer];
    [localASN1EncodableVector add:self.signature];
    [localASN1EncodableVector add:self.serialNumber];
    AttCertValidityPeriod *localAttCertValidityPeriod = [[AttCertValidityPeriod alloc] initParamASN1GeneralizedTime1:self.startDate paramASN1GeneralizedTime2:self.endDate];
    [localASN1EncodableVector add:localAttCertValidityPeriod];
    ASN1Encodable *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:self.attributes];
    [localASN1EncodableVector add:derSequence];
    if (self.issuerUniqueID) {
        [localASN1EncodableVector add:self.issuerUniqueID];
    }
    if (self.extensions) {
        [localASN1EncodableVector add:self.extensions];
    }
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    AttributeCertificateInfo *info = [AttributeCertificateInfo getInstance:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (localAttCertValidityPeriod) [localAttCertValidityPeriod release]; localAttCertValidityPeriod = nil;
    if (derSequence) [derSequence release]; derSequence = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    
    return info;
}

- (void)addAttribute:(NSString *)paramString paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    ASN1Set *set = [[DERSet alloc] initDERParamASN1Encodable:paramASN1Encodable];
    ASN1ObjectIdentifier *objectIdentifier = [[ASN1ObjectIdentifier alloc] initParamString:paramString];
    ASN1Encodable *encodable = [[AttributeX509 alloc] initParamASN1ObjectIdentifier:objectIdentifier paramASN1Set:set];
    [self.attributes add:encodable];
#if !__has_feature(objc_arc)
    if (set) [set release]; set = nil;
    if (objectIdentifier) [objectIdentifier release]; objectIdentifier = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
}

- (void)addAttribute:(AttributeX509 *)paramAttribute {
    [self.attributes add:paramAttribute];
}

- (void)setExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions {
    self.extensions = [Extensions getInstance:[paramX509Extensions toASN1Primitive]];
}

- (void)setAttributes:(ASN1EncodableVector *)attributes {
    if (_attributes != attributes) {
        _attributes = [[[ASN1EncodableVector alloc] init] autorelease];
    }
}

- (void)setVersion:(ASN1Integer *)version {
    if (_version != version) {
        _version = [[[ASN1Integer alloc] initLong:1] autorelease];
    }
}

@end
