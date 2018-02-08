//
//  CMPCertificate.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CMPCertificate.h"
#import "DERTaggedObject.h"

@interface CMPCertificate ()

@property (nonatomic, readwrite, retain) Certificate *x509v3PKCert;
@property (nonatomic, assign) int otherTagValue;
@property (nonatomic, readwrite, retain) ASN1Object *otherCert;

@end

@implementation CMPCertificate
@synthesize x509v3PKCert = _x509v3PKCert;
@synthesize otherTagValue = _otherTagValue;
@synthesize otherCert = _otherCert;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_x509v3PKCert) {
        [_x509v3PKCert release];
        _x509v3PKCert = nil;
    }
    if (_otherCert) {
        [_otherCert release];
        _otherCert = nil;
    }
    [super dealloc];
#endif
}

+ (CMPCertificate *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[CMPCertificate class]]) {
        return (CMPCertificate *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            paramObject = [ASN1Primitive fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid encoding in CMPCertificate" userInfo:nil];
        }
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[CMPCertificate alloc] initParamCertificate:[Certificate getInstance:paramObject]] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)paramObject;
        return [[[CMPCertificate alloc] initParamInt:[localASN1TaggedObject getTagNo] paramASN1Object:[localASN1TaggedObject getObject]] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid object: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamAttributeCertificate:(AttributeCertificate *)paramAttributeCertificate
{
    if (self = [super init]) {
        [self initParamInt:1 paramASN1Object:paramAttributeCertificate];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramASN1Object:(ASN1Object *)paramASN1Object
{
    if (self = [super init]) {
        self.otherTagValue = paramInt;
        self.otherCert = paramASN1Object;
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
        if ([paramCertificate getVersionNumber] != 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"only version 3 certificates allowed" userInfo:nil];
        }
        self.x509v3PKCert = paramCertificate;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isX509v3PKCert {
    return self.x509v3PKCert != nil;
}

- (Certificate *)getX509v3PKCert {
    return self.x509v3PKCert;
}

- (AttributeCertificate *)getX509v2AttrCert {
    return [AttributeCertificate getInstance:self.otherCert];
}

- (int)getOtherCertTag {
    return self.otherTagValue;
}

- (ASN1Object *)getOtherCert {
    return self.otherCert;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.otherCert) {
        return [[[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:self.otherTagValue paramASN1Encodable:self.otherCert] autorelease];
    }
    return [self.x509v3PKCert toASN1Primitive];
}

@end
