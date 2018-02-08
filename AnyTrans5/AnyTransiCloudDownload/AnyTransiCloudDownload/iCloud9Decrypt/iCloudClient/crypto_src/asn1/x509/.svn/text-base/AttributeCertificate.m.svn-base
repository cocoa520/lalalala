//
//  AttributeCertificate.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AttributeCertificate.h"
#import "DERSequence.h"

@implementation AttributeCertificate
@synthesize acinfo = _acinfo;
@synthesize signatureAlgorithm = _signatureAlgorithm;
@synthesize signatureValue = _signatureValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_acinfo) {
        [_acinfo release];
        _acinfo = nil;
    }
    if (_signatureAlgorithm) {
        [_signatureAlgorithm release];
        _signatureAlgorithm = nil;
    }
    if (_signatureValue) {
        [_signatureValue release];
        _signatureValue = nil;
    }
    [super dealloc];
#endif
}

+ (AttributeCertificate *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AttributeCertificate class]]) {
        return (AttributeCertificate *)paramObject;
    }
    if (paramObject) {
        return [[[AttributeCertificate alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.acinfo = [AttributeCertificateInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        self.signatureAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        self.signatureValue = [DERBitString getInstance:[paramASN1Sequence getObjectAt:2]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAttributeCertificateInfo:(AttributeCertificateInfo *)paramAttributeCertificateInfo paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        self.acinfo = paramAttributeCertificateInfo;
        self.signatureAlgorithm = paramAlgorithmIdentifier;
        self.signatureValue = paramDERBitString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AttributeCertificateInfo *)getAcinfo {
    return self.acinfo;
}

- (AlgorithmIdentifier *)getSignatureAlgorithm {
    return self.signatureAlgorithm;
}

- (DERBitString *)getSignatureValue {
    return self.signatureValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.acinfo];
    [localASN1EncodableVector add:self.signatureAlgorithm];
    [localASN1EncodableVector add:self.signatureValue];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
