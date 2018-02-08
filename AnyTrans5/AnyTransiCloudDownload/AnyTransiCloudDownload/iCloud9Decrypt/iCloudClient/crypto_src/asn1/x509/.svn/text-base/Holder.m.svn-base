//
//  Holder.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Holder.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface Holder ()

@property (nonatomic, assign) int version;

@end

@implementation Holder
@synthesize version = _version;
@synthesize baseCertificateID = _baseCertificateID;
@synthesize entityName = _entityName;
@synthesize objectDigestInfo = _objectDigestInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_baseCertificateID) {
        [_baseCertificateID release];
        _baseCertificateID = nil;
    }
    if (_entityName) {
        [_entityName release];
        _entityName = nil;
    }
    if (_objectDigestInfo) {
        [_objectDigestInfo release];
        _objectDigestInfo = nil;
    }
    [super dealloc];
#endif
}

+ (int)V1_CERTIFICATE_HOLDER {
    static int _V1_CERTIFICATE_HOLDER = 0;
    @synchronized(self) {
        if (_V1_CERTIFICATE_HOLDER) {
            _V1_CERTIFICATE_HOLDER = 0;
        }
    }
    return _V1_CERTIFICATE_HOLDER;
}

+ (int)V2_CERTIFICATE_HOLDER {
    static int _V2_CERTIFICATE_HOLDER = 0;
    @synchronized(self) {
        if (_V2_CERTIFICATE_HOLDER) {
            _V2_CERTIFICATE_HOLDER = 1;
        }
    }
    return _V2_CERTIFICATE_HOLDER;
}

+ (Holder *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Holder class]]) {
        return (Holder *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [[[Holder alloc] initParamASN1TaggedObject:[ASN1TaggedObject getInstance:paramObject]] autorelease];
    }
    if (paramObject) {
        return [[[Holder alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    if (self = [super init]) {
        switch ([paramASN1TaggedObject getTagNo]) {
            case 0:
                self.baseCertificateID = [IssuerSerial getInstance:paramASN1TaggedObject paramBoolean:YES];
                break;
            case 1:
                self.entityName = [GeneralNames getInstance:paramASN1TaggedObject paramBoolean:YES];
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag in Holder" userInfo:nil];
                break;
        }
        self.version = 0;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:i]];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.baseCertificateID = [IssuerSerial getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 1:
                    self.entityName = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 2:
                    self.objectDigestInfo = [ObjectDigestInfo getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag in Holder" userInfo:nil];
                    break;
            }
        }
        self.version = 1;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamIssuerSerial:(IssuerSerial *)paramIssuerSerial
{
    if (self = [super init]) {
        [self initParamIssuerSerial:paramIssuerSerial paramInt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamIssuerSerial:(IssuerSerial *)paramIssuerSerial paramInt:(int)paramInt
{
    if (self = [super init]) {
        self.baseCertificateID = paramIssuerSerial;
        self.version = paramInt;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames
{
    if (self = [super init]) {
        [self initParamGeneralNames:paramGeneralNames paramInt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramInt:(int)paramInt
{
    if (self = [super init]) {
        self.entityName = paramGeneralNames;
        self.version = paramInt;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamObjectDigestInfo:(ObjectDigestInfo *)paramObjectDigestInfo
{
    if (self = [super init]) {
        self.objectDigestInfo = paramObjectDigestInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)setVersion:(int)version {
    if (_version != version) {
        _version = 1;
    }
}

- (int)getVersion {
    return self.version;
}

- (IssuerSerial *)getBaseCertificateID {
    return self.baseCertificateID;
}

- (GeneralNames *)getEntityName {
    return self.entityName;
}

- (ObjectDigestInfo *)getObjectDigestInfo {
    return self.objectDigestInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.version == 1) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        if (self.baseCertificateID) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.baseCertificateID];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (self.entityName) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.entityName];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (self.objectDigestInfo) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:2 paramASN1Encodable:self.objectDigestInfo];
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
    if (self.entityName) {
        return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.entityName] autorelease];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.baseCertificateID] autorelease];
}

@end
