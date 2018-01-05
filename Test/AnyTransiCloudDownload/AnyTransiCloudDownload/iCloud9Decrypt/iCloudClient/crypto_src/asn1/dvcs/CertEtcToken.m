//
//  CertEtcToken.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertEtcToken.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"
#import "Certificate.h"
#import "ESSCertID.h"
#import "PKIStatusInfo.h"
#import "ContentInfo.h"
#import "CertificateList.h"
#import "CertStatus.h"
#import "CertID.h"
#import "OCSPResponse.h"
#import "SMIMECapabilities.h"
#import "CategoryExtend.h"

@interface CertEtcToken ()

@property (nonatomic, assign) int tagNO;
@property (nonatomic, readwrite, retain) ASN1Encodable *value;
@property (nonatomic, readwrite, retain) Extension *extension;

@end

@implementation CertEtcToken
@synthesize tagNO = _tagNo;
@synthesize value = _value;
@synthesize extension = _extension;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    if (_extension) {
        [_extension release];
        _extension = nil;
    }
    [super dealloc];
#endif
}

+ (int)TAG_CERTIFICATE {
    static int _TAG_CERTIFICATE = 0;
    @synchronized(self) {
        if (!_TAG_CERTIFICATE) {
            _TAG_CERTIFICATE = 0;
        }
    }
    return _TAG_CERTIFICATE;
}

+ (int)TAG_ESSCERTID {
    static int _TAG_ESSCERTID = 0;
    @synchronized(self) {
        if (!_TAG_ESSCERTID) {
            _TAG_ESSCERTID = 1;
        }
    }
    return _TAG_ESSCERTID;
}

+ (int)TAG_PKISTATUS {
    static int _TAG_PKISTATUS = 0;
    @synchronized(self) {
        if (!_TAG_PKISTATUS) {
            _TAG_PKISTATUS = 2;
        }
    }
    return _TAG_PKISTATUS;
}

+ (int)TAG_ASSERTION {
    static int _TAG_ASSERTION = 0;
    @synchronized(self) {
        if (!_TAG_ASSERTION) {
            _TAG_ASSERTION = 3;
        }
    }
    return _TAG_ASSERTION;
}

+ (int)TAG_CRL {
    static int _TAG_CRL = 0;
    @synchronized(self) {
        if (!_TAG_CRL) {
            _TAG_CRL = 4;
        }
    }
    return _TAG_CRL;
}

+ (int)TAG_OCSPCERTSTATUS {
    static int _TAG_OCSPCERTSTATUS = 0;
    @synchronized(self) {
        if (!_TAG_OCSPCERTSTATUS) {
            _TAG_OCSPCERTSTATUS = 5;
        }
    }
    return _TAG_OCSPCERTSTATUS;
}

+ (int)TAG_OCSPCERTID {
    static int _TAG_OCSPCERTID = 0;
    @synchronized(self) {
        if (!_TAG_OCSPCERTID) {
            _TAG_OCSPCERTID = 6;
        }
    }
    return _TAG_OCSPCERTID;
}

+ (int)TAG_OCSPRESPONSE {
    static int _TAG_OCSPRESPONSE = 0;
    @synchronized(self) {
        if (!_TAG_OCSPRESPONSE) {
            _TAG_OCSPRESPONSE = 7;
        }
    }
    return _TAG_OCSPRESPONSE;
}

+ (int)TAG_CAPABILITIES {
    static int _TAG_CAPABILITIES = 0;
    @synchronized(self) {
        if (!_TAG_CAPABILITIES) {
            _TAG_CAPABILITIES = 8;
        }
    }
    return _TAG_CAPABILITIES;
}

+ (NSMutableArray *)explicit {
    static NSMutableArray *_explicit = nil;
    @synchronized(self) {
        if (!_explicit) {
            _explicit = [[NSMutableArray alloc] initWithObjects:@false, @true, @false, @true, @false, @true, @false, @false, @true, nil];
        }
    }
    return _explicit;
}

+ (CertEtcToken *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertEtcToken class]]) {
        return (CertEtcToken *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[CertEtcToken alloc] initParamASN1TaggedObject:(ASN1TaggedObject *)paramObject] autorelease];
    }
    if (paramObject) {
        return [[[CertEtcToken alloc] initParamExtension:[Extension getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.tagNO = paramInt;
        self.value = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamExtension:(Extension *)paramExtension
{
    if (self = [super init]) {
        self.tagNO = -1;
        self.extension = paramExtension;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    if (self = [super init]) {
        self.tagNO = [paramASN1TaggedObject getTagNo];
        switch (self.tagNO) {
            case 0:
                self.value = [Certificate getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            case 1:
                self.value = [ESSCertID getInstance:[paramASN1TaggedObject getObject]];
                break;
            case 2:
                self.value = [PKIStatusInfo getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            case 3:
                self.value = [ContentInfo getInstance:[paramASN1TaggedObject getObject]];
                break;
            case 4:
                self.value = [CertificateList getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            case 5:
                self.value = [CertStatus getInstance:[paramASN1TaggedObject getObject]];
                break;
            case 6:
                self.value = [CertID getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            case 7:
                self.value = [OCSPResponse getInstance:paramASN1TaggedObject paramBoolean:NO];
                break;
            case 8:
                self.value = [SMIMECapabilities getInstance:[paramASN1TaggedObject getObject]];
                break;
            default:
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Unknown tag: %d", self.tagNO] userInfo:nil];
                break;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.extension) {
        return [[[DERTaggedObject alloc] initParamBoolean:(BOOL)[[CertEtcToken explicit] objectAtIndex:self.tagNO] paramInt:self.tagNO paramASN1Encodable:self.value] autorelease];
    }
    return [self.extension toASN1Primitive];
}

- (int)getTagNo {
    return self.tagNO;
}

- (ASN1Encodable *)getValue {
    return self.value;
}

- (Extension *)getExtension {
    return self.extension;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"CertEtcToken {\n%@}\n", self.value];
}

+ (NSMutableArray *)arrayFromSequence:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *arrayOfCertEtcToken = [[[NSMutableArray alloc] initWithSize:[paramASN1Sequence size]] autorelease];
    for (int i = 0; i != arrayOfCertEtcToken.count; i++) {
        arrayOfCertEtcToken[i] = [CertEtcToken getInstance:[paramASN1Sequence getObjectAt:i]];
    }
    return arrayOfCertEtcToken;
}

@end
