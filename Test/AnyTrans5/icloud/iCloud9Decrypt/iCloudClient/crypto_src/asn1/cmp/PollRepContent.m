//
//  PollRepContent.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PollRepContent.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface PollRepContent ()

@property (nonatomic, readwrite, retain) NSMutableArray *certReqId;
@property (nonatomic, readwrite, retain) NSMutableArray *checkAfter;
@property (nonatomic, readwrite, retain) NSMutableArray *reason;

@end

@implementation PollRepContent
@synthesize certReqId = _certReqId;
@synthesize checkAfter = _checkAfter;
@synthesize reason = _reason;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certReqId) {
        [_certReqId release];
        _certReqId = nil;
    }
    if (_checkAfter) {
        [_checkAfter release];
        _checkAfter = nil;
    }
    if (_reason) {
        [_reason release];
        _reason = nil;
    }
    [super dealloc];
#endif
}

+ (PollRepContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PollRepContent class]]) {
        return (PollRepContent *)paramObject;
    }
    if (paramObject) {
        return [[[PollRepContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSMutableArray *reqId = [[NSMutableArray alloc] initWithSize:[paramASN1Sequence size]];
        NSMutableArray *after = [[NSMutableArray alloc] initWithSize:[paramASN1Sequence size]];
        NSMutableArray *reason = [[NSMutableArray alloc] initWithSize:[paramASN1Sequence size]];
        self.certReqId = reqId;
        self.checkAfter = after;
        self.reason = reason;
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:i]];
            self.certReqId[i] = [ASN1Integer getInstance:[localASN1Sequence getObjectAt:0]];
            self.checkAfter[i] = [ASN1Integer getInstance:[localASN1Sequence getObjectAt:1]];
            if ([localASN1Sequence size] > 2) {
                self.reason[i] = [PKIFreeText getInstance:[localASN1Sequence getObjectAt:2]];
            }
        }
#if !__has_feature(objc_arc)
        if (reqId) [reqId release]; reqId = nil;
        if (after) [after release]; after = nil;
        if (reason) [reason release]; reason = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2
{
    if (self = [super init]) {
        [self initParamASN1Integer1:paramASN1Integer1 paramASN1Integer2:paramASN1Integer2 paramPKIFreeText:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Integer1:(ASN1Integer *)paramASN1Integer1 paramASN1Integer2:(ASN1Integer *)paramASN1Integer2 paramPKIFreeText:(PKIFreeText *)paramPKIFreeText
{
    if (self = [super init]) {
        NSMutableArray *reqId = [[NSMutableArray alloc] initWithSize:1];
        NSMutableArray *after = [[NSMutableArray alloc] initWithSize:1];
        NSMutableArray *reason = [[NSMutableArray alloc] initWithSize:1];
        self.certReqId = reqId;
        self.checkAfter = after;
        self.reason = reason;
        self.certReqId[0] = paramASN1Integer1;
        self.checkAfter[0] = paramASN1Integer2;
        self.reason[0] = paramPKIFreeText;
#if !__has_feature(objc_arc)
        if (reqId) [reqId release]; reqId = nil;
        if (after) [after release]; after = nil;
        if (reason) [reason release]; reason = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)size {
    return (int)[self.certReqId count];
}

- (ASN1Integer *)getCertReqId:(int)paramInt {
    return self.certReqId[paramInt];
}

- (ASN1Integer *)getCheckAfter:(int)paramInt {
    return self.checkAfter[paramInt];
}

- (PKIFreeText *)getReason:(int)paramInt {
    return self.reason[paramInt];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i != self.certReqId.count; i++) {
        ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
        [localASN1EncodableVector2 add:self.certReqId[i]];
        [localASN1EncodableVector2 add:self.checkAfter[i]];
        if (self.reason[i]) {
            [localASN1EncodableVector2 add:self.reason[i]];
        }
        ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
        [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
#endif
    return primitive;
}

@end
