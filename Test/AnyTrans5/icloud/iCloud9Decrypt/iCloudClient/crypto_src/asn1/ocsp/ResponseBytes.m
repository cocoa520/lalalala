//
//  ResponseBytes.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ResponseBytes.h"
#import "DERSequence.h"

@implementation ResponseBytes
@synthesize responseType = _responseType;
@synthesize response = _response;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_responseType) {
        [_responseType release];
        _responseType = nil;
    }
    if (_response) {
        [_response release];
        _response = nil;
    }
    [super dealloc];
#endif
}

+ (ResponseBytes *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ResponseBytes class]]) {
        return (ResponseBytes *)paramObject;
    }
    if (paramObject) {
        return [[[ResponseBytes alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ResponseBytes *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ResponseBytes getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.responseType = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.response = (ASN1OctetString *)[paramASN1Sequence getObjectAt:1];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.responseType = paramASN1ObjectIdentifier;
        self.response = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getResponseType {
    return self.responseType;
}

- (ASN1OctetString *)getResponse {
    return self.response;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.responseType];
    [localASN1EncodableVector add:self.response];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
