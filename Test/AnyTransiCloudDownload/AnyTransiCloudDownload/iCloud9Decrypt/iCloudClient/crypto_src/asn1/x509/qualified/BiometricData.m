//
//  BiometricData.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BiometricData.h"
#import "DERSequence.h"

@interface BiometricData ()

@property (nonatomic, readwrite, retain) TypeOfBiometricData *typeOfBiometricData;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) ASN1OctetString *biometricDataHash;
@property (nonatomic, readwrite, retain) DERIA5String *sourceDataUri;

@end

@implementation BiometricData
@synthesize typeOfBiometricData = _typeOfBiometricData;
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize biometricDataHash = _biometricDataHash;
@synthesize sourceDataUri = _sourceDataUri;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_typeOfBiometricData) {
        [_typeOfBiometricData release];
        _typeOfBiometricData = nil;
    }
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_biometricDataHash) {
        [_biometricDataHash release];
        _biometricDataHash = nil;
    }
    if (_sourceDataUri) {
        [_sourceDataUri release];
        _sourceDataUri = nil;
    }
    [super dealloc];
#endif
}

+ (BiometricData *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[BiometricData class]]) {
        return (BiometricData *)paramObject;
    }
    if (paramObject) {
        return [[[BiometricData alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.typeOfBiometricData = [TypeOfBiometricData getInstance:[localEnumeration nextObject]];
        self.hashAlgorithm = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        self.biometricDataHash = [ASN1OctetString getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        if (localObject = [localEnumeration nextObject]) {
            self.sourceDataUri = [DERIA5String getInstance:localObject];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamTypeOfBiometricData:(TypeOfBiometricData *)paramTypeOfBiometricData paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.typeOfBiometricData = paramTypeOfBiometricData;
        self.hashAlgorithm = paramAlgorithmIdentifier;
        self.biometricDataHash = paramASN1OctetString;
        self.sourceDataUri = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamTypeOfBiometricData:(TypeOfBiometricData *)paramTypeOfBiometricData paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramDERIA5String:(DERIA5String *)paramDERIA5String
{
    if (self = [super init]) {
        self.typeOfBiometricData = paramTypeOfBiometricData;
        self.hashAlgorithm = paramAlgorithmIdentifier;
        self.biometricDataHash = paramASN1OctetString;
        self.sourceDataUri = paramDERIA5String;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (TypeOfBiometricData *)getTypeOfBiometricData {
    return self.typeOfBiometricData;
}

- (AlgorithmIdentifier *)getHashAlgorithm {
    return self.hashAlgorithm;
}

- (ASN1OctetString *)getBiometricDataHash {
    return self.biometricDataHash;
}

- (DERIA5String *)getSourceDataUri {
    return self.sourceDataUri;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.typeOfBiometricData];
    [localASN1EncodableVector add:self.hashAlgorithm];
    [localASN1EncodableVector add:self.biometricDataHash];
    if (self.sourceDataUri) {
        [localASN1EncodableVector add:self.sourceDataUri];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
