//
//  ContentInfo.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ContentInfoPKCS.h"
#import "ASN1Sequence.h"
#import "BERTaggedObject.h"
#import "BERSequence.h"
#import "DLSequence.h"

@interface ContentInfoPKCS ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *contentType;
@property (nonatomic, readwrite, retain) ASN1Encodable *content;
@property (nonatomic, assign) BOOL isBer;

@end

@implementation ContentInfoPKCS
@synthesize contentType = _contentType;
@synthesize content = _content;
@synthesize isBer = _isBer;

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

+ (ContentInfoPKCS *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ContentInfoPKCS class]]) {
        return (ContentInfoPKCS *)paramObject;
    }
    if (paramObject) {
        return [[[ContentInfoPKCS alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.contentType = (ASN1ObjectIdentifier *)[localEnumeration nextObject];
        ASN1TaggedObject *asn1TaggedObject = nil;
        if (asn1TaggedObject = [localEnumeration nextObject]) {
            self.content = [asn1TaggedObject getObject];
        }
        self.isBer = [paramASN1Sequence isKindOfClass:[BERSequence class]];
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
        ASN1Encodable *contentEncodable = [[BERTaggedObject alloc] initParamBoolean:TRUE paramInt:0 paramASN1Encodable:self.content];
        [localASN1EncodableVector add:contentEncodable];
#if !__has_feature(objc_arc)
    if (contentEncodable) [contentEncodable release]; contentEncodable = nil;
#endif
    }
    if (self.isBer) {
        ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
        return primitive;
    }
    ASN1Primitive *primitive = [[[DLSequence alloc] initDLParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
