//
//  ContentHints.m
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ContentHints.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface ContentHints ()

@property (nonatomic, readwrite, retain) DERUTF8String *contentDescription;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *contentType;

@end

@implementation ContentHints
@synthesize contentDescription = _contentDescription;
@synthesize contentType = _contentType;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_contentDescription) {
        [_contentDescription release];
        _contentDescription = nil;
    }
    if (_contentType) {
        [_contentType release];
        _contentType = nil;
    }
    [super dealloc];
#endif
}

+ (ContentHints *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ContentHints class]]) {
        return (ContentHints *)paramObject;
    }
    if (paramObject) {
        return [[[ContentHints alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        ASN1Encodable *localASN1Encodable = [paramASN1Sequence getObjectAt:0];
        if ([[localASN1Encodable toASN1Primitive] isKindOfClass:[DERUTF8String class]]) {
            self.contentDescription = [DERUTF8String getInstance:localASN1Encodable];
            self.contentType = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        }else {
            self.contentType = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.contentType = paramASN1ObjectIdentifier;
        self.contentDescription = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramDERUTF8String:(DERUTF8String *)paramDERUTF8String
{
    if (self = [super init]) {
        self.contentType = paramASN1ObjectIdentifier;
        self.contentDescription = paramDERUTF8String;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getContentType {
    return self.contentType;
}

- (DERUTF8String *)getContentDescription {
    return self.contentDescription;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.contentDescription) {
        [localASN1EncodableVector add:self.contentDescription];
    }
    [localASN1EncodableVector add:self.contentType];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
