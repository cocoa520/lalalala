//
//  DigestInfo.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DigestInfo.h"
#import "ASN1OctetString.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface DigestInfo ()

@property (nonatomic, readwrite, retain) NSMutableData *digest;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *algId;

@end

@implementation DigestInfo
@synthesize digest = _digest;
@synthesize algId = _algId;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_digest) {
        [_digest release];
        _digest = nil;
    }
    if (_algId) {
        [_algId release];
        _algId = nil;
    }
    [super dealloc];
#endif
}

+ (DigestInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DigestInfo class]]) {
        return (DigestInfo *)paramObject;
    }
    if (paramObject) {
        return [[[DigestInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (DigestInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DigestInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.algId = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        self.digest = [[ASN1OctetString getInstance:[localEnumeration nextObject]] getOctets];
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
        self.digest = paramArrayOfByte;
        self.algId = paramAlgorithmIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getAlgorithmId {
    return self.algId;
}

- (NSMutableData *)getDigest {
    return self.digest;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.algId];
    ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:self.digest];
    [localASN1EncodableVector add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
