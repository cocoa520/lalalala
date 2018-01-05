//
//  ContentInfo.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ContentInfo.h"
#import "BERTaggedObject.h"
#import "BERSequence.h"

@interface ContentInfo ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *contentType;
@property (nonatomic, readwrite, retain) ASN1Encodable *content;

@end

@implementation ContentInfo
@synthesize contentType = _contentType;
@synthesize content = _content;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_contentType) {
        [_contentType release];
        _contentType = nil;
    }
    if (_content) {
        [_content release];
        _content = nil;
    }
    [super dealloc];
#endif
}

+ (ContentInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ContentInfo class]]) {
        return (ContentInfo *)paramObject;
    }
    if (paramObject) {
        return [[[ContentInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (ContentInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [ContentInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.contentType = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        if ([paramASN1Sequence size] > 1) {
            ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1];
            if ((![localASN1TaggedObject isExplicit]) || ([localASN1TaggedObject getTagNo] != 0)) {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Bad tag for 'content'" userInfo:nil];
            }
            self.content = [localASN1TaggedObject getObject];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.contentType = paramASN1ObjectIdentifier;
        self.content = paramASN1Encodable;
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

- (ASN1Encodable *)getContent {
    return self.content;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.contentType];
    if (self.content) {
        ASN1Encodable *contentEncodable = [[BERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.content];
        [localASN1EncodableVector add:contentEncodable];
#if !__has_feature(objc_arc)
    if (contentEncodable) [contentEncodable release]; contentEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
