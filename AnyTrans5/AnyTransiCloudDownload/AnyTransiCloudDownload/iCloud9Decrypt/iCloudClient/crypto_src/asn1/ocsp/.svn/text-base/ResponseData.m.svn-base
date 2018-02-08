//
//  ResponseData.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ResponseData.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface ResponseData ()

@property (nonatomic, assign) BOOL versionPresent;
@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ResponderID *responderID;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *producedAt;
@property (nonatomic, readwrite, retain) ASN1Sequence *responses;
@property (nonatomic, readwrite, retain) Extensions *responseExtensions;

@end

@implementation ResponseData
@synthesize versionPresent = _versionPresent;
@synthesize version = _version;
@synthesize responderID = _responderID;
@synthesize producedAt = _producedAt;
@synthesize responses = _responses;
@synthesize responseExtensions = _responseExtensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_responderID) {
        [_responderID release];
        _responderID = nil;
    }
    if (_producedAt) {
        [_producedAt release];
        _producedAt = nil;
    }
    if (_responses) {
        [_responses release];
        _responses = nil;
    }
    if (_responseExtensions) {
        [_responseExtensions release];
        _responseExtensions = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1Integer *)V1 {
    static ASN1Integer *_V1 = 0;
    @synchronized(self) {
        if (!_V1) {
            _V1 = 0;
        }
    }
    return _V1;
}

+ (ResponseData *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ResponseData class]]) {
        return (ResponseData *)paramObject;
    }
    if (paramObject) {
        return [[[ResponseData alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ResponseData *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ResponseData getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.versionPresent = TRUE;
                self.version = [ASN1Integer getInstance:((ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0]) paramBoolean:TRUE];
                i++;
            }else {
                self.version = [ResponseData V1];
            }
        }else {
            self.version = [ResponseData V1];
        }
        self.responderID = [ResponderID getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.producedAt = [ASN1GeneralizedTime getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.responses = ((ASN1Sequence *)[paramASN1Sequence getObjectAt:i++]);
        if ([paramASN1Sequence size] > i) {
            self.responseExtensions = [Extensions getInstance:((ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i]) paramBoolean:TRUE];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        self.version = paramASN1Integer;
        self.responderID = paramResponderID;
        self.producedAt = paramASN1GeneralizedTime;
        self.responses = paramASN1Sequence;
        self.responseExtensions = paramExtensions;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramX509Extensions:(X509Extensions *)paramX509Extensions
{
    if (self = [super init]) {
        [self initParamASN1Integer:[ResponseData V1] paramResponderID:paramResponderID paramASN1GeneralizedTime:[ASN1GeneralizedTime getInstance:paramASN1GeneralizedTime] paramASN1Sequence:paramASN1Sequence paramExtensions:[Extensions getInstance:paramX509Extensions]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamResponderID:(ResponderID *)paramResponderID paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        [self initParamASN1Integer:[ResponseData V1] paramResponderID:paramResponderID paramASN1GeneralizedTime:paramASN1GeneralizedTime paramASN1Sequence:paramASN1Sequence paramExtensions:paramExtensions];
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

- (ResponderID *)getResponderID {
    return self.responderID;
}

- (ASN1GeneralizedTime *)getProducedAt {
    return self.producedAt;
}

- (ASN1Sequence *)getResponses {
    return self.responses;
}

- (Extensions *)getResponseExtensions {
    return self.responseExtensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.versionPresent || [self.version isEqual:[ResponseData V1]]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.version];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.responderID];
    [localASN1EncodableVector add:self.producedAt];
    [localASN1EncodableVector add:self.responses];
    if (self.responseExtensions) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.responseExtensions];
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
