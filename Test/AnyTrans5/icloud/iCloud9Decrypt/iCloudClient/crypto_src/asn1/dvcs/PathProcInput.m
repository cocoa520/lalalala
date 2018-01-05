//
//  PathProcInput.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PathProcInput.h"
#import "ASN1Sequence.h"
#import "PolicyInformation.h"
#import "ASN1Boolean.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "CategoryExtend.h"

@interface PathProcInput ()

@property (nonatomic, readwrite, retain) NSMutableArray *acceptablePolicySet;
@property (nonatomic, assign) BOOL inhibitPolicyMapping;
@property (nonatomic, assign) BOOL explicitPolicyReqd;
@property (nonatomic, assign) BOOL inhibitAnyPolicy;

@end

@implementation PathProcInput
@synthesize acceptablePolicySet = _acceptablePolicySet;
@synthesize inhibitPolicyMapping = _inhibitPolicyMapping;
@synthesize explicitPolicyReqd = _explicitPolicyReqd;
@synthesize inhibitAnyPolicy = _inhibitAnyPolicy;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_acceptablePolicySet) {
        [_acceptablePolicySet release];
        _acceptablePolicySet = nil;
    }
    [super dealloc];
#endif
}

+ (PathProcInput *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PathProcInput class]]) {
        return (PathProcInput *)paramObject;
    }
    if (paramObject) {
        ASN1Sequence *localASN1Sequence1 = [ASN1Sequence getInstance:paramObject];
        ASN1Sequence *localASN1Sequence2 = [ASN1Sequence getInstance:[localASN1Sequence1 getObjectAt:0]];
        PathProcInput *localPathProcInput = [[[PathProcInput alloc] initParamArrayOfPolicyInformation:[self fromSequence:localASN1Sequence2]] autorelease];
        for (int i = 1; i < [localASN1Sequence1 size]; i++) {
            ASN1Encodable *localASN1Encodable = [localASN1Sequence1 getObjectAt:i];
            id localObject;
            if ([localASN1Encodable isKindOfClass:[ASN1Boolean class]]) {
                localObject = [ASN1Boolean getInstanceObject:localASN1Encodable];
                [localPathProcInput setInhibitPolicyMapping:[((ASN1Boolean *)localObject) isTrue]];
            }else if ([localASN1Encodable isKindOfClass:[ASN1TaggedObject class]]) {
                localObject = [ASN1TaggedObject getInstance:localASN1Encodable];
                ASN1Boolean *localASN1Boolean;
                switch ([((ASN1TaggedObject *)localObject) getTagNo]) {
                    case 0:
                        localASN1Boolean = [ASN1Boolean getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
                        [localPathProcInput setExplicitPolicyReqd:[localASN1Boolean isTrue]];
                        break;
                    case 1:
                        localASN1Boolean = [ASN1Boolean getInstance:(ASN1TaggedObject *)localObject paramBoolean:false];
                        [localPathProcInput setInhibitAnyPolicy:[localASN1Boolean isTrue]];
                    default:
                        break;
                }
            }
        }
        return localPathProcInput;
    }
    return nil;
}

