//
//  OCSPRequest.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OCSPRequest.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation OCSPRequest
@synthesize tbsRequest = _tbsRequest;
@synthesize optionalSignature = _optionalSignature;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_tbsRequest) {
        [_tbsRequest release];
        _tbsRequest = nil;
    }
    if (_optionalSignature) {
        [_optionalSignature release];
        _optionalSignature = nil;
    }
    [super dealloc];
#endif
}

+ (OCSPRequest *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OCSPRequest class]]) {
        return (OCSPRequest *)paramObject;
    }
    if (paramObject) {
        return [[[OCSPRequest alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (OCSPRequest *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [OCSPRequest getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamTBSRequest:(TBSRequest *)paramTBSRequest paramSignature:(Signature *)paramSignature
{
    if (self = [super init]) {
        self.tbsRequest = paramTBSRequest;
        self.optionalSignature = paramSignature;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.tbsRequest = [TBSRequest getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] == 2) {
            self.optionalSignature = [Signature getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] paramBoolean:TRUE];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (TBSRequest *)getTbsRequest {
    return self.tbsRequest;
}

- (Signature *)getOptionalSignature {
    return self.optionalSignature;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.tbsRequest];
    if (self.optionalSignature) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:self.optionalSignature];
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
