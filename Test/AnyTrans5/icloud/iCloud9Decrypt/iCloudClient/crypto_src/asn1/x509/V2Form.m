//
//  V2Form.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "V2Form.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation V2Form
@synthesize issuerName = _issuerName;
@synthesize baseCertificateID = _baseCertificateID;
@synthesize objectDigestInfo = _objectDigestInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_issuerName) {
        [_issuerName release];
        _issuerName = nil;
    }
    if (_baseCertificateID) {
        [_baseCertificateID release];
        _baseCertificateID = nil;
    }
    if (_objectDigestInfo) {
        [_objectDigestInfo release];
        _objectDigestInfo = nil;
    }
    [super dealloc];
#endif
}

+ (V2Form *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[V2Form class]]) {
        return (V2Form *)paramObject;
    }
    if (paramObject) {
        return [[[V2Form alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (V2Form *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [V2Form getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        int i = 0;
        if (![[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1TaggedObject class]]) {
            i++;
            self.issuerName = [GeneralNames getInstance:[paramASN1Sequence getObjectAt:0]];
        }
        for (int j = i; j != [paramASN1Sequence size]; j++) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:j]];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.baseCertificateID = [IssuerSerial getInstance:localASN1TaggedObject paramBoolean:NO];
            }else if ([localASN1TaggedObject getTagNo] == 1) {
                self.objectDigestInfo = [ObjectDigestInfo getInstance:localASN1TaggedObject paramBoolean:NO];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
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

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames
{
    if (self = [super init]) {
        [self initParamGeneralNames:paramGeneralNames paramIssuerSerial:nil paramObjectDigestInfo:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramIssuerSerial:(IssuerSerial *)paramIssuerSerial
{
    if (self = [super init]) {
        [self initParamGeneralNames:paramGeneralNames paramIssuerSerial:paramIssuerSerial paramObjectDigestInfo:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramObjectDigestInfo:(ObjectDigestInfo *)paramObjectDigestInfo
{
    if (self = [super init]) {
        [self initParamGeneralNames:paramGeneralNames paramIssuerSerial:nil paramObjectDigestInfo:paramObjectDigestInfo];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramIssuerSerial:(IssuerSerial *)paramIssuerSerial paramObjectDigestInfo:(ObjectDigestInfo *)paramObjectDigestInfo
{
    if (self = [super init]) {
        self.issuerName = paramGeneralNames;
        self.baseCertificateID = paramIssuerSerial;
        self.objectDigestInfo = paramObjectDigestInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (GeneralNames *)getIssuerName {
    return self.issuerName;
}

- (IssuerSerial *)getBaseCertificateID {
    return self.baseCertificateID;
}

- (ObjectDigestInfo *)getObjectDigestInfo {
    return self.objectDigestInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.issuerName) {
        [localASN1EncodableVector add:self.issuerName];
    }
    if (self.baseCertificateID) {
        ASN1Encodable *baseEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.baseCertificateID];
        [localASN1EncodableVector add:baseEncodable];
#if !__has_feature(objc_arc)
        if (baseEncodable) [baseEncodable release]; baseEncodable = nil;
#endif
    }
    if (self.objectDigestInfo) {
        ASN1Encodable *objectEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.objectDigestInfo];
        [localASN1EncodableVector add:objectEncodable];
#if !__has_feature(objc_arc)
        if (objectEncodable) [objectEncodable release]; objectEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
