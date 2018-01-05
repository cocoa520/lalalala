//
//  PolicyConstraints.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PolicyConstraints.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "ASN1Integer.h"
#import "Extension.h"

@interface PolicyConstraints ()

@property (nonatomic, readwrite, retain) BigInteger *requireExplicitPolicyMapping;
@property (nonatomic, readwrite, retain) BigInteger *inhibitPolicyMapping;

@end

@implementation PolicyConstraints
@synthesize requireExplicitPolicyMapping = _requireExplicitPolicyMapping;
@synthesize inhibitPolicyMapping = _inhibitPolicyMapping;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_requireExplicitPolicyMapping) {
        [_requireExplicitPolicyMapping release];
        _requireExplicitPolicyMapping = nil;
    }
    if (_inhibitPolicyMapping) {
        [_inhibitPolicyMapping release];
        _inhibitPolicyMapping = nil;
    }
    [super dealloc];
#endif
}

+ (PolicyConstraints *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PolicyConstraints class]]) {
        return (PolicyConstraints *)paramObject;
    }
    if (paramObject) {
        return [[[PolicyConstraints alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (PolicyConstraints *)fromExtensions:(Extensions *)paramExtensions {
    return [PolicyConstraints getInstance:[paramExtensions getExtensionParsedValue:[Extension policyConstraints]]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:i]];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.requireExplicitPolicyMapping = [[ASN1Integer getInstance:localASN1TaggedObject paramBoolean:NO] getValue];
            }else if ([localASN1TaggedObject getTagNo] == 1) {
                self.inhibitPolicyMapping = [[ASN1Integer getInstance:localASN1TaggedObject paramBoolean:NO] getValue];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Unknown tag encountered." userInfo:nil];
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        self.requireExplicitPolicyMapping = paramBigInteger1;
        self.inhibitPolicyMapping = paramBigInteger2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BigInteger *)getRequireExplicitPolicyMapping {
    return self.requireExplicitPolicyMapping;
}

- (BigInteger *)getInhibitPolicyMapping {
    return self.inhibitPolicyMapping;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.requireExplicitPolicyMapping) {
        ASN1Integer *integerEncodable = [[ASN1Integer alloc] initBI:self.requireExplicitPolicyMapping];
        ASN1Encodable *encodable  = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:integerEncodable];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
    if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.inhibitPolicyMapping) {
        ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initBI:self.inhibitPolicyMapping];
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamInt:1 paramASN1Encodable:integerEncodable];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
