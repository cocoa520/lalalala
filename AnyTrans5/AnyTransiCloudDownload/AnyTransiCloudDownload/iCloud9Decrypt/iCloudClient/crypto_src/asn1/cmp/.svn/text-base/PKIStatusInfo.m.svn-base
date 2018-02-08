//
//  PKIStatusInfo.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIStatusInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "PKIFreeText.h"

@implementation PKIStatusInfo
@synthesize status = _status;
@synthesize statusString = _statusString;
@synthesize failInfo = _failInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_status) {
        [_status release];
        _status = nil;
    }
    if (_statusString) {
        [_statusString release];
        _statusString = nil;
    }
    if (_failInfo) {
        [_failInfo release];
        _failInfo = nil;
    }
    [super dealloc];
#endif
}

+ (PKIStatusInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIStatusInfo class]]) {
        return (PKIStatusInfo *)paramObject;
    }
    if (paramObject) {
        return [[[PKIStatusInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (PKIStatusInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [PKIStatusInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.status = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
        self.statusString = nil;
        self.failInfo = nil;
        if ([paramASN1Sequence size] > 2) {
            self.statusString = [PKIFreeText getInstance:[paramASN1Sequence getObjectAt:1]];
            self.failInfo = [DERBitString getInstance:[paramASN1Sequence getObjectAt:2]];
        }else if ([paramASN1Sequence size] > 1) {
            ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:1];
            if ([localASN1Encodable isKindOfClass:[DERBitString class]]) {
                self.failInfo = [DERBitString getInstance:localASN1Encodable];
            }else {
                self.statusString = [PKIFreeText getInstance:localASN1Encodable];
            }
        }
    }
    return self;
}

- (instancetype)initParamPKIStatus:(PKIStatus *)paramPKIStatus
{
    self = [super init];
    if (self) {
        self.status = [ASN1Integer getInstance:[paramPKIStatus toASN1Primitive]];
    }
    return self;
}

- (instancetype)initParamPKIStatus:(PKIStatus *)paramPKIStatus paramPKIFreeText:(PKIFreeText *)paramPKIFreeText
{
    self = [super init];
    if (self) {
        self.status = [ASN1Integer getInstance:[paramPKIStatus toASN1Primitive]];
        self.statusString = paramPKIFreeText;
    }
    return self;
}

- (instancetype)initParamPKIStatus:(PKIStatus *)paramPKIStatus paramPKIFreeText:(PKIFreeText *)paramPKIFreeText paramPKIFailureInfo:(PKIFailureInfo *)paramPKIFailureInfo
{
    self = [super init];
    if (self) {
        self.status = [ASN1Integer getInstance:[paramPKIStatus toASN1Primitive]];
        self.statusString = paramPKIFreeText;
        self.failInfo = paramPKIFailureInfo;
    }
    return self;
}

- (BigInteger *)getStatus {
    return [self.status getValue];
}

- (PKIFreeText *)getStatusString {
    return self.statusString;
}

- (DERBitString *)getFailInfo {
    return self.failInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.status];
    if (self.statusString) {
        [localASN1EncodableVector add:self.statusString];
    }
    if (self.failInfo) {
        [localASN1EncodableVector add:self.failInfo];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
