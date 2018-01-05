//
//  CertificationRequest.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificationRequest.h"
#import "DERSequence.h"

@implementation CertificationRequest
@synthesize reqInfo = _reqInfo;
@synthesize sigAlgId = _sigAlgId;
@synthesize sigBits = _sigBits;

+ (CertificationRequest *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertificationRequest class]]) {
        return (CertificationRequest *)paramObject;
    }
    if (paramObject) {
        return [[[CertificationRequest alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.reqInfo = [CertificationRequestInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        self.sigAlgId = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        self.sigBits = (DERBitString *)[paramASN1Sequence getObjectAt:2];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertificationRequestInfo:(CertificationRequestInfo *)paramCertificationRequestInfo paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        self.reqInfo = paramCertificationRequestInfo;
        self.sigAlgId = paramAlgorithmIdentifier;
        self.sigBits = paramDERBitString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    [self setReqInfo:nil];
    [self setSigAlgId:nil];
    [self setSigBits:nil];
    [super dealloc];
}

- (CertificationRequestInfo *)getCertificationRequestInfo {
    return self.reqInfo;
}

- (AlgorithmIdentifier *)getSignatureAlgorithm {
    return self.sigAlgId;
}

- (DERBitString *)getSignature {
    return self.sigBits;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.reqInfo];
    [localASN1EncodableVector add:self.sigAlgId];
    [localASN1EncodableVector add:self.sigBits];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
