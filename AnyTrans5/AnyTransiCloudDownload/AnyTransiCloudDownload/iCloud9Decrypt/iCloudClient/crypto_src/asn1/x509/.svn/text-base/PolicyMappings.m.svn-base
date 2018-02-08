//
//  PolicyMappings.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PolicyMappings.h"
#import "DERSequence.h"

@implementation PolicyMappings
@synthesize seq = _seq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (PolicyMappings *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PolicyMappings class]]) {
        return (PolicyMappings *)paramObject;
    }
    if (paramObject) {
        return [[[PolicyMappings alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamHashtable:(NSMutableDictionary *)paramHashtable
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
        NSEnumerator *localEnumeration = [paramHashtable keyEnumerator];
        NSString *str1 = nil;
        while (str1 = [localEnumeration nextObject]) {
            NSString *str2 = (NSString *)[paramHashtable objectForKey:str1];
            ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
            ASN1Encodable *object1 = [[ASN1ObjectIdentifier alloc] initParamString:str1];
            ASN1Encodable *object2 = [[ASN1ObjectIdentifier alloc] initParamString:str2];
            ASN1Encodable *derSequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
            [localASN1EncodableVector2 add:object1];
            [localASN1EncodableVector2 add:object2];
            [localASN1EncodableVector1 add:derSequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (object1) [object1 release]; object1 = nil;
    if (object2) [object2 release]; object2 = nil;
    if (derSequence) [derSequence release]; derSequence = nil;
#endif
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
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

- (instancetype)initParamCertPolicyId1:(CertPolicyId *)paramCertPolicyId1 paramCertPolicyId2:(CertPolicyId *)paramCertPolicyId2
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        [localASN1EncodableVector add:paramCertPolicyId1];
        [localASN1EncodableVector add:paramCertPolicyId2];
        ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:encodable];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
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

- (instancetype)initParamArrayOfCertPolicyId1:(NSMutableArray *)paramArrayOfCertPolicyId1 paramArrayOfCertPolicyId2:(NSMutableArray *)paramArrayOfCertPolicyId2
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i != [paramArrayOfCertPolicyId1 count]; i++) {
            ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
            [localASN1EncodableVector2 add:paramArrayOfCertPolicyId1[i]];
            [localASN1EncodableVector2 add:paramArrayOfCertPolicyId2[i]];
            ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
            [localASN1EncodableVector1 add:encodable];
#if !__has_feature(objc_arc)
            if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
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

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

@end
