//
//  CertRequest.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertRequest.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface CertRequest ()

@property (nonatomic, readwrite, retain) ASN1Integer *certReqId;
@property (nonatomic, readwrite, retain) CertTemplate *certTemplate;
@property (nonatomic, readwrite, retain) Controls *controls;

@end

@implementation CertRequest
@synthesize certReqId = _certReqId;
@synthesize certTemplate = _certTemplate;
@synthesize controls = _controls;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certReqId) {
        [_certReqId release];
        _certReqId = nil;
    }
    if (_certTemplate) {
        [_certTemplate release];
        _certTemplate = nil;
    }
    if (_controls) {
        [_controls release];
        _controls = nil;
    }
   [super dealloc];
#endif
}

+ (CertRequest *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertRequest class]]) {
        return (CertRequest *)paramObject;
    }
    if (paramObject) {
        return [[[CertRequest alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:[[ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]] getValue]];
        self.certReqId = integer;
        self.certTemplate = [CertTemplate getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] > 2) {
            self.controls = [Controls getInstance:[paramASN1Sequence getObjectAt:2]];
        }
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

- (instancetype)initParamInt:(int)paramInt paramCertTemplate:(CertTemplate *)paramCertTemplate paramControls:(Controls *)paramControls
{
    self = [super init];
    if (self) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        [self initParamASN1Integer:integer paramCertTemplate:paramCertTemplate paramControls:paramControls];
#if !__has_feature(objc_arc)
        if (integer) [integer release]; integer = nil;
#endif
    }
    return self;
}

- (instancetype)initParamASN1Integer:(ASN1Integer *)paramASN1Integer paramCertTemplate:(CertTemplate *)paramCertTemplate paramControls:(Controls *)paramControls
{
    self = [super init];
    if (self) {
        self.certReqId = paramASN1Integer;
        self.certTemplate = paramCertTemplate;
        self.controls = paramControls;
    }
    return self;
}

- (ASN1Integer *)getCertReqId {
    return self.certReqId;
}

- (CertTemplate *)getCertTemplate {
    return self.certTemplate;
}

- (Controls *)getControls {
    return self.controls;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certReqId];
    [localASN1EncodableVector add:self.certTemplate];
    if (self.controls) {
        [localASN1EncodableVector add:self.controls];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
