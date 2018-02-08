//
//  AlgorithmIdentifier.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AlgorithmIdentifier.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface AlgorithmIdentifier ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *algorithm;
@property (nonatomic, readwrite, retain) ASN1Encodable *parameters;

@end

@implementation AlgorithmIdentifier
@synthesize algorithm = _algorithm;
@synthesize parameters = _parameters;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algorithm) {
        [_algorithm release];
        _algorithm = nil;
    }
    if (_parameters) {
        [_parameters release];
        _parameters = nil;
    }
    [super dealloc];
#endif
}

+ (AlgorithmIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AlgorithmIdentifier class]]) {
        return (AlgorithmIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[AlgorithmIdentifier alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (AlgorithmIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [AlgorithmIdentifier getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.algorithm = paramASN1ObjectIdentifier;
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
        self.algorithm = paramASN1ObjectIdentifier;
        self.parameters = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.algorithm = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] == 2) {
            self.parameters = [paramASN1Sequence getObjectAt:1];
        }else {
            self.parameters = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getAlgorithm {
    return self.algorithm;
}

- (ASN1Encodable *)getParameters {
    return self.parameters;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algorithm];
    if (self.parameters) {
        [localASN1EncodableVector add:self.parameters];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
