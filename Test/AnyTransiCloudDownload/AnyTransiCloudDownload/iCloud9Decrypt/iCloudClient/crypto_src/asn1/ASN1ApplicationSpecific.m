//
//  ASN1ApplicationSpecific.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1ApplicationSpecific.h"
#import "StreamUtil.h"
#import "Arrays.h"
#import "ASN1InputStream.h"

@implementation ASN1ApplicationSpecific
@synthesize isConstructed = _isConstructed;
@synthesize tag = _tag;
@synthesize octets = _octets;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_octets) {
        [_octets release];
        _octets = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ApplicationSpecific *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1ApplicationSpecific class]]) {
        return (ASN1ApplicationSpecific *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [ASN1ApplicationSpecific getInstance:[ASN1Primitive fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Failed to construct object from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.isConstructed = paramBoolean;
        self.tag = paramInt;
        NSMutableData *tmpData = [Arrays copyOfWithData:paramArrayOfByte withNewLength:(int)[paramArrayOfByte length]];
        self.octets = tmpData;
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

+ (int)getLengthOfHeader:(NSMutableData *)paramArrayOfByte {
    int i = ((Byte *)[paramArrayOfByte bytes])[1] & 0xFF;
    if (i == 128) {
        return 2;
    }
    if (i > 127) {
        int j = i & 0x7F;
        if (j > 4) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"DER length more than 4 bytes: %d", j] userInfo:nil];
        }
        return j + 2;
    }
    return 2;
}

- (BOOL)isConstructed {
    return _isConstructed;
}

- (NSMutableData *)getContents {
    return [[Arrays copyOfWithData:self.octets withNewLength:(int)[self.octets length]] autorelease];
}

- (int)getApplicationTag {
    return self.tag;
}

- (ASN1Primitive *)getObject {
    ASN1Primitive *primitive = nil;
    @autoreleasepool {
        primitive = [[ASN1Primitive fromByteArray:[self getContents]] retain];
    }
    return [primitive autorelease];
}

- (ASN1Primitive *)getObject:(int)paramInt {
    if (paramInt > 32) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"unsupported tag number" userInfo:nil];
    }
    NSMutableData *arrayOfByte1 = [self getEncoded];
    NSMutableData *arrayOfByte2 = [self replaceTagNumber:paramInt paramArrayOfByte:arrayOfByte1];
    if ((((Byte *)[arrayOfByte1 bytes])[0] & 0x20) != 0) {
        int tmp39_38 = 0;
        NSMutableData *tmp39_37 = arrayOfByte2;
        ((Byte *)[tmp39_37 bytes])[tmp39_38] = (Byte)(((Byte *)[tmp39_37 bytes])[tmp39_38] | 0x20);
    }
    return [[[[ASN1InputStream alloc] initParamArrayOfByte:arrayOfByte2] readObject] autorelease];
}

- (int)encodedLength {
    return [StreamUtil calculateBodyLength:self.tag] + [StreamUtil calculateBodyLength:(int)self.octets.length] + (int)self.octets.length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    int i = 64;
    if (self.isConstructed) {
        i = i | 0x20;
    }
    [paramASN1OutputStream writeEncoded:i paramInt2:self.tag paramArrayOfByte:self.octets];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1ApplicationSpecific class]]) {
        return NO;
    }
    ASN1ApplicationSpecific *localASN1ApplicationSpecific = (ASN1ApplicationSpecific *)paramASN1Primitive;
    return (self.isConstructed == localASN1ApplicationSpecific.isConstructed) && (self.tag == localASN1ApplicationSpecific.tag) && ([Arrays areEqualWithByteArray:self.octets withB:localASN1ApplicationSpecific.octets]);
}

- (NSMutableData *)replaceTagNumber:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    int i = ((Byte *)[paramArrayOfByte bytes])[0] & 0x1F;
    int j = 1;
    if (i == 31) {
        i = 0;
        int k = ((Byte *)[paramArrayOfByte bytes])[j++] & 0xFF;
        if ((k & 0x7F) == 0) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"corrupted stream - invalid high tag number found" userInfo:nil];
        }
        while ((k > 0) && ((k & 0x80) != 0)) {
            i = i | (k & 0x7F);
            i <<= 7;
            k = ((Byte *)[paramArrayOfByte bytes])[j++] & 0xFF;
        }
    }
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:(int)paramArrayOfByte.length - j + 1] autorelease];
    [arrayOfByte copyFromIndex:1 withSource:paramArrayOfByte withSourceIndex:j withLength:((int)[arrayOfByte length] - 1)];
    ((Byte*)[arrayOfByte bytes])[0] = (Byte)paramInt;
    return arrayOfByte;
}

- (NSUInteger)hash {
    return (self.isConstructed ? 1 : 0) ^ self.tag ^ [Arrays getHashCodeWithByteArray:self.octets];
}

@end
