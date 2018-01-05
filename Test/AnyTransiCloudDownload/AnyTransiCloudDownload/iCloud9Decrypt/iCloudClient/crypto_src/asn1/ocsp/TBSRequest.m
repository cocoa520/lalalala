//
//  TBSRequest.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TBSRequest.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation TBSRequest
@synthesize version = _version;
@synthesize requestorName = _requestorName;
@synthesize requestList = _requestList;
@synthesize requestExtensions = _requestExtensions;
@synthesize versionSet = _versionSet;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_requestorName) {
        [_requestorName release];
        _requestorName = nil;
    }
    if (_requestList) {
        [_requestList release];
        _requestList = nil;
    }
    if (_requestExtensions) {
        [_requestExtensions release];
        _requestExtensions = nil;
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

+ (TBSRequest *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TBSRequest class]]) {
        return (TBSRequest *)paramObject;
    }
    if (paramObject) {
        return [[[TBSRequest alloc] initparamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (TBSRequest *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [TBSRequest getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramX509Extensions:(X509Extensions *)paramX509Extensions
{
    if (self = [super init]) {
        self.version = [TBSRequest V1];
        self.requestorName = paramGeneralName;
        self.requestList = paramASN1Sequence;
        self.requestExtensions = [Extensions getInstance:paramX509Extensions];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        self.version = [TBSRequest V1];
        self.requestorName = paramGeneralName;
        self.requestList = paramASN1Sequence;
        self.requestExtensions = paramExtensions;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initparamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1TaggedObject class]]) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.versionSet = TRUE;
                self.version = [ASN1Integer getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0] paramBoolean:TRUE];
                i++;
            }else {
                self.version = [TBSRequest V1];
            }
        }else {
            self.version = [TBSRequest V1];
        }
        if ([[paramASN1Sequence getObjectAt:i] isKindOfClass:[ASN1TaggedObject class]]) {
            self.requestorName = [GeneralName getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i++] paramBoolean:TRUE];
        }
        self.requestList = (ASN1Sequence *)[paramASN1Sequence getObjectAt:i++];
        if ([paramASN1Sequence size] == (i + 1)) {
            self.requestExtensions = [Extensions getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i] paramBoolean:TRUE];
        }
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

- (GeneralName *)getRequestorName {
    return self.requestorName;
}

- (ASN1Sequence *)getRequestList {
    return self.requestList;
}

- (Extensions *)getRequestExtensions {
    return self.requestExtensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (![self.version isEqual:[TBSRequest V1]] || self.versionSet) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.version];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.requestorName) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.requestorName];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.requestList];
    if (self.requestExtensions) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.requestExtensions];
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
