//
//  CertTemplateBuilder.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertTemplateBuilder.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface CertTemplateBuilder ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signingAlg;
@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) OptionalValidity *validity;
@property (nonatomic, readwrite, retain) X500Name *subject;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *publicKey;
@property (nonatomic, readwrite, retain) DERBitString *issuerUID;
@property (nonatomic, readwrite, retain) DERBitString *subjectUID;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end


@implementation CertTemplateBuilder
@synthesize version = _version;
@synthesize serialNumber = _serialNumber;
@synthesize signingAlg = _signingAlg;
@synthesize issuer = _issuer;
@synthesize validity = _validity;
@synthesize subject = _subject;
@synthesize publicKey = _publicKey;
@synthesize issuerUID = _issuerUID;
@synthesize subjectUID = _subjectUID;
@synthesize extensions = _extensions;

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
    if (_signingAlg) {
        [_signingAlg release];
        _signingAlg = nil;
    }
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_validity) {
        [_validity release];
        _validity = nil;
    }
    if (_subject) {
        [_subject release];
        _subject = nil;
    }
    if (_publicKey) {
        [_publicKey release];
        _publicKey = nil;
    }
    if (_issuerUID) {
        [_issuerUID release];
        _issuerUID = nil;
    }
    if (_subjectUID) {
        [_subjectUID release];
        _subjectUID = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    [super dealloc];
#endif
}

- (CertTemplate *)build {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [self addOptional:localASN1EncodableVector paramInt:0 paramBoolean:false paramASN1Encodable:self.version];
    [self addOptional:localASN1EncodableVector paramInt:1 paramBoolean:false paramASN1Encodable:self.serialNumber];
    [self addOptional:localASN1EncodableVector paramInt:2 paramBoolean:false paramASN1Encodable:self.signingAlg];
    [self addOptional:localASN1EncodableVector paramInt:3 paramBoolean:TRUE paramASN1Encodable:self.issuer];
    [self addOptional:localASN1EncodableVector paramInt:4 paramBoolean:false paramASN1Encodable:self.validity];
    [self addOptional:localASN1EncodableVector paramInt:5 paramBoolean:TRUE paramASN1Encodable:self.subject];
    [self addOptional:localASN1EncodableVector paramInt:6 paramBoolean:false paramASN1Encodable:self.publicKey];
    [self addOptional:localASN1EncodableVector paramInt:7 paramBoolean:false paramASN1Encodable:self.issuerUID];
    [self addOptional:localASN1EncodableVector paramInt:8 paramBoolean:false paramASN1Encodable:self.subjectUID];
    [self addOptional:localASN1EncodableVector paramInt:9 paramBoolean:false paramASN1Encodable:self.extensions];
    DERSequence *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    CertTemplate *template = [CertTemplate getInstance:derSequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (derSequence) [derSequence release]; derSequence = nil;
#endif
    return template;
}

- (CertTemplateBuilder *)getVersion:(int)paramInt {
    ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
    self.version = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
    return self;
}

- (CertTemplateBuilder *)getSerialNumber:(ASN1Integer *)paramASN1Integer {
    self.serialNumber = paramASN1Integer;
    return self;
}

- (CertTemplateBuilder *)getSigningAlg:(AlgorithmIdentifier *)paramAlgorithmIdentifier {
    self.signingAlg = paramAlgorithmIdentifier;
    return self;
}

- (CertTemplateBuilder *)getIssuer:(X500Name *)paramX500Name {
    self.issuer = paramX500Name;
    return self;
}

- (CertTemplateBuilder *)getValidity:(OptionalValidity *)paramOptionalValidity {
    self.validity = paramOptionalValidity;
    return self;
}

- (CertTemplateBuilder *)getSubject:(X500Name *)paramX500Name {
    self.subject = paramX500Name;
    return self;
}

- (CertTemplateBuilder *)getPublicKey:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo {
    self.publicKey = paramSubjectPublicKeyInfo;
    return self;
}

- (CertTemplateBuilder *)getIssuerUID:(DERBitString *)paramDERBitString {
    self.issuerUID = paramDERBitString;
    return self;
}

- (CertTemplateBuilder *)getSubjectUID:(DERBitString *)paramDERBitString {
    self.subjectUID = paramDERBitString;
    return self;
}

- (CertTemplateBuilder *)getExtensionsParamX509Extensions:(X509Extensions *)paramX509Extensions {
    return [self getExtensionsParamExtensions:[Extensions getInstance:paramX509Extensions]];
}

- (CertTemplateBuilder *)getExtensionsParamExtensions:(Extensions *)paramExtensions {
    self.extensions = paramExtensions;
    return self;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:paramBoolean paramInt:paramInt paramASN1Encodable:paramASN1Encodable];
        [paramASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
}

@end
