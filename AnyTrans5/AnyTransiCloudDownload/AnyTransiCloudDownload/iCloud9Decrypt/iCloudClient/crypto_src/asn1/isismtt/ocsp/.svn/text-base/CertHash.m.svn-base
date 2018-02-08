//
//  CertHash.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertHash.h"
#import "ASN1Sequence.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface CertHash ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) NSMutableData *certificateHash;

@end

@implementation CertHash
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize certificateHash = _certificateHash;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_certificateHash) {
        [_certificateHash release];
        _certificateHash = nil;
    }
    [super dealloc];
#endif
}

+ (CertHash *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[CertHash class]]) {
        return (CertHash *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[CertHash alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.hashAlgorithm = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
        self.certificateHash = [[DEROctetString getInstance:[paramASN1Sequence getObjectAt:1]] getOctets];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.hashAlgorithm = paramAlgorithmIdentifier;
        NSMutableData *mutData = [[NSMutableData alloc] initWithSize:(int)paramArrayOfByte.length];
        self.certificateHash = mutData;
        [self.certificateHash copyFromIndex:0 withSource:paramArrayOfByte withSourceIndex:0 withLength:(int)[paramArrayOfByte length]];
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getHashAlgorithm {
    return self.hashAlgorithm;
}

- (NSMutableData *)getCertificateHash {
    return self.certificateHash;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.hashAlgorithm];
    ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:self.certificateHash];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
