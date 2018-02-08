//
//  ASN1Enumerated.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Enumerated.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "ASN1OctetString.h"

@interface ASN1Enumerated ()

@property (nonatomic, readwrite, retain) NSMutableData *bytes;

@end

@implementation ASN1Enumerated
@synthesize bytes = _bytes;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_bytes) {
        [_bytes release];
        _bytes = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableArray *)cache {
    static NSMutableArray *_cache = nil;
    @synchronized(self) {
        if (!_cache) {
            _cache = [[NSMutableArray alloc] initWithSize:12];
        }
    }
    return _cache;
}

+ (ASN1Enumerated *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1Enumerated class]]) {
        return (ASN1Enumerated *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (ASN1Enumerated *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1Enumerated *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1Enumerated class]]) {
        return [ASN1Enumerated getInstance:localASN1Primitive];
    }
    return [self fromOctetString:[((ASN1OctetString *)localASN1Primitive) getOctets]];
}

+ (ASN1Enumerated *)fromOctetString:(NSMutableData *)paramArrayOfByte {
    if ((int)paramArrayOfByte.length > 1) {
        NSMutableData *mutData = [Arrays cloneWithByteArray:paramArrayOfByte];
        ASN1Enumerated *enumerated = [[[ASN1Enumerated alloc] initParamArrayOfByte:mutData] autorelease];
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
#endif
        return enumerated;
    }
    if ((int)paramArrayOfByte.length == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"ENUMERATED has zero length" userInfo:nil];
    }
    int i = (((Byte *)[paramArrayOfByte bytes])[0] & 0xFF);
    if (i >= [ASN1Enumerated cache].count) {
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramArrayOfByte];
        ASN1Enumerated *enumerator = [[[ASN1Enumerated alloc] initParamArrayOfByte:tmpData] autorelease];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return enumerator;
    }
    ASN1Enumerated *localASN1Enumerated = [ASN1Enumerated cache][i];
    if (!localASN1Enumerated) {
        NSMutableData *tmpData = [Arrays cloneWithByteArray:paramArrayOfByte];
        [ASN1Enumerated cache][i] = [[[ASN1Enumerated alloc] initParamArrayOfByte:tmpData] autorelease];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        localASN1Enumerated = [ASN1Enumerated cache][i];
    }
    return localASN1Enumerated;
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        self.bytes = [[BigInteger valueOf:paramInt] toByteArray];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        self.bytes = [paramBigInteger toByteArray];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.bytes = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BigInteger *)getValue {
    return [[[BigInteger alloc] initWithData:self.bytes] autorelease];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.bytes.length] + (int)self.bytes.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:10 paramArrayOfByte:self.bytes];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1Enumerated class]]) {
        return NO;
    }
    ASN1Enumerated *localASN1Enumerated = (ASN1Enumerated *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.bytes withB:localASN1Enumerated.bytes];
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.bytes];
}

@end
