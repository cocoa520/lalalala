//
//  CertStatusCMP.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertStatusCMP.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@interface CertStatusCMP ()

@property (nonatomic, readwrite, retain) ASN1OctetString *certHash;
@property (nonatomic, readwrite, retain) ASN1Integer *certReqId;
@property (nonatomic, readwrite, retain) PKIStatusInfo *statusInfo;

@end

@implementation CertStatusCMP
@synthesize certHash = _certHash;
@synthesize certReqId = _certReqId;
@synthesize statusInfo = _statusInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certHash) {
        [_certHash release];
        _certHash = nil;
    }
    if (_certReqId) {
        [_certReqId release];
        _certReqId = nil;
    }
    if (_statusInfo) {
        [_statusInfo release];
        _statusInfo = nil;
    }
    [super dealloc];
#endif
}

+ (CertStatusCMP *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertStatusCMP class]]) {
        return (CertStatusCMP *)paramObject;
    }
    if (paramObject) {
        return [[[CertStatusCMP alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.certHash = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:0]];
        self.certReqId = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] > 2) {
            self.statusInfo = [PKIStatusInfo getInstance:[paramASN1Sequence getObjectAt:2]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        ASN1OctetString *hash = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *reqId = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.certHash = hash;
        self.certReqId = reqId;
#if !__has_feature(objc_arc)
        if (hash) [hash release]; hash = nil;
        if (reqId) [reqId release]; reqId = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramBigInteger:(BigInteger *)paramBigInteger paramPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo
{
    if (self = [super init]) {
        ASN1OctetString *hash = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *reqId = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.certHash = hash;
        self.certReqId = reqId;
        self.statusInfo = paramPKIStatusInfo;
#if !__has_feature(objc_arc)
        if (hash) [hash release]; hash = nil;
        if (reqId) [reqId release]; reqId = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1OctetString *)getCertHash {
    return self.certHash;
}

- (ASN1Integer *)getCertReqId {
    return self.certReqId;
}

- (PKIStatusInfo *)getStatusInfo {
    return self.statusInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certHash];
    [localASN1EncodableVector add:self.certReqId];
    if (self.statusInfo) {
        [localASN1EncodableVector add:self.statusInfo];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
