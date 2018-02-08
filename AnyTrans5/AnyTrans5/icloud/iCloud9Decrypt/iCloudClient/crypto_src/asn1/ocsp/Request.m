//
//  Request.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Request.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation Request
@synthesize reqCert = _reqCert;
@synthesize singleRequestExtensions = _singleRequestExtensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_reqCert) {
        [_reqCert release];
        _reqCert = nil;
    }
    if (_singleRequestExtensions) {
        [_singleRequestExtensions release];
        _singleRequestExtensions = nil;
    }
    [super dealloc];
#endif
}

+ (Request *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Request class]]) {
        return (Request *)paramObject;
    }
    if (paramObject) {
        return [[[Request alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (Request *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [Request getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.reqCert = [CertID getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] == 2) {
            self.singleRequestExtensions = [Extensions getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] paramBoolean:TRUE];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertID:(CertID *)paramCertID paramExtensions:(Extensions *)paramExtensions
{
    if (self = [super init]) {
        self.reqCert = paramCertID;
        self.singleRequestExtensions = paramExtensions;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (CertID *)getReqCert {
    return self.reqCert;
}

- (Extensions *)getSingleRequestExtensions {
    return self.singleRequestExtensions;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.reqCert];
    if (self.singleRequestExtensions) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.singleRequestExtensions];
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
