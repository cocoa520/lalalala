//
//  SignaturePolicyId.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignaturePolicyId.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface SignaturePolicyId ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *sigPolicyId;
@property (nonatomic, readwrite, retain) OtherHashAlgAndValue *sigPolicyHash;
@property (nonatomic, readwrite, retain) SigPolicyQualifiers *sigPolicyQualifiers;

@end

@implementation SignaturePolicyId
@synthesize sigPolicyId = _sigPolicyId;
@synthesize sigPolicyHash = _sigPolicyHash;
@synthesize sigPolicyQualifiers = _sigPolicyQualifiers;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_sigPolicyId) {
        [_sigPolicyId release];
        _sigPolicyId = nil;
    }
    if (_sigPolicyHash) {
        [_sigPolicyHash release];
        _sigPolicyHash = nil;
    }
    if (_sigPolicyQualifiers) {
        [_sigPolicyQualifiers release];
        _sigPolicyQualifiers = nil;
    }
    [super dealloc];
#endif
}

+ (SignaturePolicyId *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SignaturePolicyId class]]) {
        return (SignaturePolicyId *)paramObject;
    }
    if (paramObject) {
        return [[[SignaturePolicyId alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] != 2) && ([paramASN1Sequence size] != 3)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.sigPolicyId = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.sigPolicyHash = [OtherHashAlgAndValue getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] == 3) {
            self.sigPolicyQualifiers = [SigPolicyQualifiers getInstance:[paramASN1Sequence getObjectAt:2]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramOtherHashAlgAndValue:(OtherHashAlgAndValue *)paramOtherHashAlgAndValue
{
    if (self = [super init]) {
        [self initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramOtherHashAlgAndValue:paramOtherHashAlgAndValue paramSigPolicyQualifiers:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramOtherHashAlgAndValue:(OtherHashAlgAndValue *)paramOtherHashAlgAndValue paramSigPolicyQualifiers:(SigPolicyQualifiers *)paramSigPolicyQualifiers
{
    if (self = [super init]) {
        self.sigPolicyId = paramASN1ObjectIdentifier;
        self.sigPolicyHash = paramOtherHashAlgAndValue;
        self.sigPolicyQualifiers = paramSigPolicyQualifiers;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getSigPolicyId {
    return [[[ASN1ObjectIdentifier alloc] initParamString:[self.sigPolicyId getId]] autorelease];
}

- (OtherHashAlgAndValue *)getSigPolicyHash {
    return self.sigPolicyHash;
}

- (SigPolicyQualifiers *)getSigPolicyQualifiers {
    return self.sigPolicyQualifiers;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.sigPolicyId];
    [localASN1EncodableVector add:self.sigPolicyHash];
    if (self.sigPolicyQualifiers) {
        [localASN1EncodableVector add:self.sigPolicyQualifiers];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
