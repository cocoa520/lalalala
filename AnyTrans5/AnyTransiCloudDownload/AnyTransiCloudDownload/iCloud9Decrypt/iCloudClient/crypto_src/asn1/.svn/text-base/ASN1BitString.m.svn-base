//
//  ASN1BitString.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1BitString.h"
#import "Arrays.h"
#import "ASN1OutputStream.h"
#import "DERBitString.h"
#import "DLBitString.h"

@interface ASN1BitString ()



@end

@implementation ASN1BitString
@synthesize data = _data;
@synthesize padBits = _padBits;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setData:nil];
    [super dealloc];
#endif
}

+ (NSArray *)table {
    static NSArray *_table = nil;
    @synchronized(self) {
        if (!_table) {
            _table = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F"];
        }
    }
    return _table;
}

+ (int)getPadBits:(int)paramInt {
    int i = 0;
    int j = 0;
    for (int j = 3; j >= 0; j--) {
        if (j != 0) {
            if (paramInt >> j * 8 != 0) {
                i = paramInt >> j * 8 & 0xFF;
                break;
            }
        }else if (paramInt != 0) {
            i = paramInt & 0xFF;
            break;
        }
    }
    if (i == 0) {
        return 0;
    }
    for (j = 1; (i <<= 1 & 0xFF) != 0; j++) {
        
    }
    return 8 - j;
}

+ (NSMutableData *)getBytes:(int)paramInt {
    if (paramInt == 0) {
        return [[[NSMutableData alloc] initWithSize:0] autorelease];
    }
    int i = 4;
    for (int j = 3; (j >= 1) && ((paramInt & 255 << j * 8) == 0); j--) {
        i--;
    }
    NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:i] autorelease];
    for (int k = 0; k < i; k++) {
        ((Byte *)[arrayOfByte bytes])[k] = (Byte)(paramInt >> k * 8 & 0xFF);
    }
    return arrayOfByte;
}

+ (ASN1BitString *)fromInputStream:(int)paramInt paramInputStream:(Stream *)paramInputStream {
    if (paramInt < 1) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"truncated BIT STRING detected" userInfo:nil];
    }
    int i = [paramInputStream read];
    NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:paramInt - 1];
    if (arrayOfByte.length) {
        if ([Stream readFully:paramInputStream withBuf:arrayOfByte] != [arrayOfByte length]) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"EOF encountered in middle of BIT STRING" userInfo:nil];
        }
        if ((i > 0) && (i < 8) && (((Byte *)[arrayOfByte bytes])[arrayOfByte.length - 1] != (Byte)(((Byte *)[arrayOfByte bytes])[arrayOfByte.length - 1] & 255 << i))) {
            ASN1BitString *bitStr =  [[[DLBitString alloc] initParamArrayOfByte:arrayOfByte paramInt:i] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
            return bitStr;
        }
    }
    ASN1BitString *bitStr = [[[DERBitString alloc] initParamArrayOfByte:arrayOfByte paramInt:i] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    return bitStr;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt
{
    if (self = [super init]) {
        if (!paramArrayOfByte) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"data cannot be null" userInfo:nil];
        }
        if ((paramArrayOfByte.length == 0) && (paramInt != 0)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"zero length data with non-zero pad bits" userInfo:nil];
        }
        if ((paramInt > 7) || (paramInt < 0)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"pad bits cannot be greater than 7 or less than 0" userInfo:nil];
        }
        NSMutableData *mutData = [Arrays cloneWithByteArray:paramArrayOfByte];
        self.data = mutData;
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
#endif
        self.padBits = paramInt;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] initWithString:@"#"] autorelease];
    MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
    ASN1OutputStream *localASN1OutputStream = [[ASN1OutputStream alloc] initASN1OutputStream:localMemoryStream];
    @try {
        [localASN1OutputStream writeObject:self];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Internal error encoding BitString: %@%@", exception.description, exception.description] userInfo:nil];
    }
    NSMutableData *data = [localMemoryStream availableData];
    NSMutableData *arrayOfByte = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
    for (int i = 0; i != [arrayOfByte length]; i++) {
        [localStringBuffer appendFormat:@"%@", [ASN1BitString table][((uint)(((Byte *)[arrayOfByte bytes])[i]) >> 4 & 0xF)]];
        [localStringBuffer appendFormat:@"%@", [ASN1BitString table][(((Byte *)[arrayOfByte bytes])[i] & 0xF)]];
    }
#if !__has_feature(objc_arc)
    if (localASN1OutputStream) [localASN1OutputStream release]; localASN1OutputStream = nil;
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (int)intValue {
    int i = 0;
    NSMutableData *arrayOfByte = self.data;
    if ((self.padBits > 0) && (self.data.length <= 4)) {
        arrayOfByte = [ASN1BitString derForm:self.data paramInt:self.padBits];
    }
    for (int j = 0; (j != arrayOfByte.length) && (j != 4); j++) {
        i |= (((Byte *)[arrayOfByte bytes])[j] & 0xFF) << 8 * j;
    }
    return i;
}

- (NSMutableData *)getOctets {
    if (self.padBits) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"attempt to get non-octet aligned data from BIT STRING" userInfo:nil];
    }
    return [[Arrays cloneWithByteArray:self.data] autorelease];
}

+ (NSMutableData *)derForm:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt {
    NSMutableData *arrayOfByte = [Arrays cloneWithByteArray:paramArrayOfByte];
    if (paramInt > 0) {
        int tmp14_13 = (int)paramArrayOfByte.length - 1;
        NSMutableData *tmp14_9 = arrayOfByte;
        ((Byte *)[tmp14_9 bytes])[tmp14_13] = ((Byte)(((Byte *)[tmp14_9 bytes])[tmp14_13] & 255 << paramInt));
    }
    return (arrayOfByte ? [arrayOfByte autorelease] : nil);
}

- (NSMutableData *)getBytes {
    return [ASN1BitString derForm:_data paramInt:_padBits];
}

- (int)getPadBits {
    return self.padBits;
}

- (NSString *)toString {
    return [self getString];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1BitString class]]) {
        return NO;
    }
    ASN1BitString *localASN1BitString = (ASN1BitString *)paramASN1Primitive;
    return (self.padBits == [localASN1BitString padBits]) && ([Arrays areEqualWithByteArray:[self getBytes] withB:[localASN1BitString getBytes]]);
}

- (ASN1Primitive *)getLoadedObject {
    return [self toASN1Primitive];
}

- (ASN1Primitive *)toDERObject {
    return [[[DERBitString alloc] initParamArrayOfByte:self.data paramInt:self.padBits] autorelease];
}

- (ASN1Primitive *)toDLObject {
    return [[[DLBitString alloc] initParamArrayOfByte:self.data paramInt:self.padBits] autorelease];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    
}

- (NSUInteger)hash {
    return self.padBits ^ [Arrays getHashCodeWithByteArray:self.getBytes];
}

@end
