//
//  RequestedCertificate.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RequestedCertificate.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"
#import "ASN1Sequence.h"

@interface RequestedCertificate ()

@property (nonatomic, readwrite, retain) Certificate *cert;
@property (nonatomic, readwrite, retain) NSMutableData *publicKeyCert;
@property (nonatomic, readwrite, retain) NSMutableData *attributeCert;

@end

@implementation RequestedCertificate
@synthesize cert = _cert;
@synthesize publicKeyCert = _publicKeyCert;
@synthesize attributeCert = _attributeCert;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_cert) {
        [_cert release];
        _cert = nil;
    }
    if (_publicKeyCert) {
        [_publicKeyCert release];
        _publicKeyCert = nil;
    }
    if (_attributeCert) {
        [_attributeCert release];
        _attributeCert = nil;
    }
    [super dealloc];
#endif
}

+ (int)certificate {
    static int _certificate = 0;
    @synchronized(self) {
        if (!_certificate) {
            _certificate = -1;
        }
    }
    return _certificate;
}

+ (int)publicKeyCertificate {
    static int _publicKeyCertificate = 0;
    @synchronized(self) {
        if (!_publicKeyCertificate) {
            _publicKeyCertificate = 0;
        }
    }
    return _publicKeyCertificate;
}

+ (int)attributeCertificate {
    static int _attributeCertificate = 0;
    @synchronized(self) {
        if (!_attributeCertificate) {
            _attributeCertificate = 1;
        }
    }
    return _attributeCertificate;
}

+ (RequestedCertificate *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[RequestedCertificate class]]) {
        return (RequestedCertificate *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[RequestedCertificate alloc] initParamCertificate:[Certificate getInstance:paramObject]] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[RequestedCertificate alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (RequestedCertificate *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    if (!paramBoolean) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"choice item must be explicitly tagged" userInfo:nil];
    }
    return [RequestedCertificate getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    if (self = [super init]) {
        if ([paramASN1TaggedObject getTagNo] == 0) {
            self.publicKeyCert = [[ASN1OctetString getInstance:paramASN1TaggedObject paramBoolean:YES] getOctets];
        }else if ([paramASN1TaggedObject getTagNo] == 1) {
            self.attributeCert = [[ASN1OctetString getInstance:paramASN1TaggedObject paramBoolean:YES] getOctets];
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag number: %d", [paramASN1TaggedObject getTagNo]] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertificate:(Certificate *)paramCertificate
{
    if (self = [super init]) {
        self.cert = paramCertificate;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1TaggedObject *tagged = [[DERTaggedObject alloc] initParamInt:paramInt paramASN1Encodable:encodable];
        [self initParamASN1TaggedObject:tagged];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (tagged) [tagged release]; tagged = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (int)getType {
    if (self.cert) {
        return -1;
    }
    if (self.publicKeyCert) {
        return 0;
    }
    return 1;
}

- (NSMutableData *)getCertificateBytes {
    if (self.cert) {
        @try {
            return [self.cert getEncoded];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"can't decode certificate: %@", exception.description] userInfo:nil];
        }
    }
    if (self.publicKeyCert) {
        return self.publicKeyCert;
    }
    return self.attributeCert;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.publicKeyCert) {
        ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:self.publicKeyCert];
        ASN1Primitive *primitive = [[[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        return primitive;
    }
    if (self.attributeCert) {
        ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:self.attributeCert];
        ASN1Primitive *primitive = [[[DERTaggedObject alloc] initParamInt:1 paramASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
        return primitive;
    }
    return [self.cert toASN1Primitive];
}

@end
