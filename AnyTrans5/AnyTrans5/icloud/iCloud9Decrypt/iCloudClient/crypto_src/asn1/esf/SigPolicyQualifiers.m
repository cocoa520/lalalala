//
//  SigPolicyQualifiers.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SigPolicyQualifiers.h"
#import "DERSequence.h"

@implementation SigPolicyQualifiers
@synthesize qualifiers = _qualifiers;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_qualifiers) {
        [_qualifiers release];
        _qualifiers = nil;
    }
    [super dealloc];
#endif
}

+ (SigPolicyQualifiers *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SigPolicyQualifiers class]]) {
        return (SigPolicyQualifiers *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[SigPolicyQualifiers alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.qualifiers = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfSigPolicyQualifierInfo:(NSMutableArray *)paramArrayOfSigPolicyQualifierInfo
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfSigPolicyQualifierInfo.count; i++) {
            [localASN1EncodableVector add:paramArrayOfSigPolicyQualifierInfo[i]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.qualifiers = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)size {
    return (int)[self.qualifiers size];
}

- (SigPolicyQualifierInfo *)getInfoAt:(int)paramInt {
    return [SigPolicyQualifierInfo getInstance:[self.qualifiers getObjectAt:paramInt]];
}

- (ASN1Primitive *)toASN1Primitive {
    return self.qualifiers;
}

@end
