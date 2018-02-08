//
//  Signature.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Signature.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation Signature
@synthesize signatureAlgorithm = _signatureAlgorithm;
@synthesize signature = _signature;
@synthesize certs = _certs;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_signatureAlgorithm) {
        [_signatureAlgorithm release];
        _signatureAlgorithm = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
    if (_certs) {
        [_certs release];
        _certs = nil;
    }
    [super dealloc];
#endif
}

+ (Signature *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Signature class]]) {
        return (Signature *)paramObject;
    }
    if (paramObject) {
        return [[[Signature alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (Signature *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [Signature getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.signatureAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.signature = (DERBitString *)[paramASN1Sequence getObjectAt:1];
        if ([paramASN1Sequence size] == 3) {
            self.certs = [ASN1Sequence getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:2] paramBoolean:YES];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        self.signatureAlgorithm = paramAlgorithmIdentifier;
        self.signature = paramDERBitString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.signatureAlgorithm = paramAlgorithmIdentifier;
        self.signature = paramDERBitString;
        self.certs = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (AlgorithmIdentifier *)getSignatureAlgorithm {
    return self.signatureAlgorithm;
}

- (DERBitString *)getSignature {
    return self.signature;
}

- (ASN1Sequence *)getCerts {
    return self.certs;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.signatureAlgorithm];
    [localASN1EncodableVector add:self.signature];
    if (self.certs) {
        ASN1Encodable *certsEncodable  = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.certs];
        [localASN1EncodableVector add:certsEncodable];
#if !__has_feature(objc_arc)
        if (certsEncodable) [certsEncodable release]; certsEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