+ (PathProcInput *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [PathProcInput getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (NSMutableArray *)fromSequence:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *arrayOfPolicyInformation = [[[NSMutableArray alloc] initWithSize:[paramASN1Sequence size]] autorelease];
    for (int i = 0; i != arrayOfPolicyInformation.count; i++) {
        arrayOfPolicyInformation[i] = [PolicyInformation getInstance:[paramASN1Sequence getObjectAt:i]];
    }
    return arrayOfPolicyInformation;
}

- (instancetype)initParamArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation
{
    self = [super init];
    if (self) {
        self.acceptablePolicySet = paramArrayOfPolicyInformation;
    }
    return self;
}

- (instancetype)initParamArrayOfPolicyInformation:(NSMutableArray *)paramArrayOfPolicyInformation paramBoolean1:(BOOL)paramBoolean1 paramBoolean2:(BOOL)paramBoolean2 paramBoolean3:(BOOL)paramBoolean3
{
    self = [super init];
    if (self) {
        self.acceptablePolicySet = paramArrayOfPolicyInformation;
        self.inhibitPolicyMapping = paramBoolean1;
        self.explicitPolicyReqd = paramBoolean2;
        self.inhibitAnyPolicy = paramBoolean3;
    }
    return self;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i != self.acceptablePolicySet.count; i++) {
        [localASN1EncodableVector2 add:self.acceptablePolicySet[i]];
    }
    ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
    [localASN1EncodableVector1 add:encodable];
    if (self.inhibitPolicyMapping) {
        ASN1Encodable *inhibitPolicyMappingEncodable = [[ASN1Boolean alloc] initParamBoolean:self.inhibitPolicyMapping];
        [localASN1EncodableVector1 add:inhibitPolicyMappingEncodable];
#if !__has_feature(objc_arc)
    if (inhibitPolicyMappingEncodable) [inhibitPolicyMappingEncodable release]; inhibitPolicyMappingEncodable = nil;
#endif
    }
    if (self.explicitPolicyReqd) {
        ASN1Encodable *explicitPolicyReqdBooleanEncodable = [[ASN1Boolean alloc] initParamBoolean:self.explicitPolicyReqd];
        ASN1Encodable *explicitPolicyReqdDerTaggedEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:0 paramASN1Encodable:explicitPolicyReqdBooleanEncodable];
        [localASN1EncodableVector1 add:explicitPolicyReqdDerTaggedEncodable];
#if !__has_feature(objc_arc)
    if (explicitPolicyReqdBooleanEncodable) [explicitPolicyReqdBooleanEncodable release]; explicitPolicyReqdBooleanEncodable = nil;
    if (explicitPolicyReqdDerTaggedEncodable) [explicitPolicyReqdDerTaggedEncodable release]; explicitPolicyReqdDerTaggedEncodable = nil;
#endif
    }
    if (self.inhibitAnyPolicy) {
        ASN1Encodable *inhibitAnyPolicyBooleanEncodable = [[ASN1Boolean alloc] initParamBoolean:self.inhibitAnyPolicy];
        ASN1Encodable *inhibitAnyPolicyDerTaggedEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:inhibitAnyPolicyBooleanEncodable];
        [localASN1EncodableVector1 add:inhibitAnyPolicyDerTaggedEncodable];
#if !__has_feature(objc_arc)
    if (inhibitAnyPolicyBooleanEncodable) [inhibitAnyPolicyBooleanEncodable release]; inhibitAnyPolicyBooleanEncodable = nil;
    if (inhibitAnyPolicyDerTaggedEncodable) [inhibitAnyPolicyDerTaggedEncodable release]; inhibitAnyPolicyDerTaggedEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"PathProcInput: {\nacceptablePolicySet: %@\ninhibitPolicyMapping: %d\nexplicitPolicyReqd: %d\ninhibitAnyPolicy: %d\n}\n", self.acceptablePolicySet, self.inhibitPolicyMapping, self.explicitPolicyReqd, self.inhibitAnyPolicy];
}

- (NSMutableArray *)getAcceptablePolicySet {
    return self.acceptablePolicySet;
}

- (BOOL)isInhibitPolicyMapping {
    return self.inhibitPolicyMapping;
}

- (void)setInhibitPolicyMapping:(BOOL)inhibitPolicyMapping {
    self.inhibitPolicyMapping = inhibitPolicyMapping;
}

- (BOOL)isExplicitPolicyReqd {
    return self.explicitPolicyReqd;
}

- (void)setExplicitPolicyReqd:(BOOL)explicitPolicyReqd {
    self.explicitPolicyReqd = explicitPolicyReqd;
}

- (BOOL)isInhibitAnyPolicy {
    return self.inhibitAnyPolicy;
}

- (void)setInhibitAnyPolicy:(BOOL)inhibitAnyPolicy {
    self.inhibitAnyPolicy = inhibitAnyPolicy;
}

@end
