//
//  AttCertValidityPeriod.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttCertValidityPeriod.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation AttCertValidityPeriod
@synthesize notBeforeTime = _notBeforeTime;
@synthesize notAfterTime = _notAfterTime;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_notBeforeTime) {
        [_notBeforeTime release];
        _notBeforeTime = nil;
    }
    if (_notAfterTime) {
        [_notAfterTime release];
        _notAfterTime = nil;
    }
    [super dealloc];
#endif
}

+ (AttCertValidityPeriod *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AttCertValidityPeriod class]]) {
        return (AttCertValidityPeriod *)paramObject;
    }
    if (paramObject) {
        return [[[AttCertValidityPeriod alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.notBeforeTime = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:0]];
        self.notAfterTime = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1GeneralizedTime1:(ASN1GeneralizedTime *)paramASN1GeneralizedTime1 paramASN1GeneralizedTime2:(ASN1GeneralizedTime *)paramASN1GeneralizedTime2
{
    if (self = [super init]) {
        self.notBeforeTime = paramASN1GeneralizedTime1;
        self.notAfterTime = paramASN1GeneralizedTime2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1GeneralizedTime *)getNotBeforeTime {
    return self.notBeforeTime;
}

- (ASN1GeneralizedTime *)getNotAfterTime {
    return self.notAfterTime;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.notBeforeTime];
    [localASN1EncodableVector add:self.notAfterTime];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
