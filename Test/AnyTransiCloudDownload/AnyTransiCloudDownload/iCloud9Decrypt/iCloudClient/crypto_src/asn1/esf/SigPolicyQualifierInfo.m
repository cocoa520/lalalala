//
//  SigPolicyQualifierInfo.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SigPolicyQualifierInfo.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface SigPolicyQualifierInfo ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *sigPolicyQualifierId;
@property (nonatomic, readwrite, retain) ASN1Encodable *sigQualifier;

@end

@implementation SigPolicyQualifierInfo
@synthesize sigPolicyQualifierId = _sigPolicyQualifierId;
@synthesize sigQualifier = _sigQualifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_sigPolicyQualifierId) {
        [_sigPolicyQualifierId release];
        _sigPolicyQualifierId = nil;
    }
    if (_sigQualifier) {
        [_sigQualifier release];
        _sigQualifier = nil;
    }
    [super dealloc];
#endif
}

+ (SigPolicyQualifierInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SigPolicyQualifierInfo class]]) {
        return (SigPolicyQualifierInfo *)paramObject;
    }
    if (paramObject) {
        return [[[SigPolicyQualifierInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.sigPolicyQualifierId = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.sigQualifier = [paramASN1Sequence getObjectAt:1];
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
        self.sigPolicyQualifierId = paramASN1ObjectIdentifier;
        self.sigQualifier = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getSigPolicyQualifierId {
    return [[[ASN1ObjectIdentifier alloc] initParamString:[self.sigPolicyQualifierId getId]] autorelease];
}

- (ASN1Encodable *)getSigQualifier {
    return self.sigQualifier;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.sigPolicyQualifierId];
    [localASN1EncodableVector add:self.sigQualifier];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
