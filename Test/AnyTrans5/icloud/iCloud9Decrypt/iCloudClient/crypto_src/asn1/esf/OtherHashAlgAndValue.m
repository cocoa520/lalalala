//
//  OtherHashAlgAndValue.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherHashAlgAndValue.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface OtherHashAlgAndValue ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *hashValue;

@end

@implementation OtherHashAlgAndValue
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize hashValue = _hashValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_hashValue) {
        [_hashValue release];
        _hashValue = nil;
    }
    [super dealloc];
#endif
}

+ (OtherHashAlgAndValue *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherHashAlgAndValue class]]) {
        return (OtherHashAlgAndValue *)paramObject;
    }
    if (paramObject) {
        return [[[OtherHashAlgAndValue alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.hashAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.hashValue = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:1]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.hashAlgorithm = paramAlgorithmIdentifier;
        self.hashValue = paramASN1OctetString;
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

- (ASN1OctetString *)getHashValue {
    return self.hashValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.hashAlgorithm];
    [localASN1EncodableVector add:self.hashValue];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
