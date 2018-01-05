//
//  PKMACValue.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKMACValue.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "CMPObjectIdentifiers.h"

@interface PKMACValue ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algId;
@property (nonatomic, readwrite, retain) DERBitString *value;

@end

@implementation PKMACValue
@synthesize algId = _algId;
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_algId) {
        [_algId release];
        _algId = nil;
    }
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (PKMACValue *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKMACValue class]]) {
        return (PKMACValue *)paramObject;
    }
    if (paramObject) {
        return [[[PKMACValue alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (PKMACValue *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [PKMACValue getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.algId = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.value = [DERBitString getInstance:[paramASN1Sequence getObjectAt:1]];
    }
    return self;
}

- (instancetype)initParamPBMParameter:(PBMParameter *)paramPBMParameter paramDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        AlgorithmIdentifier *algo = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[CMPObjectIdentifiers passwordBasedMac] paramASN1Encodable:paramPBMParameter];
        [self initParamAlgorithmIdentifier:algo paramDERBitString:paramDERBitString];
#if !__has_feature(objc_arc)
    if (algo) [algo release]; algo = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString
{
    if (self = [super init]) {
        self.algId = paramAlgorithmIdentifier;
        self.value = paramDERBitString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getAlgId {
    return _algId;
}

- (DERBitString *)getValue {
    return _value;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algId];
    [localASN1EncodableVector add:self.value];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
