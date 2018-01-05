//
//  PolicyInformation.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PolicyInformation.h"
#import "PolicyQualifierInfo.h"
#import "DERSequence.h"

@interface PolicyInformation ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *policyIdentifer;
@property (nonatomic, readwrite, retain) ASN1Sequence *policyQualifiers;

@end

@implementation PolicyInformation
@synthesize policyIdentifer = _policyIdentifier;
@synthesize policyQualifiers = _policyQualifiers;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_policyIdentifier) {
        [_policyIdentifier release];
        _policyIdentifier = nil;
    }
    if (_policyQualifiers) {
        [_policyQualifiers release];
        _policyQualifiers = nil;
    }
    [super dealloc];
#endif
}

+ (PolicyInformation *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[PolicyInformation class]]) {
        return (PolicyInformation *)paramObject;
    }
    return [[[PolicyInformation alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.policyIdentifer = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.policyQualifiers = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:1]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier
{
    if (self = [super init]) {
        self.policyIdentifer = paramASN1ObjectIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.policyIdentifer = paramASN1ObjectIdentifier;
        self.policyQualifiers = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getPolicyIdentifer {
    return self.policyIdentifer;
}

- (ASN1Sequence *)getPolicyQualifiers {
    return self.policyQualifiers;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.policyIdentifer];
    if (self.policyQualifiers) {
        [localASN1EncodableVector add:self.policyQualifiers];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer1 = [[NSMutableString alloc] init];
    [localStringBuffer1 appendString:@"Policy information: "];
    [localStringBuffer1 appendString:[NSString stringWithFormat:@"%@", self.policyIdentifer]];
    if (self.policyQualifiers) {
        NSMutableString *localStringBuffer2 = [[NSMutableString alloc] init];
        for (int i = 0; i < [self.policyQualifiers size]; i++) {
            if ([localStringBuffer2 length]) {
                [localStringBuffer2 appendString:@", "];
            }
            [localStringBuffer2 appendString:[NSString stringWithFormat:@"%@", [PolicyQualifierInfo getInstance:[self.policyQualifiers getObjectAt:i]]]];
        }
        [localStringBuffer1 appendString:@"["];
        [localStringBuffer1 appendString:localStringBuffer2];
        [localStringBuffer1 appendString:@"]"];
#if !__has_feature(objc_arc)
        if (localStringBuffer2) [localStringBuffer2 release]; localStringBuffer2 = nil;
#endif
    }
    NSString *tmpLocalStringBuffer1 = localStringBuffer1.description;
#if !__has_feature(objc_arc)
    if (localStringBuffer1) [localStringBuffer1 release]; localStringBuffer1 = nil;
#endif
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer1];
}

@end
