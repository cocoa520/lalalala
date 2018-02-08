//
//  MessageImprint.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "MessageImprint.h"
#import "ASN1Sequence.h"
#import "ASN1OctetString.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@implementation MessageImprint
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize hashedMessage = _hashedMessage;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_hashedMessage) {
        [_hashedMessage release];
        _hashedMessage = nil;
    }
    [super dealloc];
#endif
}

+ (MessageImprint *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[MessageImprint class]]) {
        return (MessageImprint *)paramObject;
    }
    if (paramObject) {
        return [[[MessageImprint alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.hashAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.hashedMessage = [[ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:1]] getOctets];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.hashAlgorithm = paramAlgorithmIdentifier;
        self.hashedMessage = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (AlgorithmIdentifier *)getHashAlgorithm {
    return self.hashAlgorithm;
}

- (NSMutableData *)getHashedMessage {
    return self.hashedMessage;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.hashAlgorithm];
    ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:self.hashedMessage];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
