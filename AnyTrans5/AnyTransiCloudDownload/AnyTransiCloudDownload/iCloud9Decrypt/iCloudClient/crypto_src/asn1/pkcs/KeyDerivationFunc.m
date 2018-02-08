//
//  KeyDerivationFunc.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "KeyDerivationFunc.h"
#import "ASN1Sequence.h"

@interface KeyDerivationFunc ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algId;

@end

@implementation KeyDerivationFunc
@synthesize algId = _algId;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algId) {
        [_algId release];
        _algId = nil;
    }
    [super dealloc];
#endif
}

+ (KeyDerivationFunc *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[KeyDerivationFunc class]]) {
        return (KeyDerivationFunc *)paramObject;
    }
    if (paramObject) {
        return [[[KeyDerivationFunc alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.algId = [AlgorithmIdentifier getInstance:paramASN1Sequence];
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
        AlgorithmIdentifier *algo = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramASN1Encodable:paramASN1Encodable];
        self.algId = algo;
#if !__has_feature(objc_arc)
    if (algo) [algo release]; algo = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getAlgorithm {
    return [self.algId getAlgorithm];
}

- (ASN1Encodable *)getParameters {
    return [self.algId getParameters];
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.algId toASN1Primitive];
}

@end
