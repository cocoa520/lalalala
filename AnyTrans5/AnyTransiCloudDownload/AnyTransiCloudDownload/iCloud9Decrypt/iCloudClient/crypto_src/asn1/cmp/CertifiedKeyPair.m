//
//  CertifiedKeyPair.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertifiedKeyPair.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface CertifiedKeyPair ()

@property (nonatomic, readwrite, retain) CertOrEncCert *certOrEncCert;
@property (nonatomic, readwrite, retain) EncryptedValue *privateKey;
@property (nonatomic, readwrite, retain) PKIPublicationInfo *publicationInfo;

@end

@implementation CertifiedKeyPair
@synthesize certOrEncCert = _certOrEncCert;
@synthesize privateKey = _privateKey;
@synthesize publicationInfo = _publicationInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certOrEncCert) {
        [_certOrEncCert release];
        _certOrEncCert = nil;
    }
    if (_privateKey) {
        [_privateKey release];
        _privateKey = nil;
    }
    if (_publicationInfo) {
        [_publicationInfo release];
        _publicationInfo = nil;
    }
    [super dealloc];
#endif
}

+ (CertifiedKeyPair *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertifiedKeyPair class]]) {
        return (CertifiedKeyPair *)paramObject;
    }
    if (paramObject) {
        return [[[CertifiedKeyPair alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.certOrEncCert = [CertOrEncCert getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] >= 2) {
            if ([paramASN1Sequence size] == 2) {
                ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:1]];
                if ([localASN1TaggedObject getTagNo] == 0) {
                    self.privateKey = [EncryptedValue getInstance:[localASN1TaggedObject getObject]];
                }else {
                    self.publicationInfo = [PKIPublicationInfo getInstance:[localASN1TaggedObject getObject]];
                }
            }else {
                self.privateKey = [EncryptedValue getInstance:[ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:1]]];
                self.publicationInfo = [PKIPublicationInfo getInstance:[ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:2]]];
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

- (instancetype)initParamCertOrEncCert:(CertOrEncCert *)paramCertOrEncCert
{
    if (self = [super init]) {
        [self initParamCertOrEncCert:paramCertOrEncCert paramEncryptedValue:nil paramPKIPublicationInfo:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertOrEncCert:(CertOrEncCert *)paramCertOrEncCert paramEncryptedValue:(EncryptedValue *)paramEncryptedValue paramPKIPublicationInfo:(PKIPublicationInfo *)paramPKIPublicationInfo
{
    if (self = [super init]) {
        if (!paramCertOrEncCert) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'certOrEncCert' cannot be null" userInfo:nil];
        }
        self.certOrEncCert = paramCertOrEncCert;
        self.privateKey = paramEncryptedValue;
        self.publicationInfo = paramPKIPublicationInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (CertOrEncCert *)getCertOrEncCert {
    return self.certOrEncCert;
}

- (EncryptedValue *)getPrivateKey {
    return self.privateKey;
}

- (PKIPublicationInfo *)getPublicationInfo {
    return self.publicationInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certOrEncCert];
    if (self.privateKey) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.privateKey];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.publicationInfo) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.publicationInfo];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
