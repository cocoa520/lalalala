//
//  CertOrEncCert.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertOrEncCert.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"

@interface CertOrEncCert ()

@property (nonatomic, readwrite, retain) CMPCertificate *certificate;
@property (nonatomic, readwrite, retain) EncryptedValue *encryptedCert;

@end

@implementation CertOrEncCert
@synthesize certificate = _certificate;
@synthesize encryptedCert = _encryptedCert;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certificate) {
        [_certificate release];
        _certificate = nil;
    }
    if (_encryptedCert) {
        [_encryptedCert release];
        _encryptedCert = nil;
    }
    [super dealloc];
#endif
}

+ (CertOrEncCert *)getInstance:(id)paramObject{
    if ([paramObject isKindOfClass:[CertOrEncCert class]]) {
        return (CertOrEncCert *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[CertOrEncCert alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    if (self = [super init]) {
        if ([paramASN1TaggedObject getTagNo] == 0) {
            self.certificate = [CMPCertificate getInstance:[paramASN1TaggedObject getObject]];
        }else if ([paramASN1TaggedObject getTagNo] == 1) {
            self.encryptedCert = [EncryptedValue getInstance:[paramASN1TaggedObject getObject]];
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag: %d", [paramASN1TaggedObject getTagNo]] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCMPCertificate:(CMPCertificate *)paramCMPCertificate
{
    if (self = [super init]) {
        if (!paramCMPCertificate) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'certificate' cannot be null" userInfo:nil];
        }
        self.certificate = paramCMPCertificate;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamEncryptedValue:(EncryptedValue *)paramEncryptedValue
{
    if (self = [super init]) {
        if (!paramEncryptedValue) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'encryptedCert' cannot be null" userInfo:nil];
        }
        self.encryptedCert = paramEncryptedValue;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (CMPCertificate *)getCertificate {
    return self.certificate;
}

- (EncryptedValue *)getEncryptedCert {
    return self.encryptedCert;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.certificate) {
        return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.certificate] autorelease];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.encryptedCert] autorelease];
}

@end
