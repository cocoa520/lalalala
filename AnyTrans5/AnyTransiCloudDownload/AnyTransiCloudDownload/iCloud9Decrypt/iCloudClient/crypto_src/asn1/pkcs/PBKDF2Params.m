//
//  PBKDF2Params.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PBKDF2Params.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"
#import "Arrays.h"
#import "PKCSObjectIdentifiers.h"
#import "DERNull.h"

@interface PBKDF2Params ()

@property (nonatomic, readwrite, retain) ASN1OctetString *octStr;
@property (nonatomic, readwrite, retain) ASN1Integer *iterationCount;
@property (nonatomic, readwrite, retain) ASN1Integer *keyLength;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *prf;

@end

@implementation PBKDF2Params
@synthesize octStr = _octStr;
@synthesize iterationCount = _iterationCount;
@synthesize keyLength = _keyLength;
@synthesize prf = _prf;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_octStr) {
        [_octStr release];
        _octStr = nil;
    }
    if (_iterationCount) {
        [_iterationCount release];
        _iterationCount = nil;
    }
    if (_keyLength) {
        [_keyLength release];
        _keyLength = nil;
    }
    if (_prf) {
        [_prf release];
        _prf = nil;
    }
    [super dealloc];
#endif
}

+ (AlgorithmIdentifier *)algid_hmacWithSHA1 {
    static AlgorithmIdentifier *_algid_hmacWithSHA1 = nil;
    @synchronized(self) {
        if (!_algid_hmacWithSHA1) {
            _algid_hmacWithSHA1 = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[PKCSObjectIdentifiers id_hmacWithSHA1] paramASN1Encodable:[DERNull INSTANCE]];
        }
    }
    return _algid_hmacWithSHA1;
}

+ (PBKDF2Params *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PBKDF2Params class]]) {
        return (PBKDF2Params *)paramObject;
    }
    if (paramObject) {
        return [[[PBKDF2Params alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.octStr = (ASN1OctetString *)[localEnumeration nextObject];
        self.iterationCount = (ASN1Integer *)[localEnumeration nextObject];
        id localObject = nil;
        if (localObject = [localEnumeration nextObject]) {
            if ([localObject isKindOfClass:[ASN1Integer class]]) {
                self.keyLength = [ASN1Integer getInstance:localObject];
                if (localObject = [localEnumeration nextObject]) {
                }else {
                    localObject = nil;
                }
            }else {
                self.keyLength = nil;
            }
            if (localObject) {
                self.prf = [AlgorithmIdentifier getInstance:localObject];
            }else {
                self.prf = nil;
            }
        }else {
            self.keyLength = nil;
            self.prf = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        [self initParamArrayOfByte:paramArrayOfByte paramInt1:paramInt paramInt2:0];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2
{
    if (self = [super init]) {
        [self initParamArrayOfByte:paramArrayOfByte paramInt1:paramInt1 paramInt2:paramInt2 paramAlgorithmIdentifier:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier
{
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramArrayOfByte];
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:tmpData];
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt1];
        self.octStr = octetString;
        self.iterationCount = integer;
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
    if (octetString) [octetString release]; octetString = nil;
    if (integer) [integer release]; integer = nil;
#endif
        if (paramInt2 > 0) {
            ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt2];
            self.keyLength = integer;
#if !__has_feature(objc_arc)
            if (integer) [integer release]; integer = nil;
#endif
        }else {
            self.keyLength = nil;
        }
        self.prf = paramAlgorithmIdentifier;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier
{
    if (self = [super init]) {
        [self initParamArrayOfByte:paramArrayOfByte paramInt1:paramInt paramInt2:0 paramAlgorithmIdentifier:paramAlgorithmIdentifier];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getSalt {
    return [self.octStr getOctets];
}

- (BigInteger *)getIterationCount {
    return [self.iterationCount getValue];
}

- (BigInteger *)getKeyLength {
    if (self.keyLength) {
        return [self.keyLength getValue];
    }
    return nil;
}

- (BOOL)isDefaultPrf {
    return ((self.prf) || [self.prf isEqual:[PBKDF2Params algid_hmacWithSHA1]]);
}

- (AlgorithmIdentifier *)getPrf {
    if (self.prf) {
        return self.prf;
    }
    return [PBKDF2Params algid_hmacWithSHA1];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.octStr];
    [localASN1EncodableVector add:self.iterationCount];
    if (self.keyLength) {
        [localASN1EncodableVector add:self.keyLength];
    }
    if (self.prf && ![self.prf isEqual:[PBKDF2Params algid_hmacWithSHA1]]) {
        [localASN1EncodableVector add:self.prf];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
