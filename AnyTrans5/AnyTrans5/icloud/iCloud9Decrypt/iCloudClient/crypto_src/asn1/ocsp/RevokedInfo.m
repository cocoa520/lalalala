//
//  RevokedInfo.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevokedInfo.h"
#import "ASN1Sequence.h"
#import "ASN1Enumerated.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface RevokedInfo ()

@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *revocationTime;
@property (nonatomic, readwrite, retain) CRLReason *revocationReason;

@end

@implementation RevokedInfo
@synthesize revocationTime = _revocationTime;
@synthesize revocationReason = _revocationReason;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_revocationTime) {
        [_revocationTime release];
        _revocationTime = nil;
    }
    if (_revocationReason) {
        [_revocationReason release];
        _revocationReason = nil;
    }
    [super dealloc];
#endif
}

+ (RevokedInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RevokedInfo class]]) {
        return (RevokedInfo *)paramObject;
    }
    if (paramObject) {
        return [[[RevokedInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (RevokedInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [RevokedInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.revocationTime = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.revocationReason = [CRLReason getInstance:[ASN1Enumerated getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] paramBoolean:TRUE]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramCRLReason:(CRLReason *)paramCRLReason
{
    if (self = [super init]) {
        self.revocationTime = paramASN1GeneralizedTime;
        self.revocationReason = paramCRLReason;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (ASN1GeneralizedTime *)getRevocationTime {
    return self.revocationTime;
}

- (CRLReason *)getRevocationReason {
    return self.revocationReason;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.revocationTime];
    if (self.revocationReason) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:self.revocationReason];
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

@end
