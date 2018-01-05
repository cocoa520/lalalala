//
//  TimeStampResp.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TimeStampResp.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation TimeStampResp
@synthesize pkiStatusInfo = _pkiStatusInfo;
@synthesize timeStampToken = _timeStampToken;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pkiStatusInfo) {
        [_pkiStatusInfo release];
        _pkiStatusInfo = nil;
    }
    if (_timeStampToken) {
        [_timeStampToken release];
        _timeStampToken = nil;
    }
    [super dealloc];
#endif
}

+ (TimeStampResp *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TimeStampResp class]]) {
        return (TimeStampResp *)paramObject;
    }
    if (paramObject) {
        return [[[TimeStampResp alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.pkiStatusInfo = [PKIStatusInfo getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        if (localObject = [localEnumeration nextObject]) {
            self.timeStampToken = [ContentInfo getInstance:localObject];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamPKIStatusInfo:(PKIStatusInfo *)paramPKIStatusInfo paramContentInfo:(ContentInfo *)paramContentInfo
{
    if (self = [super init]) {
        self.pkiStatusInfo = paramPKIStatusInfo;
        self.timeStampToken = paramContentInfo;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (PKIStatusInfo *)getStatus {
    return self.pkiStatusInfo;
}

- (ContentInfo *)getTimeStampToken {
    return self.timeStampToken;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.pkiStatusInfo];
    if (self.timeStampToken) {
        [localASN1EncodableVector add:self.timeStampToken];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
