//
//  EncryptedContentInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EncryptedContentInfo.h"
#import "ASN1Sequence.h"
#import "BERTaggedObject.h"
#import "BERSequence.h"

@interface EncryptedContentInfo ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *contentType;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *contentEncryptionAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *encryptedContent;

@end

@implementation EncryptedContentInfo
@synthesize contentType = _contentType;
@synthesize contentEncryptionAlgorithm = _contentEncryptionAlgorithm;
@synthesize encryptedContent = _encryptedContent;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_contentType) {
        [_contentType release];
        _contentType = nil;
    }
    if (_contentEncryptionAlgorithm) {
        [_contentEncryptionAlgorithm release];
        _contentEncryptionAlgorithm = nil;
    }
    if (_encryptedContent) {
        [_encryptedContent release];
        _encryptedContent = nil;
    }
    [super dealloc];
#endif
}

+ (EncryptedContentInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EncryptedContentInfo class]]) {
        return (EncryptedContentInfo *)paramObject;
    }
    if (paramObject) {
        return [[[EncryptedContentInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] < 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Truncated Sequence Found" userInfo:nil];
        }
        self.contentType = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.contentEncryptionAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] > 2) {
            self.encryptedContent = [ASN1OctetString getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:2] paramBoolean:false];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.contentType = paramASN1ObjectIdentifier;
        self.contentEncryptionAlgorithm = paramAlgorithmIdentifier;
        self.encryptedContent = paramASN1OctetString;
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

- (AlgorithmIdentifier *)getContentEncryptionAlgorithm {
    return self.contentEncryptionAlgorithm;
}

- (ASN1OctetString *)getEncryptedContent {
    return self.encryptedContent;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.contentType];
    [localASN1EncodableVector add:self.contentEncryptionAlgorithm];
    if (self.encryptedContent) {
        ASN1Encodable *encodable = [[BERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:self.encryptedContent];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
