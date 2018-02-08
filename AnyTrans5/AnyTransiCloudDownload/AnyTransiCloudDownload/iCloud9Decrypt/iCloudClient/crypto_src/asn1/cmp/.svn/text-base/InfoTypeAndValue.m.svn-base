//
//  InfoTypeAndValue.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "InfoTypeAndValue.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface InfoTypeAndValue ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *infoType;
@property (nonatomic, readwrite, retain) ASN1Encodable *infoValue;

@end

@implementation InfoTypeAndValue
@synthesize infoType = _infoType;
@synthesize infoValue = _infoValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_infoType) {
        [_infoType release];
        _infoType = nil;
    }
    if (_infoValue) {
        [_infoValue release];
        _infoValue = nil;
    }
    [super dealloc];
#endif
}

+ (InfoTypeAndValue *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[InfoTypeAndValue class]]) {
        return (InfoTypeAndValue *)paramObject;
    }
    if (paramObject) {
        return [[[InfoTypeAndValue alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.infoType = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.infoValue = [paramASN1Sequence getObjectAt:1];
        }
    }
    return self;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    self = [super init];
    if (self) {
        self.infoType = paramASN1ObjectIdentifier;
        self.infoValue = nil;
    }
    return self;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    self = [super init];
    if (self) {
        self.infoType = paramASN1ObjectIdentifier;
        self.infoValue = paramASN1Encodable;
    }
    return self;
}

- (ASN1ObjectIdentifier *)getInfoType {
    return self.infoType;
}

- (ASN1Encodable *)getInfoValue {
    return self.infoValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.infoType];
    if (self.infoValue) {
        [localASN1EncodableVector add:self.infoValue];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
