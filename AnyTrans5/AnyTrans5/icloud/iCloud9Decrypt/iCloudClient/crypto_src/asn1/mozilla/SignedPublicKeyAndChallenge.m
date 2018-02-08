//
//  SignedPublicKeyAndChallenge.m
//  crypto
//
//  Created by JGehry on 6/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignedPublicKeyAndChallenge.h"

@interface SignedPublicKeyAndChallenge ()

@property (nonatomic, readwrite, retain) PublicKeyAndChallenge *pubKeyAndChal;
@property (nonatomic, readwrite, retain) ASN1Sequence *pkacSeq;

@end

@implementation SignedPublicKeyAndChallenge
@synthesize pubKeyAndChal = _pubKeyAndChal;
@synthesize pkacSeq = _pkacSeq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_pubKeyAndChal) {
        [_pubKeyAndChal release];
        _pubKeyAndChal = nil;
    }
    if (_pkacSeq) {
        [_pkacSeq release];
        _pkacSeq = nil;
    }
    [super dealloc];
#endif
}

+ (SignedPublicKeyAndChallenge *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SignedPublicKeyAndChallenge class]]) {
        return (SignedPublicKeyAndChallenge *)paramObject;
    }
    if (paramObject) {
        return [[[SignedPublicKeyAndChallenge alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.pkacSeq = paramASN1Sequence;
        self.pubKeyAndChal = [PublicKeyAndChallenge getInstance:[paramASN1Sequence getObjectAt:0]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (ASN1Primitive *)toASN1Primitive {
    return self.pkacSeq;
}

- (PublicKeyAndChallenge *)getPublicKeyAndChallenge {
    return self.pubKeyAndChal;
}

- (AlgorithmIdentifier *)getSignatureAlgorithm {
    return [AlgorithmIdentifier getInstance:[self.pkacSeq getObjectAt:1]];
}

- (DERBitString *)getSignature {
    return [DERBitString getInstance:[self.pkacSeq getObjectAt:2]];
}

@end
