//
//  DERBMPString.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERBMPString.h"
#import "Arrays.h"
#import "StreamUtil.h"
#import "ASN1OctetString.h"

@interface DERBMPString ()

@property (nonatomic, readwrite, retain) NSMutableArray *string;

@end

@implementation DERBMPString
@synthesize string = _string;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_string) {
        [_string release];
        _string = nil;
    }
    [super dealloc];
#endif
}

+ (DERBMPString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DERBMPString class]]) {
        return (DERBMPString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return (DERBMPString *)[self fromByteArray:(NSMutableData *)paramObject];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"encoding error in getInstance: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DERBMPString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[DERBMPString class]]) {
        return [DERBMPString getInstance:localASN1Primitive];
    }
    return [[[DERBMPString alloc] initParamArrayOfByte:[[ASN1OctetString getInstance:localASN1Primitive] getOctets]] autorelease];
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        NSMutableArray *arrayOfChar = [[NSMutableArray alloc] initWithSize:(int)(paramArrayOfByte.length / 2)];
        for (int i = 0; i != arrayOfChar.count; i++) {
            arrayOfChar[i] = @((((Byte *)[paramArrayOfByte bytes])[(2 * i)] << 8) | (((Byte *)[paramArrayOfByte bytes])[(2 * i + 1)] & 0xFF));
        }
        self.string = arrayOfChar;
#if !__has_feature(objc_arc)
    if (arrayOfChar) [arrayOfChar release]; arrayOfChar = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfChar:(NSMutableArray *)paramArrayOfChar
{
    if (self = [super init]) {
        self.string = paramArrayOfChar;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
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

- (NSString *)getString {
    return [[[NSString alloc] init] autorelease];
}

- (NSString *)toString {
    return [self getString];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERBMPString class]]) {
        return NO;
    }
    DERBMPString *localDERBMPString = (DERBMPString *)paramASN1Primitive;
    return [Arrays areEqualWithIntArray:self.string withB:localDERBMPString.string];
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)self.string.count * 2] + (int)self.string.count * 2;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream write:30];
    [paramASN1OutputStream writeLength:(int)[self.string count] * 2];
    for (int i = 0; i != self.string.count; i++) {
        int j = (int)self.string[i];
        [paramASN1OutputStream write:(j >> 8)];
        [paramASN1OutputStream write:j];
    }
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithIntArray:self.string];
}

@end
