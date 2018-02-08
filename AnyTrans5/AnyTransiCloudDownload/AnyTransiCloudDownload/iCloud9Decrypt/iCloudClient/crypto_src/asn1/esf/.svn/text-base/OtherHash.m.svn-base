//
//  OtherHash.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherHash.h"
#import "DEROctetString.h"
#import "OIWObjectIdentifier.h"

@interface OtherHash ()

@property (nonatomic, readwrite, retain) ASN1OctetString *sha1Hash;
@property (nonatomic, readwrite, retain) OtherHashAlgAndValue *otherHash;

@end

@implementation OtherHash
@synthesize sha1Hash = _sha1Hash;
@synthesize otherHash = _otherHash;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_sha1Hash) {
        [_sha1Hash release];
        _sha1Hash = nil;
    }
    if (_otherHash) {
        [_otherHash release];
        _otherHash = nil;
    }
    [super dealloc];
#endif
}

+ (OtherHash *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherHash class]]) {
        return (OtherHash *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1OctetString class]]) {
        return [[[OtherHash alloc] initParamASN1OctetString:(ASN1OctetString *)paramObject] autorelease];
    }
    return [[[OtherHash alloc] initParamOtherHashAlgAndValue:[OtherHashAlgAndValue getInstance:paramObject]] autorelease];
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    self = [super init];
    if (self) {
        self.sha1Hash = paramASN1OctetString;
    }
    return self;
}

- (instancetype)initParamOtherHashAlgAndValue:(OtherHashAlgAndValue *)paramOtherHashAlgAndValue
{
    self = [super init];
    if (self) {
        self.otherHash = paramOtherHashAlgAndValue;
    }
    return self;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    self = [super init];
    if (self) {
        self.sha1Hash = [[[DEROctetString alloc] initDEROctetString:paramArrayOfByte] autorelease];
    }
    return self;
}

- (AlgorithmIdentifier *)getHashAlgorithm {
    if (!self.otherHash) {
        return [[[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[OIWObjectIdentifier idSHA1]] autorelease];
    }
    return [self.otherHash getHashAlgorithm];
}

- (NSMutableData *)getHashValue {
    if (!self.otherHash) {
        return [self.sha1Hash getOctets];
    }
    return [[self.otherHash getHashValue] getOctets];
}

- (ASN1Primitive *)toASN1Primitive {
    if (!self.otherHash) {
        return self.sha1Hash;
    }
    return [self.otherHash toASN1Primitive];
}

@end
