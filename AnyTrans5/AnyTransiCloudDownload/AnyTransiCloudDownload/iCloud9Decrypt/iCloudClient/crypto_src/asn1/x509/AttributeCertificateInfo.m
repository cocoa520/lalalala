//
//  AttributeCertificateInfo.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttributeCertificateInfo.h"
#import "DERSequence.h"

@interface AttributeCertificateInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) Holder *holder;
@property (nonatomic, readwrite, retain) AttCertIssuer *issuer;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signature;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) AttCertValidityPeriod *attrCertValidityPeriod;
@property (nonatomic, readwrite, retain) ASN1Sequence *attributes;
@property (nonatomic, readwrite, retain) DERBitString *issuerUniqueID;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation AttributeCertificateInfo
@synthesize version = _version;
@synthesize holder = _holder;
@synthesize issuer = _issuer;
@synthesize signature = _signature;
@synthesize serialNumber = _serialNumber;
@synthesize attrCertValidityPeriod = _attrCertValidityPeriod;
@synthesize attributes = _attributes;
@synthesize issuerUniqueID = _issuerUniqueID;
@synthesize extensions = _extensions;

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
    if (_attrCertValidityPeriod) {
        [_attrCertValidityPeriod release];
        _attrCertValidityPeriod = nil;
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
    [super dealloc];
#endif
}

+ (AttributeCertificateInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AttributeCertificateInfo class]]) {
        return (AttributeCertificateInfo *)paramObject;
    }
    if (paramObject) {
        return [[[AttributeCertificateInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (AttributeCertificateInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [AttributeCertificateInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 6) || ([paramASN1Sequence size] > 8)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        int i;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1Integer class]]) {
            self.version = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
            i = 1;
        }else {
            ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:0];
            self.version = versionInteger;
#if !__has_feature(objc_arc)
    if (versionInteger) [versionInteger release]; versionInteger = nil;
#endif
            i = 0;
        }
        self.holder = [Holder getInstance:[paramASN1Sequence getObjectAt:i]];
        self.issuer = [AttCertIssuer getInstance:[paramASN1Sequence getObjectAt:i + 1]];
        self.signature = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:i + 2]];
        self.serialNumber = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i + 3]];
        self.attrCertValidityPeriod = [AttCertValidityPeriod getInstance:[paramASN1Sequence getObjectAt:i + 4]];
        self.attributes = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:i + 5]];
        for (int j = i + 6; j < [paramASN1Sequence size]; j++) {
            ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:i];
            if ([localASN1Encodable isKindOfClass:[DERBitString class]]) {
                self.issuerUniqueID = [DERBitString getInstance:[paramASN1Sequence getObjectAt:j]];
            }else if (([localASN1Encodable isKindOfClass:[ASN1Sequence class]]) || ([localASN1Encodable isKindOfClass:[Extensions class]])) {
                self.extensions = [Extensions getInstance:[paramASN1Sequence getObjectAt:j]];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (Holder *)getHolder {
    return self.holder;
}

- (AttCertIssuer *)getIssuer {
    return self.issuer;
}

- (AlgorithmIdentifier *)getSignature {
    return self.signature;
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (AttCertValidityPeriod *)getAttrCertValidityPeriod {
    return self.attrCertValidityPeriod;
}

- (ASN1Sequence *)getAttributes {
    return self.attributes;
}

- (DERBitString *)getIssuerUniqueID {
    return self.issuerUniqueID;
}

- (Extensions *)getExtensions {
    return self.extensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if ([[self.version getValue] intValue]) {
        [localASN1EncodableVector add:self.version];
    }
    [localASN1EncodableVector add:self.holder];
    [localASN1EncodableVector add:self.issuer];
    [localASN1EncodableVector add:self.signature];
    [localASN1EncodableVector add:self.serialNumber];
    [localASN1EncodableVector add:self.attrCertValidityPeriod];
    [localASN1EncodableVector add:self.attributes];
    if (self.issuerUniqueID) {
        [localASN1EncodableVector add:self.issuerUniqueID];
    }
    if (self.extensions) {
        [localASN1EncodableVector add:self.extensions];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
