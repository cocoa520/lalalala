//
//  ProtectedPart.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ProtectedPart.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface ProtectedPart ()

@property (nonatomic, readwrite, retain) PKIHeader *header;
@property (nonatomic, readwrite, retain) PKIBody *body;

@end

@implementation ProtectedPart
@synthesize header = _header;
@synthesize body = _body;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_header) {
        [_header release];
        _header = nil;
    }
    if (_body) {
        [_body release];
        _body = nil;
    }
    [super dealloc];
#endif
}

+ (ProtectedPart *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ProtectedPart class]]) {
        return (ProtectedPart *)paramObject;
    }
    if (paramObject) {
        return [[[ProtectedPart alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.header = [PKIHeader getInstance:[paramASN1Sequence getObjectAt:0]];
        self.body = [PKIBody getInstance:[paramASN1Sequence getObjectAt:1]];
    }
    return self;
}

- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody
{
    self = [super init];
    if (self) {
        self.header = paramPKIHeader;
        self.body = paramPKIBody;
    }
    return self;
}

- (PKIHeader *)getHeader {
    return self.header;
}

- (PKIBody *)getBody {
    return self.body;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.header];
    [localASN1EncodableVector add:self.body];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
