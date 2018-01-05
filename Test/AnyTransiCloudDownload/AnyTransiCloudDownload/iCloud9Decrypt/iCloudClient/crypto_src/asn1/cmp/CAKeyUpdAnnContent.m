//
//  CAKeyUpdAnnContent.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CAKeyUpdAnnContent.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CAKeyUpdAnnContent ()

@property (nonatomic, readwrite, retain) CMPCertificate *oldWithNew;
@property (nonatomic, readwrite, retain) CMPCertificate *nWO;
@property (nonatomic, readwrite, retain) CMPCertificate *nWN;

@end

@implementation CAKeyUpdAnnContent
@synthesize oldWithNew = _oldWithNew;
@synthesize nWO = _nWO;
@synthesize nWN = _nWN;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_oldWithNew) {
        [_oldWithNew release];
        _oldWithNew = nil;
    }
    if (_nWO) {
        [_nWO release];
        _nWO = nil;
    }
    if (_nWN) {
        [_nWN release];
        _nWN = nil;
    }
    [super dealloc];
#endif
}

+ (CAKeyUpdAnnContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CAKeyUpdAnnContent class]]) {
        return (CAKeyUpdAnnContent *)paramObject;
    }
    if (paramObject) {
        return [[[CAKeyUpdAnnContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.oldWithNew = [CMPCertificate getInstance:[paramASN1Sequence getObjectAt:0]];
        self.nWO = [CMPCertificate getInstance:[paramASN1Sequence getObjectAt:1]];
        self.nWN = [CMPCertificate getInstance:[paramASN1Sequence getObjectAt:2]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCMPCertificate1:(CMPCertificate *)paramCMPCertificate1 paramCMPCertificate2:(CMPCertificate *)paramCMPCertificate2 paramCMPCertificate3:(CMPCertificate *)paramCMPCertificate3
{
    if (self = [super init]) {
        self.oldWithNew = paramCMPCertificate1;
        self.nWO = paramCMPCertificate2;
        self.nWN = paramCMPCertificate3;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (CMPCertificate *)getOldWithNew {
    return self.oldWithNew;
}

- (CMPCertificate *)getNewWithOld {
    return self.nWO;
}

- (CMPCertificate *)getNewWithNew {
    return self.nWN;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.oldWithNew];
    [localASN1EncodableVector add:self.nWO];
    [localASN1EncodableVector add:self.nWN];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
