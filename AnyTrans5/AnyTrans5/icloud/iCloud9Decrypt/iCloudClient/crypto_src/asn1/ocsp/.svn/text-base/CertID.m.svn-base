//
//  CertID.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation CertID
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize issuerNameHash = _issuerNameHash;
@synthesize issuerKeyHash = _issuerKeyHash;
@synthesize serialNumber = _serialNumber;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_issuerNameHash) {
        [_issuerNameHash release];
        _issuerNameHash = nil;
    }
    if (_issuerKeyHash) {
        [_issuerKeyHash release];
        _issuerKeyHash = nil;
    }
    if (_serialNumber) {
        [_serialNumber release];
        _serialNumber = nil;
    }
    [super dealloc];
#endif
}

+ (CertID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertID class]]) {
        return (CertID *)paramObject;
    }
    if (paramObject) {
        return [[[CertID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (CertID *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [CertID getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.hashAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.issuerNameHash = ((ASN1OctetString *)[paramASN1Sequence getObjectAt:1]);
        self.issuerKeyHash = ((ASN1OctetString *)[paramASN1Sequence getObjectAt:2]);
        self.serialNumber = ((ASN1Integer *)[paramASN1Sequence getObjectAt:3]);
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString1:(ASN1OctetString *)paramASN1OctetString1 paramASN1OctetString2:(ASN1OctetString *)paramASN1OctetString2 paramASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        self.hashAlgorithm = paramAlgorithmIdentifier;
        self.issuerNameHash = paramASN1OctetString1;
        self.issuerKeyHash = paramASN1OctetString2;
        self.serialNumber = paramASN1Integer;
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

- (ASN1OctetString *)getIssuerNameHash {
    return self.issuerNameHash;
}

- (ASN1OctetString *)getIssuerKeyHash {
    return self.issuerKeyHash;
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.hashAlgorithm];
    [localASN1EncodableVector add:self.issuerNameHash];
    [localASN1EncodableVector add:self.issuerKeyHash];
    [localASN1EncodableVector add:self.serialNumber];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
