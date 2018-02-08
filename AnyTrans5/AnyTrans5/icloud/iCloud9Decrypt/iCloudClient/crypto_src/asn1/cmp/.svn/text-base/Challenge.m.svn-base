//
//  Challenge.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Challenge.h"
#import "ASN1EncodableVector.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@interface Challenge ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *owf;
@property (nonatomic, readwrite, retain) ASN1OctetString *witness;
@property (nonatomic, readwrite, retain) ASN1OctetString *challenge;

@end

@implementation Challenge
@synthesize owf = _owf;
@synthesize witness = _witness;
@synthesize challenge = _challenge;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_owf) {
        [_owf release];
        _owf = nil;
    }
    if (_witness) {
        [_witness release];
        _witness = nil;
    }
    if (_challenge) {
        [_challenge release];
        _challenge = nil;
    }
    [super dealloc];
#endif
}

+ (Challenge *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Challenge class]]) {
        return (Challenge *)paramObject;
    }
    if (paramObject) {
        return [[[Challenge alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([paramASN1Sequence size] == 3) {
            self.owf = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:i++]];
        }
        self.witness = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:i++]];
        self.challenge = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:i]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2
{
    if (self = [super init]) {
        [self initParamAlgorithmIdentifier:nil paramArrayOfByte1:paramArrayOfByte1 paramArrayOfByte2:paramArrayOfByte2];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2
{
    if (self = [super init]) {
        self.owf = paramAlgorithmIdentifier;
        ASN1OctetString *ness = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte1];
        ASN1OctetString *llenge = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte2];
        self.witness = ness;
        self.challenge = llenge;
#if !__has_feature(objc_arc)
        if (ness) [ness release]; ness = nil;
        if (llenge) [llenge release]; llenge = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getOwf {
    return self.owf;
}

- (NSMutableData *)getWitness {
    return [self.witness getOctets];
}

- (NSMutableData *)getChallenge {
    return [self.challenge getOctets];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [self addOptional:localASN1EncodableVector paramASN1Encodable:self.owf];
    [localASN1EncodableVector add:self.witness];
    [localASN1EncodableVector add:self.challenge];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        [paramASN1EncodableVector add:paramASN1Encodable];
    }
}

@end
