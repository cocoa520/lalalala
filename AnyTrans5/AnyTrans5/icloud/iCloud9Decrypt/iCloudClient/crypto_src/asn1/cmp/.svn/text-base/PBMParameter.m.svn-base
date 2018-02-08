//
//  PBMParameter.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PBMParameter.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@interface PBMParameter ()

@property (nonatomic, readwrite, retain) ASN1OctetString *salt;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *owf;
@property (nonatomic, readwrite, retain) ASN1Integer *iterationCount;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *mac;

@end

@implementation PBMParameter
@synthesize salt = _salt;
@synthesize owf = _owf;
@synthesize iterationCount = _iterationCount;
@synthesize mac = _mac;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_salt) {
        [_salt release];
        _salt = nil;
    }
    if (_owf) {
        [_owf release];
        _owf = nil;
    }
    if (_iterationCount) {
        [_iterationCount release];
        _iterationCount = nil;
    }
    if (_mac) {
        [_mac release];
        _mac = nil;
    }
    [super dealloc];
#endif
}

+ (PBMParameter *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PBMParameter class]]) {
        return (PBMParameter *)paramObject;
    }
    if (paramObject) {
        return [[[PBMParameter alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.salt = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:0]];
        self.owf = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
        self.iterationCount = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:2]];
        self.mac = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:3]];
    }
    return self;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramInt:(int)paramInt paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2
{
    self = [super init];
    if (self) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        [self initParamASN1OctetString:octetString paramAlgorithmIdentifier1:paramAlgorithmIdentifier1 paramASN1Integer:integer paramAlgorithmIdentifier2:paramAlgorithmIdentifier2];
#if !__has_feature(objc_arc)
        if (octetString) [octetString release]; octetString = nil;
        if (integer) [integer release]; integer = nil;
#endif
    }
    return self;
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramASN1Integer:(ASN1Integer *)paramASN1Integer paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2
{
    self = [super init];
    if (self) {
        self.salt = paramASN1OctetString;
        self.owf = paramAlgorithmIdentifier1;
        self.iterationCount = paramASN1Integer;
        self.mac = paramAlgorithmIdentifier2;
    }
    return self;
}

- (ASN1OctetString *)getSalt {
    return self.salt;
}

- (AlgorithmIdentifier *)getOwf {
    return self.owf;
}

- (ASN1Integer *)getIterationCount {
    return self.iterationCount;
}

- (AlgorithmIdentifier *)getMac {
    return self.mac;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.salt];
    [localASN1EncodableVector add:self.owf];
    [localASN1EncodableVector add:self.iterationCount];
    [localASN1EncodableVector add:self.mac];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
