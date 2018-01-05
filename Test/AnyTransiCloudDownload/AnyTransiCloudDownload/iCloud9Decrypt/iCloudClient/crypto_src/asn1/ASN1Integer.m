//
//  ASN1Integer.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Integer.h"
#import "Arrays.h"
#import "BigInteger.h"
#import "ASN1OctetString.h"
#import "StreamUtil.h"

@implementation ASN1Integer
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

+ (ASN1Integer *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1Integer class]]) {
        return (ASN1Integer *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (ASN1Integer *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1Integer *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1Integer class]]) {
        return [ASN1Integer getInstance:localASN1Primitive];
    }
    return [[[ASN1Integer alloc] initAOB:[[ASN1OctetString getInstance:[paramASN1TaggedObject getObject]] getOctets]] autorelease];
}

- (instancetype)init
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initLong:(long)paramLong {
    if (self = [super init]) {
        self.bytes = [BigInteger valueOf:paramLong].toByteArray;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initBI:(BigInteger *)paramBigInteger {
    if (self = [super init]) {
        self.bytes = paramBigInteger.toByteArray;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initAOB:(NSMutableData *)paramArrayOfByte {
    if (self = [super init]) {
        [self initParamArrayOfByte:paramArrayOfByte paramBoolean:YES];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)bytes paramBoolean:(Boolean)paramBoolean
{
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays cloneWithByteArray:bytes];
        self.bytes = (paramBoolean ? tmpData : bytes);
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        
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

- (BigInteger *)getPositiveValue {
    return [[[BigInteger alloc] initWithSign:1 withBytes:self.bytes] autorelease];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.bytes.length] + (int)self.bytes.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:2 paramArrayOfByte:self.bytes];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1Integer class]]) {
        return NO;
    }
    ASN1Integer *localASN1Integer = (ASN1Integer *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.bytes withB:localASN1Integer.bytes];
}

- (NSString *)toString {
    return self.getValue.toString;
}

- (NSUInteger)hash {
    int value = 0;
    for (int i = 0; i != self.bytes.length; i++) {
        value ^= (((Byte *)[self.bytes bytes])[i] & 0xff) << (i % 4);
    }
    return value;
}

@end
