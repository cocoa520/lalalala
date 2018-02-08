//
//  CertResponse.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertResponse.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CertResponse ()

@property (nonatomic, readwrite, retain) ASN1Integer *certReqId;
@property (nonatomic, readwrite, retain) PKIStatusInfo *status;
@property (nonatomic, readwrite, retain) CertifiedKeyPair *certifiedKeyPair;
@property (nonatomic, readwrite, retain) ASN1OctetString *rspInfo;

@end

@implementation CertResponse
@synthesize certReqId = _certReqId;
@synthesize status = _status;
@synthesize certifiedKeyPair = _certifiedKeyPair;
@synthesize rspInfo = _rspInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certReqId) {
        [_certReqId release];
        _certReqId = nil;
    }
    if (_status) {
        [_status release];
        _status = nil;
    }
    if (_certifiedKeyPair) {
        [_certifiedKeyPair release];
        _certifiedKeyPair = nil;
    }
    if (_rspInfo) {
        [_rspInfo release];
        _rspInfo = nil;
    }
    [super dealloc];
#endif
}

+ (CertResponse *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertResponse class]]) {
        return (CertResponse *)paramObject;
    }
    if (paramObject) {
        return [[[CertResponse alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.certReqId = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
        self.status = [PKIStatusInfo getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] >= 3) {
            if ([paramASN1Sequence size] == 3) {
                ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:2];
                if ([localASN1Encodable isKindOfClass:[ASN1OctetString class]]) {
                    self.rspInfo = [ASN1OctetString getInstance:localASN1Encodable];
                }else {
                    self.certifiedKeyPair = [CertifiedKeyPair getInstance:localASN1Encodable];
                }
            }else {
                self.certifiedKeyPair = [CertifiedKeyPair getInstance:[paramASN1Sequence getObjectAt:2]];
                self.rspInfo = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:3]];
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

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo
{
    if (self = [super init]) {
        [self initParamASN1Integer:paramASN1Integer paramPKIStatusInfo:paramPKIStatusInfo paramCertifiedKeyPair:nil paramASN1OctetString:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramCertifiedKeyPair:(CertifiedKeyPair *)paramCertifiedKeyPair paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        if (!paramASN1Integer) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'certReqId' cannot be null" userInfo:nil];
        }
        if (!paramPKIStatusInfo) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'status' cannot be null" userInfo:nil];
        }
        self.certReqId = paramASN1Integer;
        self.status = paramPKIStatusInfo;
        self.certifiedKeyPair = paramCertifiedKeyPair;
        self.rspInfo = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getCertReqId {
    return self.certReqId;
}

- (PKIStatusInfo *)getStatus {
    return self.status;
}

- (CertifiedKeyPair *)getCertifiedKeyPair {
    return self.certifiedKeyPair;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certReqId];
    [localASN1EncodableVector add:self.status];
    if (self.certifiedKeyPair) {
        [localASN1EncodableVector add:self.certifiedKeyPair];
    }
    if (self.rspInfo) {
        [localASN1EncodableVector add:self.rspInfo];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
