//
//  OCSPResponse.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OCSPResponse.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation OCSPResponse
@synthesize responseStatus = _responseStatus;
@synthesize responseBytes = _responseBytes;

+ (OCSPResponse *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OCSPResponse class]]) {
        return (OCSPResponse *)paramObject;
    }
    if (paramObject) {
        return [[[OCSPResponse alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (OCSPResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [OCSPResponse getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.responseStatus = [OCSPResponseStatus getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] == 2) {
            self.responseBytes = [ResponseBytes getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] paramBoolean:YES];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOCSPResponseStatus:(OCSPResponseStatus *)paramOCSPResponseStatus paramResponseBytes:(ResponseBytes *)paramResponseBytes
{
    if (self = [super init]) {
        self.responseStatus = paramOCSPResponseStatus;
        self.responseBytes = paramResponseBytes;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (OCSPResponseStatus *)getResponseStatus {
    return self.responseStatus;
}

- (ResponseBytes *)getResponseBytes {
    return self.responseBytes;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.responseStatus];
    if (self.responseBytes) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.responseBytes];
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
