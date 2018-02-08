//
//  EncryptedData.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "EncryptedData.h"
#import "ASN1Sequence.h"
#import "BERSequence.h"
#import "BERTaggedObject.h"
#import "ASN1Integer.h"

@implementation EncryptedData
@synthesize data = _data;
@synthesize bagId = _bagId;
@synthesize bagValue = _bagValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_data) {
        [_data release];
        _data = nil;
    }
    if (_bagId) {
        [_bagId release];
        _bagId = nil;
    }
    if (_bagValue) {
        [_bagValue release];
        _bagValue = nil;
    }
    [super dealloc];
#endif
}

+ (EncryptedData *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[EncryptedData class]]) {
        return (EncryptedData *)paramObject;
    }
    if (paramObject) {
        return [[[EncryptedData alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = [[(ASN1Integer *)[paramASN1Sequence getObjectAt:0] getValue] intValue];
        if (i) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"sequence not version 0" userInfo:nil];
        }
        self.data = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        [localASN1EncodableVector add:paramASN1ObjectIdentifier];
        [localASN1EncodableVector add:[paramAlgorithmIdentifier toASN1Primitive]];
        ASN1Encodable *encodable = [[BERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:paramASN1Encodable];
        [localASN1EncodableVector add:encodable];
        ASN1Sequence *sequence = [[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector];
        self.data = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getContentType {
    return [ASN1ObjectIdentifier getInstance:[self.data getObjectAt:0]];
}

- (AlgorithmIdentifier *)getEncryptionAlgorithm {
    return [AlgorithmIdentifier getInstance:[self.data getObjectAt:1]];
}

- (ASN1OctetString *)getContent {
    if ([self.data size] == 3) {
        ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[self.data getObjectAt:2]];
        return [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:NO];
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *encodable = [[ASN1Integer alloc] initLong:0];
    [localASN1EncodableVector add:encodable];
    [localASN1EncodableVector add:self.data];
    ASN1Primitive *primitive = [[[BERSequence alloc] initBERParamASn1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
