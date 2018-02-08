//
//  TimeStampReq.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TimeStampReq.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation TimeStampReq
@synthesize version = _version;
@synthesize messageImprint = _messageImprint;
@synthesize tsaPolicy = _tsaPolicy;
@synthesize nonce = _nonce;
@synthesize certReq = _certReq;
@synthesize extensions = _extensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_messageImprint) {
        [_messageImprint release];
        _messageImprint = nil;
    }
    if (_tsaPolicy) {
        [_tsaPolicy release];
        _tsaPolicy = nil;
    }
    if (_nonce) {
        [_nonce release];
        _nonce = nil;
    }
    if (_certReq) {
        [_certReq release];
        _certReq = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    [super dealloc];
#endif
}

+ (TimeStampReq *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TimeStampReq class]]) {
        return (TimeStampReq *)paramObject;
    }
    if (paramObject) {
        return [[[TimeStampReq alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = (int)[paramASN1Sequence size];
        int j = 0;
        self.version = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:j]];
        j++;
        self.messageImprint = [MessageImprint getInstance:[paramASN1Sequence getObjectAt:j]];
        j++;
        for (int k = j; k < i; k++) {
            if ([[paramASN1Sequence getObjectAt:k] isKindOfClass:[ASN1ObjectIdentifier class]]) {
                self.tsaPolicy = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:k]];
            }else if ([[paramASN1Sequence getObjectAt:k] isKindOfClass:[ASN1Integer class]]) {
                self.nonce = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:k]];
            }else if ([[paramASN1Sequence getObjectAt:k] isKindOfClass:[ASN1Boolean class]]) {
                self.certReq = [ASN1Boolean getInstanceObject:[paramASN1Sequence getObjectAt:k]];
            }else if ([[paramASN1Sequence getObjectAt:k] isKindOfClass:[ASN1TaggedObject class]]) {
                ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:k];
                if ([localASN1TaggedObject getTagNo] == 0) {
                    self.extensions = [Extensions getInstance:localASN1TaggedObject paramBoolean:NO];
                }
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

- (instancetype)initParamMessageImprint:(MessageImprint *)paramMessageImprint paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        ASN1Integer *integer =  [[ASN1Integer alloc] initLong:1];
        self.version = integer;
        self.messageImprint = paramMessageImprint;
        self.tsaPolicy = paramASN1ObjectIdentifier;
        self.nonce = paramASN1Integer;
        self.certReq = paramASN1Boolean;
        self.extensions = paramExtensions;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (MessageImprint *)getMessageImprint {
    return self.messageImprint;
}

- (ASN1ObjectIdentifier *)getReqPolicy {
    return self.tsaPolicy;
}

- (ASN1Integer *)getNonce {
    return self.nonce;
}

- (ASN1Boolean *)getCertReq {
    return self.certReq;
}

- (Extensions *)getExtensions {
    return self.extensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.version];
    [localASN1EncodableVector add:self.messageImprint];
    if (self.tsaPolicy) {
        [localASN1EncodableVector add:self.tsaPolicy];
    }
    if (self.nonce) {
        [localASN1EncodableVector add:self.nonce];
    }
    if (self.certReq && [self.certReq isTrue]) {
        [localASN1EncodableVector add:self.certReq];
    }
    if (self.extensions) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.extensions];
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
