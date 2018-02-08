//
//  CategoryExtend.m
//
//  Created by Pallas on 3/19/15.
//  Copyright (c) 2015 Pallas All rights reserved.
//

#import "CategoryExtend.h"
#import <sys/stat.h>
#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>
#import <malloc/malloc.h>

@implementation Base64Codec

+ (NSData*)dataFromBase64String:(NSString *)encoding {
    NSData *data = nil;
    unsigned char *decodedBytes = NULL;
    @try {
#define __ 255
        static char decodingTable[256] = {
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x00 - 0x0F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x10 - 0x1F
            __,__,__,__, __,__,__,__, __,__,__,62, __,__,__,63,  // 0x20 - 0x2F
            52,53,54,55, 56,57,58,59, 60,61,__,__, __, 0,__,__,  // 0x30 - 0x3F
            __, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x40 - 0x4F
            15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x50 - 0x5F
            __,26,27,28, 29,30,31,32, 33,34,35,36, 37,38,39,40,  // 0x60 - 0x6F
            41,42,43,44, 45,46,47,48, 49,50,51,__, __,__,__,__,  // 0x70 - 0x7F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x80 - 0x8F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x90 - 0x9F
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xA0 - 0xAF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xB0 - 0xBF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xC0 - 0xCF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xD0 - 0xDF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xE0 - 0xEF
            __,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xF0 - 0xFF
        };
        encoding = [encoding stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSData *encodedData = [encoding dataUsingEncoding:NSASCIIStringEncoding];
        unsigned char *encodedBytes = (unsigned char *)[encodedData bytes];
        
        NSUInteger encodedLength = [encodedData length];
        NSUInteger encodedBlocks = (encodedLength+3) >> 2;
        NSUInteger expectedDataLength = encodedBlocks * 3;
        
        unsigned char decodingBlock[4];
        
        decodedBytes = malloc(expectedDataLength);
        if( decodedBytes != NULL ) {
            
            NSUInteger i = 0;
            NSUInteger j = 0;
            NSUInteger k = 0;
            unsigned char c;
            while( i < encodedLength ) {
                c = decodingTable[encodedBytes[i]];
                i++;
                if( c != __ ) {
                    decodingBlock[j] = c;
                    j++;
                    if( j == 4 ) {
                        decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                        decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                        decodedBytes[k+2] = (decodingBlock[2] << 6) | (decodingBlock[3]);
                        j = 0;
                        k += 3;
                    }
                }
            }
            
            // Process left over bytes, if any
            if( j == 3 ) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                decodedBytes[k+1] = (decodingBlock[1] << 4) | (decodingBlock[2] >> 2);
                k += 2;
            } else if( j == 2 ) {
                decodedBytes[k] = (decodingBlock[0] << 2) | (decodingBlock[1] >> 4);
                k += 1;
            }
            data = [[[NSData alloc] initWithBytes:decodedBytes length:k] autorelease];
        }
    }
    @catch (NSException *exception) {
        data = nil;
        NSLog(@"WARNING: error occured while decoding base 32 string: %@", exception);
    }
    @finally {
        if( decodedBytes != NULL ) {
            free( decodedBytes );
        }
    }
    return data;
}

+ (NSString*)base64StringFromData:(NSData *)data {
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        static char encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        static NSUInteger paddingTable[] = {0,2,1};
        //                 Table 1: The Base 64 Alphabet
        //
        //    Value Encoding  Value Encoding  Value Encoding  Value Encoding
        //        0 A            17 R            34 i            51 z
        //        1 B            18 S            35 j            52 0
        //        2 C            19 T            36 k            53 1
        //        3 D            20 U            37 l            54 2
        //        4 E            21 V            38 m            55 3
        //        5 F            22 W            39 n            56 4
        //        6 G            23 X            40 o            57 5
        //        7 H            24 Y            41 p            58 6
        //        8 I            25 Z            42 q            59 7
        //        9 J            26 a            43 r            60 8
        //       10 K            27 b            44 s            61 9
        //       11 L            28 c            45 t            62 +
        //       12 M            29 d            46 u            63 /
        //       13 N            30 e            47 v
        //       14 O            31 f            48 w         (pad) =
        //       15 P            32 g            49 x
        //       16 Q            33 h            50 y
        
        NSUInteger dataLength = [data length];
        NSUInteger encodedBlocks = (dataLength * 8) / 24;
        NSUInteger padding = paddingTable[dataLength % 3];
        if( padding > 0 ) encodedBlocks++;
        NSUInteger encodedLength = encodedBlocks * 4;
        
        encodingBytes = malloc(encodedLength);
        if( encodingBytes != NULL ) {
            NSUInteger rawBytesToProcess = dataLength;
            NSUInteger rawBaseIndex = 0;
            NSUInteger encodingBaseIndex = 0;
            unsigned char *rawBytes = (unsigned char *)[data bytes];
            unsigned char rawByte1, rawByte2, rawByte3;
            while( rawBytesToProcess >= 3 ) {
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];
                
                rawBaseIndex += 3;
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
            }
            rawByte2 = 0;
            switch (dataLength-rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex+1];
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                    encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) ];
                    // we can skip rawByte3 since we have a partial block it would always be 0
                    break;
            }
            // compute location from where to begin inserting padding, it may overwrite some bytes from the partial block encoding
            // if their value was 0 (cases 1-2).
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding] autorelease];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
        NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
    }
    @finally {
        if( encodingBytes != NULL ) {
            free( encodingBytes );
        }
    }
    return encoding;
}

@end

@implementation NSObject (ExtendTool)

-(NSData*)jsonString {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

+ (void)checkNotNull:(id)object withName:(NSString*)name {
    if (object == nil) {
        @throw [NSException exceptionWithName:@"NullPointer" reason:name userInfo:nil];
    }
}

@end

@implementation BitConverter

+ (BOOL)isLitte_Endian {
    union w{
        int a;
        char b;
    } c;
    c.a = 1;
    return (c.b == 1);
}

+ (Byte*)reverseBytes:(Byte*)inArray offset:(int)offset count:(int)count {
    Byte *retBytes = NULL;
    
    if (count != 0) {
        retBytes = malloc(count);
        memset(retBytes, 0, malloc_size(retBytes));
    } else {
        return NULL;
    }
    int j = count;
    Byte tmpBytes[count];
    for (int i = offset; i < offset + count; i++) {
        Byte c = inArray[i];
        tmpBytes[--j] = c;
    }
    memcpy(retBytes, tmpBytes, count);
    
    return retBytes;
}

@end

@implementation BigEndianBitConverter

+ (int8_t)bigEndianToInt8:(Byte *)inArray byteLength:(int)byteLength {
    int8_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(sint_8.c, reverseBytes, sizeof(sint_8.c));
        ret = sint_8.int8;
        free(reverseBytes);
    } else {
        memcpy(sint_8.c, inArray, sizeof(sint_8.c));
        ret = sint_8.int8;
    }
    return ret;
}

+ (uint8_t)bigEndianToUInt8:(Byte *)inArray byteLength:(int)byteLength {
    uint8_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(uint_8.c, reverseBytes, sizeof(uint_8.c));
        ret = uint_8.uint8;
        free(reverseBytes);
    } else {
        memcpy(uint_8.c, inArray, sizeof(uint_8.c));
        ret = uint_8.uint8;
    }
    return ret;
}

+ (int16_t)bigEndianToInt16:(Byte *)inArray byteLength:(int)byteLength {
    int16_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(short_16.c, reverseBytes, sizeof(short_16.c));
        ret = short_16.short16;
        free(reverseBytes);
    } else {
        memcpy(short_16.c, inArray, sizeof(short_16.c));
        ret = short_16.short16;
    }
    return ret;
}

+ (uint16_t)bigEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength {
    uint16_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(ushort_16.c, reverseBytes, sizeof(ushort_16.c));
        ret = ushort_16.ushort16;
        free(reverseBytes);
    } else {
        memcpy(ushort_16.c, inArray, sizeof(ushort_16.c));
        ret = ushort_16.ushort16;
    }
    return ret;
}

+ (int32_t)bigEndianToInt32:(Byte *)inArray byteLength:(int)byteLength {
    int32_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(sint_32.c, reverseBytes, sizeof(sint_32.c));
        ret = sint_32.int32;
        free(reverseBytes);
    } else {
        memcpy(sint_32.c, inArray, sizeof(sint_32.c));
        ret = sint_32.int32;
    }
    return ret;
}

+ (uint32_t)bigEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength {
    uint32_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(uint_32.c, reverseBytes, sizeof(uint_32.c));
        ret = uint_32.uint32;
        free(reverseBytes);
    } else {
        memcpy(uint_32.c, inArray, sizeof(uint_32.c));
        ret = uint_32.uint32;
    }
    return ret;
}

+ (int64_t)bigEndianToInt64:(Byte *)inArray byteLength:(int)byteLength {
    int64_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(sint_64.c, reverseBytes, sizeof(sint_64.c));
        ret = sint_64.int64;
        free(reverseBytes);
    } else {
        memcpy(sint_64.c, inArray, sizeof(sint_64.c));
        ret = sint_64.int64;
    }
    return ret;
}

+ (uint64_t)bigEndianToUInt64:(Byte *)inArray byteLength:(int)byteLength {
    uint64_t ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(uint_64.c, reverseBytes, sizeof(uint_64.c));
        ret = uint_64.uint64;
        free(reverseBytes);
    } else {
        memcpy(uint_64.c, inArray, sizeof(uint_64.c));
        ret = uint_64.uint64;
    }
    return ret;
}

+ (long)bigEndianToLong64:(Byte *)inArray byteLength:(int)byteLength {
    unsigned long ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(slong_64.c, reverseBytes, sizeof(slong_64.c));
        ret = slong_64.long64;
        free(reverseBytes);
    } else {
        memcpy(slong_64.c, inArray, sizeof(slong_64.c));
        ret = slong_64.long64;
    }
    return ret;
}

+ (unsigned long)bigEndianToULong64:(Byte *)inArray byteLength:(int)byteLength {
    unsigned long ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(ulong_64.c, reverseBytes, sizeof(ulong_64.c));
        ret = ulong_64.ulong64;
        free(reverseBytes);
    } else {
        memcpy(ulong_64.c, inArray, sizeof(ulong_64.c));
        ret = ulong_64.ulong64;
    }
    return ret;
}

+ (double)bigEndianToDouble64:(Byte *)inArray byteLength:(int)byteLength {
    double ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(double_64.c, reverseBytes, sizeof(double_64.c));
        ret = double_64.double64;
        free(reverseBytes);
    } else {
        memcpy(double_64.c, inArray, sizeof(double_64.c));
        ret = double_64.double64;
    }
    return ret;
}

+ (float)bigEndianToFloat32:(Byte *)inArray byteLength:(int)byteLength {
    float ret = 0;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(float_32.c, reverseBytes, sizeof(float_32.c));
        ret = float_32.float32;
        free(reverseBytes);
    } else {
        memcpy(float_32.c, inArray, sizeof(float_32.c));
        ret = float_32.float32;
    }
    return ret;
}

+ (NSMutableData*)bigEndianBytes:(Byte *)inArray byteLength:(int)byteLength {
    NSMutableData *retData = nil;
    if ([self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        retData = [NSMutableData dataWithBytes:reverseBytes length:byteLength];
        free(reverseBytes);
    } else {
        retData = [NSMutableData dataWithBytes:inArray length:byteLength];
    }
    return retData;
}

@end

@implementation LittleEndianBitConverter

+ (int8_t)littleEndianToInt8:(Byte *)inArray byteLength:(int)byteLength {
    int8_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(sint_8.c, reverseBytes, sizeof(sint_8.c));
        ret = sint_8.int8;
        free(reverseBytes);
    } else {
        memcpy(sint_8.c, inArray, sizeof(sint_8.c));
        ret = sint_8.int8;
    }
    return ret;
}

+ (uint8_t)littleEndianToUInt8:(Byte *)inArray byteLength:(int)byteLength {
    int8_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(uint_8.c, reverseBytes, sizeof(uint_8.c));
        ret = uint_8.uint8;
        free(reverseBytes);
    } else {
        memcpy(uint_8.c, inArray, sizeof(uint_8.c));
        ret = uint_8.uint8;
    }
    return ret;
}

+ (int16_t)littleEndianToInt16:(Byte *)inArray byteLength:(int)byteLength {
    int16_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(short_16.c, reverseBytes, sizeof(short_16.c));
        ret = short_16.short16;
        free(reverseBytes);
    } else {
        memcpy(short_16.c, inArray, sizeof(short_16.c));
        ret = short_16.short16;
    }
    return ret;
}

+ (uint16_t)littleEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength {
    uint16_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(ushort_16.c, reverseBytes, sizeof(ushort_16.c));
        ret = ushort_16.ushort16;
        free(reverseBytes);
    } else {
        memcpy(ushort_16.c, inArray, sizeof(ushort_16.c));
        ret = ushort_16.ushort16;
    }
    return ret;
}

+ (int32_t)littleEndianToInt32:(Byte *)inArray byteLength:(int)byteLength {
    int32_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(sint_32.c, reverseBytes, sizeof(sint_32.c));
        ret = sint_32.int32;
        free(reverseBytes);
    } else {
        memcpy(sint_32.c, inArray, sizeof(sint_32.c));
        ret = sint_32.int32;
    }
    return ret;
}

+ (uint32_t)littleEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength {
    uint32_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(uint_32.c, reverseBytes, sizeof(uint_32.c));
        ret = uint_32.uint32;
        free(reverseBytes);
    } else {
        memcpy(uint_32.c, inArray, sizeof(uint_32.c));
        ret = uint_32.uint32;
    }
    return ret;
}

+ (int64_t)littleEndianToInt64:(Byte *)inArray byteLength:(int)byteLength {
    int64_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(sint_64.c, reverseBytes, sizeof(sint_64.c));
        ret = sint_64.int64;
        free(reverseBytes);
    } else {
        memcpy(sint_64.c, inArray, sizeof(sint_64.c));
        ret = sint_64.int64;
    }
    return ret;
}

+ (uint64_t)littleEndianToUInt64:(Byte *)inArray byteLength:(int)byteLength {
    uint64_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(uint_64.c, reverseBytes, sizeof(uint_64.c));
        ret = uint_64.uint64;
        free(reverseBytes);
    } else {
        memcpy(uint_64.c, inArray, sizeof(uint_64.c));
        ret = uint_64.uint64;
    }
    return ret;
}

+ (long)littleEndianToLong64:(Byte *)inArray byteLength:(int)byteLength {
    unsigned long ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(slong_64.c, reverseBytes, sizeof(slong_64.c));
        ret = slong_64.long64;
        free(reverseBytes);
    } else {
        memcpy(slong_64.c, inArray, sizeof(slong_64.c));
        ret = slong_64.long64;
    }
    return ret;
}

+ (unsigned long)littleEndianToULong64:(Byte *)inArray byteLength:(int)byteLength {
    unsigned long ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(ulong_64.c, reverseBytes, sizeof(ulong_64.c));
        ret = ulong_64.ulong64;
        free(reverseBytes);
    } else {
        memcpy(ulong_64.c, inArray, sizeof(ulong_64.c));
        ret = ulong_64.ulong64;
    }
    return ret;
}

+ (double)littleEndianToDouble64:(Byte *)inArray byteLength:(int)byteLength {
    double ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(double_64.c, reverseBytes, sizeof(double_64.c));
        ret = double_64.double64;
        free(reverseBytes);
    } else {
        memcpy(double_64.c, inArray, sizeof(double_64.c));
        ret = double_64.double64;
    }
    return ret;
}

+ (float)littleEndianToFloat32:(Byte *)inArray byteLength:(int)byteLength {
    float ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy(float_32.c, reverseBytes, sizeof(float_32.c));
        ret = float_32.float32;
        free(reverseBytes);
    } else {
        memcpy(float_32.c, inArray, sizeof(float_32.c));
        ret = float_32.float32;
    }
    return ret;
}

+ (NSMutableData*)littleEndianBytes:(Byte *)inArray byteLength:(int)byteLength {
    NSMutableData *retData = nil;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        retData = [NSMutableData dataWithBytes:reverseBytes length:byteLength];
        free(reverseBytes);
    } else {
        retData = [NSMutableData dataWithBytes:inArray length:byteLength];
    }
    return retData;
}

@end

@implementation NSNumber (ExtendTool)

- (NSString *)binaryString{
    NSMutableString *string = [NSMutableString string];
    NSInteger value = [self integerValue];
    while (value) {
        [string insertString:(value & 1)? @"1": @"0" atIndex:0];
        value /= 2;
    }
    return string;
}

@end

@implementation NSString (ExtendTool)

+ (NSString*)getAppSupportPath {
    NSString *appTempPath;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *identifier = [bundle bundleIdentifier];
    NSString *appName = [[bundle infoDictionary] objectForKey:@"CFBundleName"];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *homeDocumentsPath = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    appTempPath =[[homeDocumentsPath stringByAppendingPathComponent:identifier] stringByAppendingPathComponent:appName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:appTempPath]) {
        [fileManager createDirectoryAtPath:appTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appTempPath;
}

- (NSString*)getParentDirectory {
    NSString *parentDirectory = @"";
    if ([NSString isNilOrEmpty:self]) {
        return parentDirectory;
    }
    NSArray *components = [self pathComponents];
    int segLen = (int)[components count];
    if (segLen == 1) {
        segLen = 1;
    } else {
        if ([self hasSuffix:@"/"]) {
            segLen = segLen - 2;
        } else {
            segLen = segLen - 1;
        }
    }
    for (int i = 0; i < segLen; i++) {
        parentDirectory = [parentDirectory stringByAppendingPathComponent:[components objectAtIndex: i]];
    }
    return parentDirectory;
}

- (NSMutableData*)hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSString*)dataToHex:(NSData*)data {
    return [NSString bytesToHex:(uint8_t*)(data.bytes) length:(int)(data.length)];
}

+ (NSString*)bytesToHex:(uint8_t*)bytes length:(int)length {
    NSMutableString *hexString = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i < length; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", bytes[i]&0x00FF]];
    }
    return hexString;
}

+ (NSString*)intToHex:(int)intValue {
    NSString *nLetterValue;
    NSString *str = @"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=intValue%16;
        intValue=intValue/16;
        switch (ttmpig) {
            case 10:
                nLetterValue = @"A";break;
            case 11:
                nLetterValue = @"B";break;
            case 12:
                nLetterValue = @"C";break;
            case 13:
                nLetterValue = @"D";break;
            case 14:
                nLetterValue = @"E";break;
            case 15:
                nLetterValue = @"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (intValue == 0) {
            break;
        }
    }
    return str;
}

+ (NSString*)decimalTOBinary:(int)intValue backLength:(int)length {
    NSString *a = @"";
    while (intValue) {
        a = [[NSString stringWithFormat:@"%d", intValue%2] stringByAppendingString:a];
        if (intValue / 2 < 1) {
            break;
        }
        intValue = intValue / 2 ;
    }
    
    if (a.length <= length) {
        NSMutableString *b = [[NSMutableString alloc] init];;
        for (int i = 0; i < length - a.length; i++) {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
#if !__has_feature(objc_arc)
        if (b != nil) [b release]; b = nil;
#endif
    }
    return a;
}

+ (NSString*)getBinaryByhex:(NSString*)hex {
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSMutableString *binaryString=[[[NSMutableString alloc] init] autorelease];
    
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        [binaryString appendFormat:@"%@", (NSString*)[hexDic objectForKey:key]];
    }
    
#if !__has_feature(objc_arc)
    if (hexDic != nil) [hexDic release]; hexDic = nil;
#endif
    return binaryString;
}

+ (BOOL)isNilOrEmpty:(NSString*)string {
    BOOL ret = NO;
    if (string == nil || [string isEqualToString:@""]) {
        ret = YES;
    }
    return ret;
}

+ (NSString*)generateGUID {
    CFUUIDRef guidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, guidRef);
    NSString *guid = [NSString stringWithFormat:@"%@", (NSString*)strRef];
    if (guidRef) {
        CFRelease(guidRef);
        guidRef = NULL;
    }
    if (strRef) {
        CFRelease(strRef);
        strRef = NULL;
    }
    return guid;
}

- (NSString*)stringOfIndex:(int)index {
    NSAttributedString *attrStr = [[[NSAttributedString alloc] initWithString:self] autorelease];
    NSRange range;
    for(int i = 0; i < self.length; i += range.length){
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        if (i != index) {
            continue;
        }
        return [[attrStr attributedSubstringFromRange:range] string];
    }
    return @"";
}

- (BOOL)isGreaterThan:(NSString*)verStr {
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedDescending);
}

- (BOOL)isGreaterThanOrEqual:(NSString*)verStr {
    return (([self compare:verStr options:NSNumericSearch] == NSOrderedDescending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame));
}

- (BOOL)isLessThan:(NSString*)verStr {
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)isLessThanOrEqual:(NSString*)verStr {
    return (([self compare:verStr options:NSNumericSearch] == NSOrderedAscending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame));
}

- (BOOL)isMajorEqual:(NSString*)verStr {
    return ([self compare:verStr options:NSNumericSearch] == NSOrderedDescending) || ([self compare:verStr options:NSNumericSearch] == NSOrderedSame);
}

- (BOOL)contains:(NSString *)value {
    if ([self rangeOfString:value].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

- (BOOL)startWithString:(NSString *)string options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound && rng.location == 0;
}

- (BOOL)startWithString:(NSString *)string {
    return [self startWithString:string options:0];
}

- (NSRange)rangeOfString:(NSString*)subString atOccurrence:(int)occurrence {
	int currentOccurrence = 0;
	NSRange	rangeToSearchWithin = NSMakeRange(0, [self length]);
	while (YES) {
		currentOccurrence++;
		NSRange searchResult = [self rangeOfString:subString options:NSLiteralSearch range:rangeToSearchWithin];
		if (searchResult.location == NSNotFound) {
			return searchResult;
		}
		if (currentOccurrence == occurrence) {
			return searchResult;
		}
		int newLocationToStartAt = (int)(searchResult.location) + (int)(searchResult.length);
		rangeToSearchWithin = NSMakeRange(newLocationToStartAt, self.length - newLocationToStartAt);
	}
}

- (PATHTYPE)typeOfPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    struct stat s;
    if (lstat([fm fileSystemRepresentationWithPath:self], &s) < 0){
		return UNKNOWN;
	}
    if (S_ISBLK(s.st_mode)) {
        return ISBLOCK;
    } else if (S_ISCHR(s.st_mode)) {
        return ISCHAR;
    } else if (S_ISDIR(s.st_mode)) {
        return ISDIR;
    } else if (S_ISFIFO(s.st_mode)) {
        return ISFIFO;
    } else if (S_ISREG(s.st_mode)) {
        return ISREG;
    } else if (S_ISLNK(s.st_mode)) {
        return ISLINK;
    } else if (S_ISSOCK(s.st_mode)) {
        return ISSOCK;
    } else {
        return UNKNOWN;
    }
}

- (NSData*)sha1 {
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA1_DIGEST_LENGTH))) {
        return nil;
    }
    CC_SHA1(data.bytes, (CC_LONG)data.length, buffer);
    
    NSData *output = nil;
    output = [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    free(buffer);
    return output;
}

- (NSString *)md5 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *)sha1Hex {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)MD5FromData:(NSData *)data {
    unsigned char result[16];
    CC_MD5(data.bytes, (unsigned int)data.length, result);
    //    NSData *resultData = [NSData dataWithBytes:result length:16]; 其实这一步不需要的
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)AES256EncryptWithKey:(NSString *)key {
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKey:key];
    
    NSString *encryptedString = [encryptedData base64Encoding];
    
    return encryptedString;
}

- (NSString *)AES256DecryptWithKey:(NSString *)key {
    NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [encryptedData AES256DecryptWithKey:key];
    
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    
    return [plainString autorelease];
}

- (NSData*)toDataByEncoding:(NSStringEncoding)encoding {
    NSData *data = [self dataUsingEncoding:encoding];
    return data;
}

- (NSString*)base64String {
    NSData *utf8Encoding = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [Base64Codec base64StringFromData:utf8Encoding];
}

+ (NSString*)stringFromBase64String:(NSString*)base64String {
    NSData *utf8Encoding = [Base64Codec dataFromBase64String:base64String];
    return [[[NSString alloc] initWithData:utf8Encoding encoding:NSUTF8StringEncoding] autorelease];
}

- (BOOL)isAlias {
    if (![self.class isNilOrEmpty:self]) {
        NSURL* url = [NSURL fileURLWithPath:self];
        CFURLRef cfurl = (__bridge CFURLRef) url;
        CFBooleanRef cfisAlias = kCFBooleanFalse;
        BOOL success = CFURLCopyResourcePropertyForKey(cfurl, kCFURLIsAliasFileKey, &cfisAlias, NULL);
        BOOL isAlias = NO;
        if (success) {
            isAlias = CFBooleanGetValue(cfisAlias);
        }
        return isAlias;
    } else {
        return NO;
    }
}

- (id)jsonValue {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end

static char encodingTable[64] =
{
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
};

@implementation NSData (ExtendTool)

- (BOOL)bytesEqual:(NSData*)data {
    BOOL ret = NO;
    if (self == nil && data == nil) {
        ret = YES;
    } else if (self != nil && data != nil) {
        if (data.length != data.length) {
            ret = NO;
        } else {
            if (strcmp(self.bytes, data.bytes) == 0) {
                ret = YES;
            } else {
                ret = NO;
            }
        }
    } else {
        ret = NO;
    }
    return ret;
}

- (NSData*)sha1 {
    if (!self) {
        return nil;
    }
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA1_DIGEST_LENGTH))) {
        return nil;
    }
    CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
    
    NSData *output = nil;
    output = [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    free(buffer);
    return output;
}

- (NSMutableData *)sha256 {
    if (!self) {
        return nil;
    }
    Byte *buffer;
    if (!(buffer = malloc(CC_SHA256_DIGEST_LENGTH))) {
        return nil;
    }
    
    CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableData *output = nil;
    output = [NSMutableData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
    free(buffer);
    
    return output;
}

+ (NSData*)MD5Digest:(NSData*)input {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input.bytes, (CC_LONG)input.length, result);
    return [[[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH] autorelease];
}

- (NSData*)MD5Digest {
    return [NSData MD5Digest:self];
}

- (NSDictionary*)dataToDictionary {
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary *dict = [NSPropertyListSerialization
                          propertyListFromData:self
                          mutabilityOption:NSPropertyListImmutable
                          format:&format
                          errorDescription:&error];
    if(!dict){
        [error release];
    }
    return dict;
}

- (NSMutableDictionary*)dataToMutableDictionary {
    NSString *error;
    NSPropertyListFormat format;
    NSMutableDictionary *dict = [NSPropertyListSerialization
                                 propertyListFromData:self
                                 mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                 format:&format
                                 errorDescription:&error];
    if(!dict){
        [error release];
    }
    return dict;
}

- (NSArray *)dataToArray {
    NSString *error;
    NSArray *ary = [NSArray arrayWithObject:self];
    if (!ary) {
        [error release];
    }
    return ary;
}

- (NSMutableArray *)dataToMutableArray {
    NSString *error;
    NSMutableArray *ary = [[NSMutableArray arrayWithObject:self] mutableCopy];
    if (!ary) {
        [error release];
    }
    return ary;
}

- (NSString*)dataToHex {
    NSMutableString *hexString = [[[NSMutableString alloc] init] autorelease];
    uint8_t *bytes = (uint8_t*)self.bytes;
    int length = (int)(self.length);
    for (int i = 0; i < length; i++) {
        [hexString appendFormat:@"%02X", (bytes[i]&0x00FF)];
    }
    return hexString;
}

+ (NSData*)dataWithHexString:(NSString*)hexString {
    if (([hexString length] % 2) == 1) {
        return nil;
    }
    NSMutableData *buffer = [[[NSMutableData alloc] init] autorelease];
    for (int byteOffset = 0; byteOffset < [hexString length]; byteOffset += 2) {
        NSRange range = NSMakeRange(byteOffset, 2);
        NSString *byteString = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:byteString];
        unsigned int value;
        [scanner scanHexInt:&value];
        [buffer appendBytes:&value length:1];
    }
    return buffer;
}

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero( keyPtr, sizeof( keyPtr ) ); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted );
    if( cryptStatus == kCCSuccess ) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero( keyPtr, sizeof( keyPtr ) ); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted );
    
    if( cryptStatus == kCCSuccess ) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free( buffer ); //free the buffer
    return nil;
}

- (NSMutableData*)AES128EncryptWithKey:(NSString*)key iv:(NSString*)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    char ivPtr[kCCKeySizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    NSUInteger newSize = 0;
    if(diff > 0) {
        newSize = dataLength + diff;
    }
    char dataPtr[newSize];
    memcpy(dataPtr, [self bytes], [self length]);
    for(int i = 0; i < diff; i++) {
        dataPtr[i + dataLength] = 0x00;
    }
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x00, //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if(cryptStatus == kCCSuccess) {
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    return nil;
}

- (NSMutableData*)AES128DecryptWithKey:(NSString*)key iv:(NSString*)iv {
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x00, //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if(cryptStatus == kCCSuccess) {
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    return nil;
}

- (NSMutableData *)AES256EncryptWithKey:(Byte *)key withIV:(Byte *)iv {
    size_t numBytesEncrypted = 0;
    
    Byte *data = nil;
    long dataLength = self.length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    data = malloc(dataLength);
    memcpy(data, self.bytes, dataLength);
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES256, iv, data, dataLength, buffer, bufferSize, &numBytesEncrypted);
    free(data);
    
    output = [NSMutableData dataWithBytes:buffer length:numBytesEncrypted];
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

- (NSMutableData *)AES256DecryptWithKey:(Byte *)key withIV:(Byte *)iv withPadding:(BOOL)padding {
    size_t numBytesDecrypted = 0;
    
    Byte *data = nil;
    long dataLength = self.length;
    if (dataLength % 16 != 0) {
        dataLength = (dataLength / 16) * 16;
    }
    data = malloc(dataLength);
    memcpy(data, self.bytes, dataLength);
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    Byte *buffer = malloc(bufferSize);
    
    NSMutableData *output = nil;
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key, kCCKeySizeAES256, iv, data, dataLength, buffer, bufferSize, &numBytesDecrypted);
    free(data);
    
    if (padding) {
        output = [self removePadding:buffer withLength:numBytesDecrypted withBlockSize:16];
    } else {
        output = [NSMutableData dataWithBytes:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    
    if(result == kCCSuccess) {
        return output;
    } else {
        return nil;
    }
}

- (NSMutableData *)removePadding:(Byte *)data withLength:(size_t)length withBlockSize:(int)blockSize {
    NSMutableData *retData = nil;
    if (data != nil && length > 0) {
        Byte c = data[length - 1];
        int i = (int)c;
        Byte verifyByte[i];
        memcpy(verifyByte, data + (length - i), i);
        Byte verify[i];
        memset(verify, c, i);
        if (i < blockSize && memcmp(verifyByte, verify, i) == 0 ) {
            Byte newdata[length - i];
            memcpy(newdata, data, length - i);
            retData = [NSMutableData dataWithBytes:newdata length:length - i];
        } else {
            retData = [NSMutableData dataWithBytes:data length:length];
        }
    }
    return retData;
}

- (NSMutableData *)aes_wrap_key:(Byte *)kek withKekLength:(int)kekLength {
    uint8_t wrapped[(256 + 64) / 8];
    size_t wrapped_size = sizeof(wrapped);
    
    const uint8_t *iv= CCrfc3394_iv;
    const size_t ivLen = CCrfc3394_ivLen;
    CCSymmetricKeyWrap(kCCWRAPAES, iv, ivLen, kek, kekLength, self.bytes, self.length, wrapped, &wrapped_size);
    
    NSMutableData *output = nil;
    if (wrapped_size > 0) {
        output = [NSMutableData dataWithBytes:wrapped length:wrapped_size];
    }
    
    return output;
}

- (NSMutableData *)aes_unwrap_key:(Byte *)kek withKekLength:(int)kekLength {
    uint8_t unwrapped[256 / 8];
    size_t unwrapped_size = sizeof(unwrapped);
    
    const uint8_t *iv= CCrfc3394_iv;
    const size_t ivLen = CCrfc3394_ivLen;
    CCSymmetricKeyUnwrap(kCCWRAPAES, iv, ivLen, kek, kekLength, self.bytes, self.length, unwrapped, &unwrapped_size);
    
    NSMutableData *output = nil;
    if (unwrapped_size > 0) {
        output = [NSMutableData dataWithBytes:unwrapped length:unwrapped_size];
    }
    
    return output;
}

#pragma mark - 解密

+ (NSData *)dataWithBase64String:(NSString*)base64String {
    return [Base64Codec dataFromBase64String:base64String];
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)string {
    return [[[NSData allocWithZone:nil] initWithBase64EncodedString:string] autorelease];
}

- (id)initWithBase64EncodedString:(NSString *)string {
    NSMutableData *mutableData = nil;
    
    if( string ) {
        unsigned long ixtext = 0;
        unsigned long lentext = 0;
        unsigned char ch = 0;
        unsigned char inbuf[4], outbuf[3];
        short i = 0, ixinbuf = 0;
        BOOL flignore = NO;
        BOOL flendtext = NO;
        NSData *base64Data = nil;
        const unsigned char *base64Bytes = nil;
        
        // Convert the string to ASCII data.
        base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
        base64Bytes = [base64Data bytes];
        mutableData = [NSMutableData dataWithCapacity:base64Data.length];
        lentext = base64Data.length;
        
        while( YES ) {
            if( ixtext >= lentext ) break;
            ch = base64Bytes[ixtext++];
            flignore = NO;
            
            if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
            else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
            else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
            else if( ch == '+' ) ch = 62;
            else if( ch == '=' ) flendtext = YES;
            else if( ch == '/' ) ch = 63;
            else flignore = YES;
            
            if( ! flignore ) {
                short ctcharsinbuf = 3;
                BOOL flbreak = NO;
                
                if( flendtext ) {
                    if( ! ixinbuf ) break;
                    if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
                    else ctcharsinbuf = 2;
                    ixinbuf = 3;
                    flbreak = YES;
                }
                
                inbuf [ixinbuf++] = ch;
                
                if( ixinbuf == 4 ) {
                    ixinbuf = 0;
                    outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
                    outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
                    outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
                    
                    for( i = 0; i < ctcharsinbuf; i++ )
                        [mutableData appendBytes:&outbuf[i] length:1];
                }
                
                if( flbreak )  break;
            }
        }
    }
    
    self = [self initWithData:mutableData];
    return self;
}

#pragma mark - 加密

- (NSString*)base64String {
    return [Base64Codec base64StringFromData:self];
}

// 加密成base64的字符串
- (NSString *)base64Encoding {
    return [self base64EncodingWithLineLength:0];
}

- (NSString *)base64EncodingWithLineLength:(NSUInteger)lineLength {
    const unsigned char   *bytes = [self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:self.length];
    unsigned long ixtext = 0;
    unsigned long lentext = self.length;
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    unsigned short i = 0;
    unsigned short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while( YES ) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        
        for( i = ctcopy; i < 4; i++ )
            [result appendString:@"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if( lineLength > 0 ) {
            if( charsonline >= lineLength ) {
                charsonline = 0;
                [result appendString:@"\n"];
            }
        }
    }
    
    return [NSString stringWithString:result];
}

#pragma mark -

- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length {
    if( ! prefix || ! length || self.length < length ) return NO;
    return ( memcmp( [self bytes], prefix, length ) == 0 );
}

- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length {
    if( ! suffix || ! length || self.length < length ) return NO;
    return ( memcmp( ((const char *)[self bytes] + (self.length - length)), suffix, length ) == 0 );
}

#pragma mark - 检查图像数据的格式
- (NSString*)detectImageSuffix {
    uint8_t c;
    NSString *imageFormat = @"";
    [self getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            imageFormat = @".jpg";
            break;
        case 0x89:
            imageFormat = @".png";
            break;
        case 0x47:
            imageFormat = @".gif";
            break;
        case 0x49:
        case 0x4D:
            imageFormat = @".tiff";
            break;
        case 0x42:
            imageFormat = @".bmp";
            break;
        default:
            break;
    }
    return imageFormat;
}

#pragma mark - 解密类
- (NSRange)rangeOfNullTerminatedBytesFrom:(int)start {
    const Byte *pdata = [self bytes];
    NSUInteger len = [self length];
    if (start < len) {
        const Byte *end = memchr (pdata + start, 0x00, len - start);
        if (end != NULL) {
            return NSMakeRange (start, end - (pdata + start));
        }
    }
    return NSMakeRange (NSNotFound, 0);
}

//+ (NSData*)dataWithBase32String:(NSString*)encoded {
//    /* First valid character that can be indexed in decode lookup table */
//    static int charDigitsBase = '2';
//    
//    /* Lookup table used to decode() characters in encoded strings */
//    static int charDigits[] =
//    {	26,27,28,29,30,31,-1,-1,-1,-1,-1,-1,-1,-1 //   23456789:;<=>?
//        ,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14 // @ABCDEFGHIJKLMNO
//        ,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1 // PQRSTUVWXYZ[\]^_
//        ,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14 // `abcdefghijklmno
//        ,15,16,17,18,19,20,21,22,23,24,25                // pqrstuvwxyz
//    };
//    
//    if (![encoded canBeConvertedToEncoding:NSASCIIStringEncoding]) {
//        return nil;
//    }
//    const char *chars = [encoded cStringUsingEncoding:NSASCIIStringEncoding]; // avoids using characterAtIndex.
//    NSUInteger charsLen = [encoded lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
//    
//    // Note that the code below could detect non canonical Base32 length within the loop. However canonical Base32 length can be tested before entering the loop.
//    // A canonical Base32 length modulo 8 cannot be:
//    // 1 (aborts discarding 5 bits at STEP n=0 which produces no byte),
//    // 3 (aborts discarding 7 bits at STEP n=2 which produces no byte),
//    // 6 (aborts discarding 6 bits at STEP n=1 which produces no byte).
//    switch (charsLen & 7) { // test the length of last subblock
//        case 1: //  5 bits in subblock:  0 useful bits but 5 discarded
//        case 3: // 15 bits in subblock:  8 useful bits but 7 discarded
//        case 6: // 30 bits in subblock: 24 useful bits but 6 discarded
//            return nil; // non-canonical length
//    }
//    int charDigitsLen = sizeof(charDigits);
//    int bytesLen = (int)((charsLen * 5) >> 3);
//    Byte bytes[bytesLen];
//    int bytesOffset = 0, charsOffset = 0;
//    // Also the code below does test that other discarded bits
//    // (1 to 4 bits at end) are effectively 0.
//    while (charsLen > 0) {
//        int digit, lastDigit;
//        // STEP n = 0: Read the 1st Char in a 8-Chars subblock
//        // Leave 5 bits, asserting there's another encoding Char
//        if ((digit = (int)chars[charsOffset] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        lastDigit = digit << 3;
//        // STEP n = 5: Read the 2nd Char in a 8-Chars subblock
//        // Insert 3 bits, leave 2 bits, possibly trailing if no more Char
//        if ((digit = (int)chars[charsOffset + 1] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        bytes[bytesOffset] = (Byte)((digit >> 2) | lastDigit);
//        lastDigit = (digit & 3) << 6;
//        if (charsLen == 2) {
//            if (lastDigit != 0) {
//                return nil; // non-canonical end
//            }
//            break; // discard the 2 trailing null bits
//        }
//        // STEP n = 2: Read the 3rd Char in a 8-Chars subblock
//        // Leave 7 bits, asserting there's another encoding Char
//        if ((digit = (int)chars[charsOffset + 2] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        lastDigit |= (Byte)(digit << 1);
//        // STEP n = 7: Read the 4th Char in a 8-chars Subblock
//        // Insert 1 bit, leave 4 bits, possibly trailing if no more Char
//        if ((digit = (int)chars[charsOffset + 3] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        bytes[bytesOffset + 1] = (Byte)((digit >> 4) | lastDigit);
//        lastDigit = (Byte)((digit & 15) << 4);
//        if (charsLen == 4) {
//            if (lastDigit != 0) return nil; // non-canonical end
//            break; // discard the 4 trailing null bits
//        }
//        // STEP n = 4: Read the 5th Char in a 8-Chars subblock
//        // Insert 4 bits, leave 1 bit, possibly trailing if no more Char
//        if ((digit = (int)chars[charsOffset + 4] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        bytes[bytesOffset + 2] = (Byte)((digit >> 1) | lastDigit);
//        lastDigit = (Byte)((digit & 1) << 7);
//        if (charsLen == 5) {
//            if (lastDigit != 0) return nil; // non-canonical end
//            break; // discard the 1 trailing null bit
//        }
//        // STEP n = 1: Read the 6th Char in a 8-Chars subblock
//        // Leave 6 bits, asserting there's another encoding Char
//        if ((digit = (int)chars[charsOffset + 5] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        lastDigit |= (Byte)(digit << 2);
//        // STEP n = 6: Read the 7th Char in a 8-Chars subblock
//        // Insert 2 bits, leave 3 bits, possibly trailing if no more Char
//        if ((digit = (int)chars[charsOffset + 6] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        bytes[bytesOffset + 3] = (Byte)((digit >> 3) | lastDigit);
//        lastDigit = (Byte)((digit & 7) << 5);
//        if (charsLen == 7) {
//            if (lastDigit != 0) {
//                return nil; // non-canonical end
//            }
//            break; // discard the 3 trailing null bits
//        }
//        // STEP n = 3: Read the 8th Char in a 8-Chars subblock
//        // Insert 5 bits, leave 0 bit, next encoding Char may not exist
//        if ((digit = (int)chars[charsOffset + 7] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1) {
//            return nil; // invalid character
//        }
//        bytes[bytesOffset + 4] = (Byte)(digit | lastDigit);
//        //// This point is always reached for chars.length multiple of 8
//        charsOffset += 8;
//        bytesOffset += 5;
//        charsLen -= 8;
//    }
//    // On loop exit, discard the n trailing null bits
//    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
//}

//- (NSString*)base32String {
//    /* Lookup table used to canonically encode() groups of data bits */
//    static char canonicalChars[] =
//    {	'A','B','C','D','E','F','G','H','I','J','K','L','M' // 00..12
//        ,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z' // 13..25
//        ,'2','3','4','5','6','7'                             // 26..31
//    };
//    const Byte *bytes = [self bytes];
//    int bytesOffset = 0, bytesLen = (int)[self length];
//    int charsOffset = 0, charsLen = ((bytesLen << 3) + 4) / 5;
//    char chars[charsLen];
//    while (bytesLen != 0) {
//        int digit, lastDigit;
//        // INVARIANTS FOR EACH STEP n in [0..5[; digit in [0..31[;
//        // The remaining n bits are already aligned on top positions
//        // of the 5 least bits of digit, the other bits are 0.
//        ////// STEP n = 0: insert new 5 bits, leave 3 bits
//        digit = bytes[bytesOffset] & 255;
//        chars[charsOffset] = canonicalChars[digit >> 3];
//        lastDigit = (digit & 7) << 2;
//        if (bytesLen == 1) { // put the last 3 bits
//            chars[charsOffset + 1] = canonicalChars[lastDigit];
//            break;
//        }
//        ////// STEP n = 3: insert 2 new bits, then 5 bits, leave 1 bit
//        digit = bytes[bytesOffset + 1] & 255;
//        chars[charsOffset + 1] = canonicalChars[(digit >> 6) | lastDigit];
//        chars[charsOffset + 2] = canonicalChars[(digit >> 1) & 31];
//        lastDigit = (digit & 1) << 4;
//        if (bytesLen == 2) { // put the last 1 bit
//            chars[charsOffset + 3] = canonicalChars[lastDigit];
//            break;
//        }
//        ////// STEP n = 1: insert 4 new bits, leave 4 bit
//        digit = bytes[bytesOffset + 2] & 255;
//        chars[charsOffset + 3] = canonicalChars[(digit >> 4) | lastDigit];
//        lastDigit = (digit & 15) << 1;
//        if (bytesLen == 3) { // put the last 1 bits
//            chars[charsOffset + 4] = canonicalChars[lastDigit];
//            break;
//        }
//        ////// STEP n = 4: insert 1 new bit, then 5 bits, leave 2 bits
//        digit = bytes[bytesOffset + 3] & 255;
//        chars[charsOffset + 4] = canonicalChars[(digit >> 7) | lastDigit];
//        chars[charsOffset + 5] = canonicalChars[(digit >> 2) & 31];
//        lastDigit = (digit & 3) << 3;
//        if (bytesLen == 4) { // put the last 2 bits
//            chars[charsOffset + 6] = canonicalChars[lastDigit];
//            break;
//        }
//        ////// STEP n = 2: insert 3 new bits, then 5 bits, leave 0 bit
//        digit = bytes[bytesOffset + 4] & 255;
//        chars[charsOffset + 6] = canonicalChars[(digit >> 5) | lastDigit];
//        chars[charsOffset + 7] = canonicalChars[digit & 31];
//        //// This point is always reached for bytes.length multiple of 5
//        bytesOffset += 5;
//        charsOffset += 8;
//        bytesLen -= 5;
//    }
//    return [NSString stringWithCString:chars encoding:NSUTF8StringEncoding];
//    //	return [NSString stringWithCString:chars length:sizeof(chars)];
//}

#define FinishBlock(X)  (*code_ptr = (X),   code_ptr = dst++,   code = 0x01)

//- (NSData*)encodeCOBS {
//    if (self == nil || [self length] == 0) {
//        return self;
//    }
//    
//    NSMutableData *encoded = [NSMutableData dataWithLength:([self length] + [self length] / 254 + 1)];
//    unsigned char *dst = [encoded mutableBytes];
//    const unsigned char *ptr = [self bytes];
//    unsigned long length = [self length];
//    const unsigned char *end = ptr + length;
//    unsigned char *code_ptr = dst++;
//    unsigned char code = 0x01;
//    while (ptr < end) {
//        if (*ptr == 0) {
//            FinishBlock(code);
//        } else {
//            *dst++ = *ptr;
//            code++;
//            if (code == 0xFF) {
//                FinishBlock(code);
//            }
//        }
//        ptr++;
//    }
//    FinishBlock(code);
//    
//    [encoded setLength:((Byte *)dst - (Byte *)[encoded mutableBytes])];
//    return [NSData dataWithData:encoded];
//}

//- (NSData*)decodeCOBS {
//    if (self == nil || [self length] == 0) {
//        return self;
//    }
//    
//    const Byte *ptr = [self bytes];
//    NSUInteger length = [self length];
//    NSMutableData *decoded = [NSMutableData dataWithLength:length];
//    Byte *dst = [decoded mutableBytes];
//    Byte *basedst = dst;
//    
//    const unsigned char *end = ptr + length;
//    while (ptr < end) {
//        int i, code = *ptr++;
//        for (i=1; i<code; i++) {
//            *dst++ = *ptr++;
//        }
//        if (code < 0xFF) {
//            *dst++ = 0;
//        }
//    }
//    
//    [decoded setLength:(dst - basedst)];
//    return [NSData dataWithData:decoded];
//}

//- (NSData*)zlibInflate {
//    if ([self length] == 0) return self;
//    
//    NSUInteger full_length = [self length];
//    NSUInteger half_length = [self length] / 2;
//    
//    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
//    BOOL done = NO;
//    int status;
//    
//    z_stream strm;
//    strm.next_in = (Bytef *)[self bytes];
//    strm.avail_in = (uint32_t)[self length];
//    strm.total_out = 0;
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    
//    if (inflateInit (&strm) != Z_OK) {
//        return nil;
//    }
//    
//    while (!done) {
//        // Make sure we have enough room and reset the lengths.
//        if (strm.total_out >= [decompressed length]) {
//            [decompressed increaseLengthBy: half_length];
//        }
//        strm.next_out = [decompressed mutableBytes] + strm.total_out;
//        strm.avail_out = (uint32_t)([decompressed length] - strm.total_out);
//        
//        // Inflate another chunk.
//        status = inflate (&strm, Z_SYNC_FLUSH);
//        if (status == Z_STREAM_END) {
//            done = YES;
//        } else if (status != Z_OK) {
//            break;
//        }
//    }
//    if (inflateEnd (&strm) != Z_OK) {
//        return nil;
//    }
//    
//    // Set real length.
//    if (done) {
//        [decompressed setLength: strm.total_out];
//        return [NSData dataWithData: decompressed];
//    } else {
//        return nil;
//    }
//}

//- (NSData*)zlibDeflate {
//    if ([self length] == 0) return self;
//    
//    z_stream strm;
//    
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    strm.opaque = Z_NULL;
//    strm.total_out = 0;
//    strm.next_in=(Bytef *)[self bytes];
//    strm.avail_in = (uint32_t)[self length];
//    
//    // Compresssion Levels:
//    //   Z_NO_COMPRESSION
//    //   Z_BEST_SPEED
//    //   Z_BEST_COMPRESSION
//    //   Z_DEFAULT_COMPRESSION
//    
//    if (deflateInit(&strm, Z_BEST_SPEED) != Z_OK) {
//        return nil;
//    }
//    
//    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chuncks for expansion
//    
//    do {
//        if (strm.total_out >= [compressed length]) {
//            [compressed increaseLengthBy: 16384];
//        }
//        
//        strm.next_out = [compressed mutableBytes] + strm.total_out;
//        strm.avail_out = (uint32_t)([compressed length] - strm.total_out);
//        
//        deflate(&strm, Z_FINISH);
//        
//    } while (strm.avail_out == 0);
//    
//    deflateEnd(&strm);
//    
//    [compressed setLength: strm.total_out];
//    return [NSData dataWithData:compressed];
//}

//- (NSData*)gzipData {
//    if (self == nil || [self length] == 0) {
//        return nil;
//    }
//    z_stream zlibStreamStruct;
//    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
//    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
//    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
//    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
//    zlibStreamStruct.next_in   = (Bytef*)[self bytes]; // Pointer to input bytes
//    zlibStreamStruct.avail_in  = (uInt)[self length]; // Number of input bytes left to process
//    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
//    if (initError != Z_OK)
//    {
//        NSString *errorMsg = nil;
//        switch (initError)
//        {
//            case Z_STREAM_ERROR:
//                errorMsg = @"Invalid parameter passed in to function.";
//                break;
//            case Z_MEM_ERROR:
//                errorMsg = @"Insufficient memory.";
//                break;
//            case Z_VERSION_ERROR:
//                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
//                break;
//            default:
//                errorMsg = @"Unknown error code.";
//                break;
//        }
//        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
//        [errorMsg release];
//        return nil;
//    }
//    // Create output memory buffer for compressed data. The zlib documentation states that
//    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
//    NSMutableData *compressedData = [NSMutableData dataWithLength:[self length] * 1.01 + 12];
//    
//    int deflateStatus;
//    do
//    {
//        // Store location where next byte should be put in next_out
//        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
//        
//        // Calculate the amount of remaining free space in the output buffer
//        // by subtracting the number of bytes that have been written so far
//        // from the buffer's total capacity
//        zlibStreamStruct.avail_out = (uInt)([compressedData length] - zlibStreamStruct.total_out);
//        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
//        
//    } while ( deflateStatus == Z_OK );
//    
//    // Check for zlib error and convert code to usable error message if appropriate
//    if (deflateStatus != Z_STREAM_END)
//    {
//        NSString *errorMsg = nil;
//        switch (deflateStatus)
//        {
//            case Z_ERRNO:
//                errorMsg = @"Error occured while reading file.";
//                break;
//            case Z_STREAM_ERROR:
//                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
//                break;
//            case Z_DATA_ERROR:
//                errorMsg = @"The deflate data was invalid or incomplete.";
//                break;
//            case Z_MEM_ERROR:
//                errorMsg = @"Memory could not be allocated for processing.";
//                break;
//            case Z_BUF_ERROR:
//                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
//                break;
//            case Z_VERSION_ERROR:
//                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
//                break;
//            default:
//                errorMsg = @"Unknown error code.";
//                break;
//        }
//        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
//        [errorMsg release];
//        
//        // Free data structures that were dynamically created for the stream.
//        deflateEnd(&zlibStreamStruct);
//        
//        return nil;
//    }
//    // Free data structures that were dynamically created for the stream.
//    deflateEnd(&zlibStreamStruct);
//    [compressedData setLength: zlibStreamStruct.total_out];
//    return compressedData;
//}

//- (NSData*)ungzipData {
//    if ([self length] == 0)
//        return self;
//    
//    NSUInteger full_length = [self length];
//    NSUInteger half_length = [self length] / 2;
//    
//    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
//    BOOL done = NO;
//    int status;
//    
//    z_stream strm;
//    strm.next_in = (Bytef *)[self bytes];
//    strm.avail_in = (uInt)[self length];
//    strm.total_out = 0;
//    strm.zalloc = Z_NULL;
//    strm.zfree = Z_NULL;
//    if (inflateInit2(&strm, (15+32)) != Z_OK)
//        return nil;
//    
//    while (!done) {
//        // Make sure we have enough room and reset the lengths.
//        if (strm.total_out >= [decompressed length]) {
//            [decompressed increaseLengthBy: half_length];
//        }
//        strm.next_out = [decompressed mutableBytes] + strm.total_out;
//        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
//        // Inflate another chunk.
//        status = inflate (&strm, Z_SYNC_FLUSH);
//        if (status == Z_STREAM_END) {
//            done = YES;
//        } else if (status != Z_OK) {
//            break;
//        }
//    }
//    
//    if (inflateEnd (&strm) != Z_OK)
//        return nil;
//    // Set real length.
//    if (done) {
//        [decompressed setLength: strm.total_out];
//        return [NSData dataWithData: decompressed];
//    }
//    return nil;
//}

- (id)jsonDataToArrayOrNSDictionary {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    } else {
        return nil;
    }
}

@end

static uint8_t *randomData = nil;

@implementation NSMutableData (ExtendTool)
@dynamic fixedSize;
@dynamic limit;
@dynamic mark;
@dynamic position;

- (id)initWithSize:(int)size {
    self = [self initWithCapacity:size];
    if (!self) {
        return nil;
    }
    [self setFixedSize:size];
    [self setLimit:size];
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    objc_setAssociatedObject(self, @selector(fixedSize), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(limit), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(mark), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(position), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [super dealloc];
#endif
}

- (int)fixedSize {
    return [objc_getAssociatedObject(self, @selector(fixedSize)) intValue];
}

- (void)setFixedSize:(int)fixedSize {
    long oldSize = self.fixedSize;
    if (oldSize == 0) {
        oldSize = self.length;
    }
    if (oldSize > fixedSize) {
        NSRange delRange = NSMakeRange(fixedSize, (oldSize - fixedSize));
        [self replaceBytesInRange:delRange withBytes:NULL length:0];
    } else {
        [self resetBytesInRange:NSMakeRange(oldSize, (fixedSize - oldSize))];
    }
    // 如果总容量小于了限定值，调整限定值
    if (fixedSize < self.limit) {
        [self setLimit:fixedSize];
    }
    
    NSNumber *numObj = [[NSNumber alloc] initWithInt:fixedSize];
    objc_setAssociatedObject(self, @selector(fixedSize), numObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    if (numObj) [numObj release]; numObj = nil;
#endif
}

- (int)limit {
    return [objc_getAssociatedObject(self, @selector(limit)) intValue];
}

// 修改限制的值时不能超过分配的最大长度
- (void)setLimit:(int)limit {
    if (self.fixedSize != 0 && limit > self.fixedSize) {
        limit = self.fixedSize;
    }
    if (limit < 0) {
        limit = 0;
    }
    if (self.position > limit) {
        [self setPosition:limit];
    }
    
    NSNumber *numObj = [[NSNumber alloc] initWithInt:limit];
    objc_setAssociatedObject(self, @selector(limit), numObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    if (numObj) [numObj release]; numObj = nil;
#endif
    if ((self.mark != -1) && (self.mark > limit)) {
        [self setMark:-1];
    }
}

- (int)mark {
    return [objc_getAssociatedObject(self, @selector(mark)) intValue];
}

- (void)setMark:(int)mark {
    if (mark > self.length) {
        mark = (int)self.length;
    }
    
    NSNumber *numObj = [[NSNumber alloc] initWithInt:mark];
    objc_setAssociatedObject(self, @selector(mark), numObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    if (numObj) [numObj release]; numObj = nil;
#endif
}

- (int)position {
    return [objc_getAssociatedObject(self, @selector(position)) intValue];
}

// 设置位置的时候不能超过限制的最大值
- (void)setPosition:(int)position {
    if (self.limit != 0 && position > self.limit) {
        position = self.limit;
    }
    if (position > self.length) {
        position = (int)self.length;
    }
    if (position < 0) {
        position = 0;
    }
    
    NSNumber *numObj = [[NSNumber alloc] initWithInt:position];
    objc_setAssociatedObject(self, @selector(position), numObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    if (numObj) [numObj release]; numObj = nil;
#endif
    if ((self.mark != -1) && (self.mark > position)) {
        [self setMark:-1];
    }
}

- (int)copyFromIndex:(int)index withSource:(NSMutableData*)source withSourceIndex:(int)sourceIndex withLength:(int)length {
    int copyLenth = 0;
    int desFixedSize = self.fixedSize;
    int sourFixedSize = source.fixedSize;
    if (desFixedSize == 0) {
        desFixedSize = (int)self.length;
    }
    if (sourFixedSize == 0) {
        sourFixedSize = (int)source.length;
    }
    if (((index + length) > desFixedSize) || (sourceIndex + length) > sourFixedSize) {
        return copyLenth;
    } else {
        [self replaceBytesInRange:NSMakeRange(index, length) withBytes:[[source subdataWithRange:NSMakeRange(sourceIndex, length)] bytes]];
        copyLenth = length;
    }
    return copyLenth;
}

- (int)clearFromIndex:(int)index withLength:(int)length {
    int clearLength = 0;
    int currSize = self.fixedSize;
    if (currSize == 0) {
        currSize = (int)self.length;
    }
    if ((index + length) > currSize) {
        length = (currSize - index);
    }
    if (length > 0) {
        [self resetBytesInRange:NSMakeRange(index, length)];
        clearLength = length;
    }
    return clearLength;
}

- (int32_t)toInt32WithStartIndex:(int)startIndex {
    int32_t retVal = 0;
    int subCount = sizeof(retVal);
    if (startIndex + subCount > self.length) {
        subCount = (int)(self.length - startIndex);
    }
    NSData *subData = [self subdataWithRange:NSMakeRange(startIndex, subCount)];
    memcpy(sint_32.c, (Byte*)subData.bytes, subCount);
    retVal = sint_32.int32;
    return retVal;
}

- (int64_t)toInt64WithStartIndex:(int)startIndex {
    int64_t retVal = 0;
    int subCount = sizeof(retVal);
    if (startIndex + subCount > self.length) {
        subCount = (int)(self.length - startIndex);
    }
    NSData *subData = [self subdataWithRange:NSMakeRange(startIndex, subCount)];
    memcpy(sint_64.c, (Byte*)subData.bytes, subCount);
    retVal = sint_64.int64;
    return retVal;
}

- (BOOL)checkIndex:(int)index {
    if (index < 0 || index >= self.limit) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkIndex:(int)index withSizeOfType:(int)sizeOfType {
    if (index < 0 || index > self.limit - sizeOfType) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkGetBounds:(int)bytesPerElement withLength:(int)length withOffset:(int)offset withCount:(int)count {
    long byteCount = bytesPerElement * count;
    if ((offset | count) < 0 || offset > length || length - offset < count) {
        return NO;
    }
    if (byteCount > [self remaining]) {
        return NO;
    }
    return YES;
}

- (BOOL)checkPutBounds:(int)bytesPerElement withLength:(int)length withOffset:(int)offset withCount:(int)count {
    long byteCount = bytesPerElement * count;
    if ((offset | count) < 0 || offset > length || length - offset < count) {
        return NO;
    }
    if (byteCount > [self remaining]) {
        return NO;
    }
    return YES;
}

- (BOOL)checkStartEndRemaining:(int)start withEnd:(int)end {
    if (end < start || start < 0 || end > [self remaining]) {
        return NO;
    } else {
        return YES;
    }
}

// 清除NSMutableData
- (void)clear {
    [self setPosition:0];
    [self setMark:-1];
    [self setLimit:(self.fixedSize > 0 ? self.fixedSize : (int)self.length)];
}

// 读写指针指到NSMutableData头部，并且设置了最多只能读出之前写入的数据长度(而不是整个NSMutableData的容量大小)
- (void)flip {
    [self setLimit:self.position];
    [self setPosition:0];
    [self setMark:-1];
}

// 判断是否还有剩余
- (BOOL)hasRemaining {
    return self.position < self.limit;
}

// 标记当前指向的位置
- (void)markPosition {
    [self setMark:self.position];
}

// 返回剩余的可用空间
- (long)remaining {
    return self.limit -self.position;
}

// 将NSMutableData的位置设定到Mark的位置
- (void)reset {
    if (self.mark != -1) {
        [self setPosition:self.mark];
    }
}

// 将指针指向NSMutableData的开头
- (void)rewind {
    [self setPosition:0];
    [self setMark:-1];
}

+ (NSMutableData*)nextBytes:(int)bitCount {
    dispatch_block_t block = (dispatch_block_t) ^{
        int err = 0;
        
        // Don't ask for too many bytes in one go, that can lock up your system
        err = SecRandomCopyBytes(kSecRandomDefault, bitCount, randomData);
        if (err != noErr) {
            @throw [NSException exceptionWithName:@"..." reason:@"..." userInfo:nil];
        }
    };
    
    if (!randomData) {
        randomData = malloc(bitCount);
    } else {
        free(randomData);
        randomData = malloc(bitCount);
    }
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block); //regenerate random data
    NSMutableData *retData = [[[NSMutableData alloc] initWithBytes:randomData length:bitCount] autorelease];
    if (randomData) {
        free(randomData); randomData = nil;
    }
    return retData;
}

@end

@interface DataStream ()

@property (nonatomic,  readwrite, retain) NSMutableData *stream;

@end

@implementation DataStream
@synthesize stream = _stream;
@synthesize order = _order;

- (id)initWithAllocateSize:(int)allocateSize {
    if (self = [super init]) {
        NSMutableData *tmpStream = [[NSMutableData alloc] initWithSize:allocateSize];
        [self setStream:tmpStream];
#if !__has_feature(objc_arc)
        if (tmpStream) [tmpStream release]; tmpStream = nil;
#endif
        [self setOrder:BIG_ENDIAN_EX];
        return self;
    } else {
        return nil;
    }
}

- (id)initFromData:(NSMutableData*)data {
    if (self = [super init]) {
        [self setStream:data];
        [self setOrder:BIG_ENDIAN_EX];
        int limitLen = (int)([self stream].length);
        [[self stream] setLimit:limitLen];
        [[self stream] setFixedSize:limitLen];
        return self;
    } else {
        return nil;
    }
}

+ (DataStream*)wrapWithData:(NSMutableData*)data {
    return [DataStream wrapWithData:data withStart:0 withByteCount:(int)(data.length)];
}

+ (DataStream*)wrapWithData:(NSMutableData*)data withStart:(int)start withByteCount:(int)byteCount {
    if (start + byteCount > data.length) {
        return nil;
    }
    DataStream *dataStream = [[[DataStream alloc] initFromData:data] autorelease];
    [dataStream setMark:-1];
    [dataStream setPosition:start];
    [dataStream setLimit:(start + byteCount)];
    [[dataStream stream] setFixedSize:(int)(data.length)];
    return dataStream;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setStream:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)toMutableData {
    return [self stream];
}

- (int)position {
    return [[self stream] position];
}

- (void)setPosition:(int)pos {
    [[self stream] setPosition:pos];
}

- (int)remaining {
    return [[self stream] remaining];
}

- (BOOL)hasRemaining {
    return [self position] < [self limit];
}

- (int)limit {
    return [[self stream] limit];
}

- (void)setLimit:(int)limit {
    [[self stream] setLimit:limit];
}

- (int)mark {
    return [[self stream] mark];
}

- (void)setMark:(int)mark {
    [[self stream] setMark:mark];
}

- (void)rewind {
    [[self stream] rewind];
}

- (Byte)get {
    if ([self stream].position == [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"get" userInfo:nil];
    }
    return ((Byte*)([self stream].bytes))[[self stream].position++];
}

- (int)getWithMutableData:(NSMutableData*)dst {
    return [self getWithMutableData:dst withDstOffset:0 withByteCount:(int)dst.length];
}

- (int)getWithMutableData:(NSMutableData*)dst withDstOffset:(int)dstOffset withByteCount:(int)byteCount {
    // 检查传入参数是否存在越界
    if (dstOffset + byteCount > dst.length) {
        return NO;
    }
    // 检查获取的长度是否对于DataStream存在越界
    if (byteCount > [[self stream] remaining]) {
        return NO;
    }
    for (long i = dstOffset; i < dstOffset + byteCount; ++i) {
        ((Byte*)dst.bytes)[i] = [self get];
    }
    return byteCount;
}

- (int)getWithMutableData:(NSMutableData*)dst withFromIndex:(int)index withByteCount:(int)byteCount {
    return [self getWithMutableData:dst withDstOffset:0 withFromIndex:index withByteCount:byteCount];
}

- (int)getWithMutableData:(NSMutableData*)dst withDstOffset:(int)dstOffset withFromIndex:(int)index withByteCount:(int)byteCount {
    // 检查传入参数是否存在越界
    if (dstOffset + byteCount > dst.length) {
        return NO;
    }
    // 检查对于获取长度是否对于DataStream存在越界
    if (index + byteCount > [self stream].limit) {
        return NO;
    }
    for (int i = 0; i < byteCount; ++i) {
        ((Byte*)dst.bytes)[dstOffset + i] = [self getFromIndex:(index + i)];
    }
    return byteCount;
}

- (Byte)getFromIndex:(int)index {
    if ([[self stream] checkIndex:index]) {
        return ((Byte*)([self stream].bytes))[index];
    } else {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"DataStream" userInfo:nil];
    }
}

- (char)getChar {
    int newPosition = [self stream].position + sizeof(char);
    if (newPosition > [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getChar" userInfo:nil];
    }
    
    char result = ((char)((Byte*)([self stream].bytes))[[self stream].position]);
    [[self stream] setPosition:newPosition];
    return result;
}

- (char)getChar:(int)index {
    if ([[self stream] checkIndex:index withSizeOfType:sizeof(char)]) {
        return ((char)((Byte*)([self stream].bytes))[index]);
    } else {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getChar:" userInfo:nil];
    }
}

- (double)getDouble {
    int typeSize = sizeof(double);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getDouble" userInfo:nil];
    }
    NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
    int read = [self getWithMutableData:data];
    double result = 0;
    if (read > 0) {
        if (self.order == BIG_ENDIAN_EX) {
            result = [BigEndianBitConverter bigEndianToDouble64:(Byte*)data.bytes byteLength:(int)data.length];
        } else {
            result = [LittleEndianBitConverter littleEndianToDouble64:(Byte*)data.bytes byteLength:(int)data.length];
        }
        [[self stream] setPosition:newPosition];
    }
#if !__has_feature(objc_arc)
    if (data) [data release]; data = nil;
#endif
    return result;
}

- (double)getDouble:(int)index {
    int typeSize = sizeof(double);
    double result = 0;
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
        int read = [self getWithMutableData:data withFromIndex:index withByteCount:typeSize];
        if (read > 0) {
            if (self.order == BIG_ENDIAN_EX) {
                result = [BigEndianBitConverter bigEndianToDouble64:(Byte*)data.bytes byteLength:(int)data.length];
            } else {
                result = [LittleEndianBitConverter littleEndianToDouble64:(Byte*)data.bytes byteLength:(int)data.length];
            }
        }
#if !__has_feature(objc_arc)
        if (data) [data release]; data = nil;
#endif
    }
    return result;
}

- (float)getFloat {
    int typeSize = sizeof(float);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getFloat" userInfo:nil];
    }
    NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
    int read = [self getWithMutableData:data];
    float result = 0;
    if (read > 0) {
        if (self.order == BIG_ENDIAN_EX) {
            result = [BigEndianBitConverter bigEndianToFloat32:(Byte*)data.bytes byteLength:(int)data.length];
        } else {
            result = [LittleEndianBitConverter littleEndianToFloat32:(Byte*)data.bytes byteLength:(int)data.length];
        }
        [[self stream] setPosition:newPosition];
    }
#if !__has_feature(objc_arc)
    if (data) [data release]; data = nil;
#endif
    return result;
}

- (float)getFloat:(int)index {
    int typeSize = sizeof(float);
    float result = 0;
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
        int read = [self getWithMutableData:data withFromIndex:index withByteCount:typeSize];
        if (read > 0) {
            if (self.order == BIG_ENDIAN_EX) {
                result = [BigEndianBitConverter bigEndianToFloat32:(Byte*)data.bytes byteLength:(int)data.length];
            } else {
                result = [LittleEndianBitConverter littleEndianToFloat32:(Byte*)data.bytes byteLength:(int)data.length];
            }
        }
#if !__has_feature(objc_arc)
        if (data) [data release]; data = nil;
#endif
    }
    return result;
}

- (int)getInt {
    int typeSize = sizeof(int);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getInt" userInfo:nil];
    }
    NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
    int read = [self getWithMutableData:data];
    int result = 0;
    if (read > 0) {
        if (self.order == BIG_ENDIAN_EX) {
            result = [BigEndianBitConverter bigEndianToInt32:(Byte*)data.bytes byteLength:(int)data.length];
        } else {
            result = [LittleEndianBitConverter littleEndianToInt32:(Byte*)data.bytes byteLength:(int)data.length];
        }
        [[self stream] setPosition:newPosition];
    }
#if !__has_feature(objc_arc)
    if (data) [data release]; data = nil;
#endif
    return result;
}

- (int)getInt:(int)index {
    int typeSize = sizeof(int);
    int result = 0;
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
        int read = [self getWithMutableData:data withFromIndex:index withByteCount:typeSize];
        if (read > 0) {
            if (self.order == BIG_ENDIAN_EX) {
                result = [BigEndianBitConverter bigEndianToInt32:(Byte*)data.bytes byteLength:(int)data.length];
            } else {
                result = [LittleEndianBitConverter littleEndianToInt32:(Byte*)data.bytes byteLength:(int)data.length];
            }
        }
#if !__has_feature(objc_arc)
        if (data) [data release]; data = nil;
#endif
    }
    return result;
}

- (long)getLong {
    int typeSize = sizeof(long);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getLong" userInfo:nil];
    }
    NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
    int read = [self getWithMutableData:data];
    long result = 0;
    if (read > 0) {
        if (self.order == BIG_ENDIAN_EX) {
            result = [BigEndianBitConverter bigEndianToLong64:(Byte*)data.bytes byteLength:(int)data.length];
        } else {
            result = [LittleEndianBitConverter littleEndianToLong64:(Byte*)data.bytes byteLength:(int)data.length];
        }
        [[self stream] setPosition:newPosition];
    }
#if !__has_feature(objc_arc)
    if (data) [data release]; data = nil;
#endif
    return result;
}

- (long)getLong:(int)index {
    int typeSize = sizeof(long);
    long result = 0;
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
        int read = [self getWithMutableData:data withFromIndex:index withByteCount:typeSize];
        if (read > 0) {
            if (self.order == BIG_ENDIAN_EX) {
                result = [BigEndianBitConverter bigEndianToLong64:(Byte*)data.bytes byteLength:(int)data.length];
            } else {
                result = [LittleEndianBitConverter littleEndianToLong64:(Byte*)data.bytes byteLength:(int)data.length];
            }
        }
#if !__has_feature(objc_arc)
        if (data) [data release]; data = nil;
#endif
    }
    return result;
}

- (short)getShort {
    int typeSize = sizeof(short);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"getShort" userInfo:nil];
    }
    NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
    int read = [self getWithMutableData:data];
    short result = 0;
    if (read > 0) {
        if (self.order == BIG_ENDIAN_EX) {
            result = [BigEndianBitConverter bigEndianToInt16:(Byte*)data.bytes byteLength:(int)data.length];
        } else {
            result = [LittleEndianBitConverter littleEndianToInt16:(Byte*)data.bytes byteLength:(int)data.length];
        }
        [[self stream] setPosition:newPosition];
    }
#if !__has_feature(objc_arc)
    if (data) [data release]; data = nil;
#endif
    return result;
}

- (short)getShort:(int)index {
    int typeSize = sizeof(short);
    short result = 0;
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        NSMutableData *data = [[NSMutableData alloc] initWithSize:typeSize];
        int read = [self getWithMutableData:data withFromIndex:index withByteCount:typeSize];
        if (read > 0) {
            if (self.order == BIG_ENDIAN_EX) {
                result = [BigEndianBitConverter bigEndianToInt16:(Byte*)data.bytes byteLength:(int)data.length];
            } else {
                result = [LittleEndianBitConverter littleEndianToInt16:(Byte*)data.bytes byteLength:(int)data.length];
            }
        }
#if !__has_feature(objc_arc)
        if (data) [data release]; data = nil;
#endif
    }
    return result;
}

- (BOOL)put:(Byte)b {
    if ([self stream].position == [self stream].limit) {
        return NO;
    }
    ((Byte*)([self stream].bytes))[[self stream].position++] = b;
    return YES;
}

- (BOOL)putByte:(int)index withB:(Byte)b {
    if ([[self stream] checkIndex:index]) {
        ((Byte*)([self stream].bytes))[index] = b;
        return YES;
    }
    return NO;
}

- (BOOL)putWithData:(NSData*)src {
    return [self putWithData:src withSrcOffset:0 withByteCount:(int)src.length];
}

- (BOOL)putWithData:(NSData*)src withSrcOffset:(int)srcOffset withByteCount:(int)byteCount {
    if ([[self stream] checkPutBounds:1 withLength:(int)src.length withOffset:srcOffset withCount:byteCount]) {
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, byteCount) withBytes:[[src subdataWithRange:NSMakeRange(srcOffset, byteCount)] bytes]];
        [self stream].position += byteCount;
        return YES;
    }
    return NO;
}

- (BOOL)putWithDataStream:(DataStream*)src {
    if ([self isEqualTo:src]) {
        return NO;
    }
    int srcByteCount = (int)[[src stream] remaining];
    if (srcByteCount > [[self stream] remaining]) {
        @throw [NSException exceptionWithName:@"DataUnderflow" reason:@"putWithDataStream" userInfo:nil];
    }
    for (int i = 0; i < srcByteCount; i++) {
        ((Byte*)([self stream].bytes))[[self stream].position + i] = ((Byte*)([src stream].bytes))[[src stream].position + i];
    }
    [[src stream] setPosition:[src stream].limit];
    [src stream].position = [src stream].limit;
    [self stream].position += srcByteCount;
    return YES;
}

- (BOOL)putChar:(char)value {
    int typeSize = sizeof(char);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        return NO;
    }
    if (self.order == BIG_ENDIAN_EX) {
        NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)data.bytes)];
    } else {
        NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)data.bytes)];
    }
    [self stream].position = newPosition;
    return YES;
}

- (BOOL)putChar:(int)index withValue:(char)value {
    int typeSize = sizeof(char);
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        if (self.order == BIG_ENDIAN_EX) {
            NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        } else {
            NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        }
        return YES;
    }
    return NO;
}

- (BOOL)putDouble:(double)value {
    int typeSize = sizeof(double);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        return NO;
    }
    if (self.order == BIG_ENDIAN_EX) {
        NSData *byteData = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    } else {
        NSData *byteData = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    }
    [self stream].position = newPosition;
    return YES;
}

- (BOOL)putDouble:(int)index withValue:(double)value {
    int typeSize = sizeof(double);
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        if (self.order == BIG_ENDIAN_EX) {
            NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        } else {
            NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        }
        return YES;
    }
    return NO;
}

- (BOOL)putFloat:(float)value {
    int typeSize = sizeof(float);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        return NO;
    }
    if (self.order == BIG_ENDIAN_EX) {
        NSData *byteData = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    } else {
        NSData *byteData = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    }
    [self stream].position = newPosition;
    return YES;
}

- (BOOL)putFloat:(int)index withValue:(float)value {
    int typeSize = sizeof(float);
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        if (self.order == BIG_ENDIAN_EX) {
            NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        } else {
            NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        }
        return YES;
    }
    return NO;
}

- (BOOL)putInt:(int)value {
    int typeSize = sizeof(int);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        return NO;
    }
    if (self.order == BIG_ENDIAN_EX) {
        NSData *byteData = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    } else {
        NSData *byteData = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    }
    [self stream].position = newPosition;
    return YES;
}

- (BOOL)putInt:(int)index withValue:(int)value {
    int typeSize = sizeof(int);
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        if (self.order == BIG_ENDIAN_EX) {
            NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        } else {
            NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        }
        return YES;
    }
    return NO;
}

- (BOOL)putLong:(long)value {
    int typeSize = sizeof(long);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        return NO;
    }
    if (self.order == BIG_ENDIAN_EX) {
        NSData *byteData = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    } else {
        NSData *byteData = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    }
    [self stream].position = newPosition;
    return YES;
}

- (BOOL)putLong:(int)index withValue:(long)value {
    int typeSize = sizeof(long);
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        if (self.order == BIG_ENDIAN_EX) {
            NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        } else {
            NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        }
        return YES;
    }
    return NO;
}

- (BOOL)putShort:(short)value {
    int typeSize = sizeof(short);
    int newPosition = [self stream].position + typeSize;
    if (newPosition > [self stream].limit) {
        return NO;
    }
    if (self.order == BIG_ENDIAN_EX) {
        NSData *byteData = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    } else {
        NSData *byteData = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
        [[self stream] replaceBytesInRange:NSMakeRange([self stream].position, typeSize) withBytes:((Byte*)byteData.bytes)];
    }
    [self stream].position = newPosition;
    return YES;
}

- (BOOL)putShort:(int)index withValue:(short)value {
    int typeSize = sizeof(short);
    if ([[self stream] checkIndex:index withSizeOfType:typeSize]) {
        if (self.order == BIG_ENDIAN_EX) {
            NSData *data = [BigEndianBitConverter bigEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        } else {
            NSData *data = [LittleEndianBitConverter littleEndianBytes:(Byte*)(&value) byteLength:typeSize];
            [[self stream] replaceBytesInRange:NSMakeRange(index, typeSize) withBytes:((Byte*)data.bytes)];
        }
        return YES;
    }
    return NO;
}

@end

@implementation NSDictionary (ExtendTool)

- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:[self count]] autorelease];
    NSArray *keys=[self allKeys];
    for(id key in keys) {
        id value=[self objectForKey:key];
        id copyValue;
        if ([value isKindOfClass:[NSDate class]]) {
            copyValue = [value copy];
            [dict setObject:copyValue forKey:key];
#if !__has_feature(objc_arc)
            if (copyValue) [copyValue release]; copyValue = nil;
#endif
            continue;
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            copyValue = [value copy];
            [dict setObject:copyValue forKey:key];
#if !__has_feature(objc_arc)
            if (copyValue) [copyValue release]; copyValue = nil;
#endif
            continue;
        }
        if ([value respondsToSelector:@selector(mutableDeepCopy)]) {
            @autoreleasepool {
                copyValue = [value mutableDeepCopy];
                [copyValue retain];
            }
        } else if([value respondsToSelector:@selector(mutableCopy)]) {
            copyValue=[value mutableCopy];
        }
        if(copyValue == nil) {
            copyValue = [value copy];
        }
        [dict setObject:copyValue forKey:key];
#if !__has_feature(objc_arc)
        if (copyValue) [copyValue release]; copyValue = nil;
#endif
    }
    return dict;
}

- (NSData*)dictionaryToData {
    if (!self) {
        return nil;
    }
    NSData *dicData = [NSPropertyListSerialization dataWithPropertyList:self
                                                                 format:NSPropertyListXMLFormat_v1_0
                                                                options:0
                                                                  error:NULL];
    return dicData;
}

- (NSString*)toJson {
    NSString *jsonStr = nil;
    if (self != nil) {
        if ([NSJSONSerialization isValidJSONObject:self]) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
            jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
        }
    }
    return jsonStr;
}

@end

@implementation NSMutableDictionary (ExtendTool)

- (NSData*)mutableDictionaryToData {
    NSString *error;
    
    NSData *data = [NSPropertyListSerialization dataFromPropertyList:self format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(!data){
        [error release];
    }
    return data;
}

@end

@implementation NSDate (ExtendTool)

+ (NSDate*)UtcSinceDate {
    return [NSDate dateWithTimeIntervalSince1970:0];
}

- (NSDate*)UtcToLocalDate {
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger interval = [tz secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval:interval];
}

- (NSDate*)localToUtcDate {
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger interval = -[tz secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval:interval];
}

- (NSDate*)toLocalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate*)toGlobalTime {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

+ (NSDate*)getDateTimeFromTimeStamp2001:(double)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00"];
    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate] autorelease];
#if !__has_feature(objc_arc)
    if (dateFormatter != nil) [dateFormatter release]; dateFormatter = nil;
#endif
    return returnDate;
}

@end

@implementation NSArray (ExtendTool)

- (NSMutableData*)fillToNSMutableData {
    NSMutableData *retBuffer = [[[NSMutableData alloc] initWithSize:(int)self.count] autorelease];
    for (int i = 0; i < self.count; i++) {
        id obj = self[i];
        Byte b = 0x00;
        if (obj != nil && [obj isKindOfClass:[NSNumber class]]) {
            b = [obj unsignedCharValue];
        }
        ((Byte*)retBuffer.bytes)[i] = b;
    }
    return retBuffer;
}

- (NSMutableArray*)clone {
    NSMutableArray *newArray = [[[NSMutableArray alloc] init] autorelease];
    newArray = (NSMutableArray*)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)self, kCFPropertyListMutableContainers);
    return newArray;
}

@end

@implementation NSMutableArray (ExtendTool)
@dynamic fixedSize;

- (id)initWithSize:(int)size {
    self = [self initWithCapacity:size];
    if (!self) {
        return nil;
    }
    [self setFixedSize:size];
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    objc_setAssociatedObject(self, @selector(fixedSize), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [super dealloc];
#endif
}

- (int)fixedSize {
    return [objc_getAssociatedObject(self, @selector(fixedSize)) intValue];
}

- (void)setFixedSize:(int)fixedSize {
    int oldSize = self.fixedSize;
    if (oldSize == 0) {
        oldSize = [self count];
    }
    if (oldSize > fixedSize) {
        NSRange delRange = NSMakeRange(fixedSize, (oldSize - fixedSize));
        [self removeObjectsInRange:delRange];
    } else {
        for (int i = 0; i < (fixedSize - oldSize); i++) {
            [self addObject:@(0)];
        }
    }

    NSNumber *numObj = [[NSNumber alloc] initWithInt:fixedSize];
    objc_setAssociatedObject(self, @selector(fixedSize), numObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    if (numObj) [numObj release]; numObj = nil;
#endif
}

- (int)copyFromIndex:(int)index withSource:(NSMutableArray*)source withSourceIndex:(int)sourceIndex withLength:(int)length {
    int copyLenth = 0;
    int desFixedSize = self.fixedSize;
    int sourFixedSize = source.fixedSize;
    if (desFixedSize == 0) {
        desFixedSize = (int)[self count];
    }
    if (sourFixedSize == 0) {
        sourFixedSize = (int)[source count];
    }
    if (((index + length) > desFixedSize) || (sourceIndex + length) > sourFixedSize) {
        return copyLenth;
    } else {
        for (int i = 0; i < length; i++) {
            self[(index+i)] = source[(sourceIndex+i)];
            copyLenth += 1;
        }
    }
    return copyLenth;
}

- (int)clearFromIndex:(int)index withLength:(int)length {
    int clearLength = 0;
    int currSize = self.fixedSize;
    if (currSize == 0) {
        currSize = (int)self.count;
    }
    if ((index + length) > currSize) {
        length = (currSize - index);
    }
    if (length > 0) {
        for (int i = 0; i < length; i++) {
            self[(index + i)] = @(0);
            clearLength += 1;
        }
    }
    return clearLength;
}

- (NSMutableData*)fillToNSMutableData {
    NSMutableData *retBuffer = [[[NSMutableData alloc] initWithSize:(int)self.count] autorelease];
    for (int i = 0; i < self.count; i++) {
        id obj = self[i];
        Byte b = 0x00;
        if (obj != nil && [obj isKindOfClass:[NSNumber class]]) {
            b = [obj unsignedCharValue];
        }
        ((Byte*)retBuffer.bytes)[i] = b;
    }
    return retBuffer;
}

- (NSMutableArray*)clone {
    NSMutableArray *newArray = nil;
    newArray = (NSMutableArray*)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)self, kCFPropertyListMutableContainers);
    return newArray;
}

@end

@implementation NSFileHandle (ExtendTool)
@dynamic accessMode;

- (id)initWithPath:(NSString*)path withAccess:(FileAccessEnum)access {
    self = [self initWithFileDescriptor:open([path fileSystemRepresentation], access) closeOnDealloc:YES];
    if (!self) {
        return nil;
    }
    NSNumber *numObj = [[NSNumber alloc] initWithInt:access];
    objc_setAssociatedObject(self, @selector(accessMode), numObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
    if (numObj) [numObj release]; numObj = nil;
#endif
    return self;
}

+ (id)openPath:(NSString*)path withAccess:(FileAccessEnum)access {
    return [[[self alloc] initWithPath:path withAccess:access] autorelease];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    objc_setAssociatedObject(self, @selector(accessMode), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [super dealloc];
#endif
}

- (void)flush {
    [self synchronizeFile];
}

- (uint64_t)seek:(uint64_t)offset withOrigin:(SeekOriginEnum)origin {
    int64_t jumpValue = 0;
    if (origin == Begin) {
        jumpValue = offset;
    } else if (origin == Current) {
        jumpValue = self.offsetInFile + offset;
    } else if (origin == End) {
        jumpValue = self.seekToEndOfFile - offset;
    }
    if (jumpValue < 0) {
        jumpValue = 0;
    }
    if (jumpValue > self.seekToEndOfFile) {
        jumpValue = self.seekToEndOfFile;
    }
    [self seekToFileOffset:jumpValue];
    return jumpValue;
}

- (BOOL)canRead {
    if (self.accessMode == OpenRead || self.accessMode == OpenReadWrite) {
        return YES;
    } else {
        return NO;
    }
    // 以下是另一种方式，但是获取不准确
    // int fd = [self.stream fileDescriptor];
    // fd_set fdset;
    // struct timeval tmout = { 0, 0 };
    // FD_ZERO(&fdset);
    // FD_SET(fd, &fdset);
    // if (select(fd + 1, &fdset, NULL, NULL, &tmout) <= 0) {
    // return NO;
    // }
    // return FD_ISSET(fd, &fdset);
}

- (BOOL)canSeek {
    return YES;
}

- (BOOL)canWrite {
    if (self.accessMode == OpenWrite || self.accessMode == OpenReadWrite) {
        return YES;
    } else {
        return NO;
    }
}

- (uint64_t)length {
    uint64_t currPos = self.offsetInFile;
    uint64_t totalLength = self.seekToEndOfFile;
    [self seekToFileOffset:currPos];
    return totalLength;
}

- (void)setLength:(uint64_t)value {
    [self truncateFileAtOffset:value];
}

- (uint64_t)position {
    return self.offsetInFile;
}

- (void)setPosition:(uint64_t)position {
    [self seekToFileOffset:position];
}

- (uint64_t)available {
    return ([self length] - [self position]);
}

- (FileAccessEnum)accessMode {
    return (FileAccessEnum)[objc_getAssociatedObject(self, @selector(accessMode)) intValue];
}

// unsiged byte to int
- (int)readByte {
    int retVal = -1;
    NSData *tmpData = [self readDataOfLength:1];
    if (tmpData != nil && tmpData.length > 0) {
        retVal = (int)(((Byte*)tmpData.bytes)[0]);
    }
    return retVal;
}

- (int)read:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count {
    int readCount = 0;
    NSMutableData *tempData = [[self readDataOfLength:count] mutableCopy];
    
    if (tempData != nil && tempData.length > 0) {
        readCount = (int)tempData.length;
        [buffer copyFromIndex:offset withSource:tempData withSourceIndex:0 withLength:readCount];
    }
#if !__has_feature(objc_arc)
    if (tempData) [tempData release]; tempData = nil;
#endif
    return readCount;
}

- (void)writeByte:(Byte)value {
    [self writeData:[NSData dataWithBytes:&value length:1]];
}

- (void)write:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count {
    if ((offset + count) > buffer.length) {
        count = (int)buffer.length - offset;
    }
    if (count > 0) {
        [self writeData:[buffer subdataWithRange:NSMakeRange(offset, count)]];
    }
}

- (long)transferTo:(NSFileHandle*)destination {
    NSMutableData *array = [[NSMutableData alloc] initWithSize:81920];
    int count;
    long total = 0;
    while ((count = (int)[self read:array withOffset:0 withCount:array.fixedSize]) != 0) {
        total += count;
        [destination write:array withOffset:0 withCount:count];
    }
#if !__has_feature(objc_arc)
    if (array) [array release]; array = nil;
#endif
    return total;
}

@end

@implementation Stream

static int MAX_SKIP_BUFFER_SIZE = 2048;

- (int)read {
    @throw [NSException exceptionWithName:@"Not Implement" reason:@"read" userInfo:nil];
}

- (int)read:(NSMutableData*)buffer {
    return [self read:buffer withOff:0 withLen:(int)(buffer.length)];
}

- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count {
    if (buffer == nil) {
        @throw [NSException exceptionWithName:@"NullPointer" reason:nil userInfo:nil];
    } else if (offset < 0 || count < 0 || count > buffer.length - offset) {
        @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:nil userInfo:nil];
    } else if (count == 0) {
        return 0;
    }
    
    int c = [self read];
    if (c == -1) {
        return -1;
    }
    ((Byte*)(buffer.bytes))[offset] = (Byte)c;
    
    int i = 1;
    @try {
        for (; i < count ; i++) {
            c = [self read];
            if (c == -1) {
                break;
            }
            ((Byte*)(buffer.bytes))[offset + i] = (Byte)c;
        }
    }
    @catch (NSException *exception) {
        
    }
    return i;
}

+ (int)readFully:(Stream*)inStream withBuf:(NSMutableData*)buf {
    return [Stream readFully:inStream withBuf:buf withOffset:0 withLength:(int)(buf.length)];
}

+ (int)readFully:(Stream*)inStream withBuf:(NSMutableData*)buf withOffset:(int)offset withLength:(int)length {
    int totalRead = 0;
    while (totalRead < length) {
        int numRead = [inStream read:buf withOff:(offset + totalRead) withLen:(length - totalRead)];
        if (numRead < 0) {
            break;
        }
        totalRead += numRead;
    }
    return totalRead;
}

- (void)writeWithByte:(int)b {
    @throw [NSException exceptionWithName:@"Not Implement" reason:@"write" userInfo:nil];
}

- (void)write:(NSMutableData*)buffer {
    [self write:buffer withOffset:0 withCount:(int)(buffer.length)];
}

- (void)write:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count  {
    if (buffer == nil) {
        @throw [NSException exceptionWithName:@"NullPointer" reason:nil userInfo:nil];
    } else if ((offset < 0) || (offset > buffer.length) || (count < 0) || ((offset + count) > buffer.length) || ((offset + count) < 0)) {
        @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:nil userInfo:nil];
    } else if (count == 0) {
        return;
    }
    for (int i = 0 ; i < count ; i++) {
        [self writeWithByte:(int)(((Byte*)(buffer.bytes))[offset+ i])];
    }
}

- (int64_t)skip:(int64_t)n {
    int64_t remaining = n;
    int nr;
    
    if (n <= 0) {
        return 0;
    }
    
    int size = MIN(MAX_SKIP_BUFFER_SIZE, (int)remaining);
    
    NSMutableData *skipBuffer = [[NSMutableData alloc] initWithSize:size];
    while (remaining > 0) {
        nr = [self read:skipBuffer withOff:0 withLen:MIN(size, (int)remaining)];
        if (nr < 0) {
            break;
        }
        remaining -= nr;
    }
#if !__has_feature(objc_arc)
    if (skipBuffer) [skipBuffer release]; skipBuffer = nil;
#endif
    return n - remaining;
}

- (int)available {
    return 0;
}

- (void)mark:(int)readlimit {
}

- (void)reset {
}

- (BOOL)markSupported {
    return NO;
}

- (void)close {
}

@end

@interface MemoryStreamEx ()

@property (nonatomic, readwrite, retain) NSMutableData *stream;

@end

@implementation MemoryStreamEx
@synthesize stream = _stream;

- (id)initInternal {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSMutableData *tmpStream =  [[NSMutableData alloc] initWithSize:0];
    [self setStream:tmpStream];
    [[self stream] rewind];
#if !__has_feature(objc_arc)
    if (tmpStream) [tmpStream release]; tmpStream = nil;
#endif
    _offsetInStream = 0;
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setStream:nil];
    [super dealloc];
#endif
}

+ (id)memoryStreamEx {
    return [[[MemoryStreamEx alloc] initInternal] autorelease];
}

- (id)initWithData:(NSMutableData*)data {
    if (self = [super init]) {
        [self setStream:data];
        [[self stream] setFixedSize:(int)(data.length)];
        [[self stream] rewind];
        _offsetInStream = 0;
        return self;
    } else {
#if !__has_feature(objc_arc)
        [super dealloc];
#endif
        return nil;
    }
}

- (int)read {
    int sourFixedSize = [self length];
    if ((_offsetInStream + 1) > sourFixedSize) {
        return -1;
    }
    int byte = 0;
    byte = (((Byte*)([self stream].bytes))[_offsetInStream++]);
    return byte;
}

- (int)read:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count {
    int readCount = 0;
    int desFixedSize = buffer.fixedSize;
    if (desFixedSize == 0) {
        desFixedSize = (int)self.length;
    }
    long sourFixedSize = [self length];
    if ((_offsetInStream + count) > sourFixedSize) {
        count = (int)(sourFixedSize - _offsetInStream);
    }
    if ((offset + count) > desFixedSize) {
        count = desFixedSize - offset;
    }
    NSMutableData *tmpData = [[[self stream] subdataWithRange:NSMakeRange(_offsetInStream, count)] mutableCopy];
    if (tmpData != nil && tmpData.length > 0) {
        readCount = (int)tmpData.length;
        [buffer copyFromIndex:offset withSource:tmpData withSourceIndex:0 withLength:readCount];
        _offsetInStream += readCount;
    }
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    return readCount;
}

- (void)writeWithByte:(int)b {
    if ([self length] < (_offsetInStream + 1)) {
        [self setLength:(_offsetInStream + 1)];
    }
    
    ((Byte*)([self stream].bytes))[_offsetInStream++] = (Byte)b;
}

- (void)write:(NSMutableData*)buffer withOffset:(int)offset withCount:(int)count {
    int sourFixedSize = buffer.fixedSize;
    if (sourFixedSize == 0) {
        sourFixedSize = (int)buffer.length;
    }
    if ((offset + count) > sourFixedSize) {
        count = sourFixedSize - offset;
    }
    if ([self length] < (_offsetInStream + count)) {
        [self setLength:(_offsetInStream + count)];
    }
    int wtCount = [[self stream] copyFromIndex:_offsetInStream withSource:buffer withSourceIndex:offset withLength:count];
    _offsetInStream += wtCount;
}

- (NSMutableData*)availableData {
    return [self stream];
}

- (int)seek:(int)offset withOrigin:(SeekOriginEnum)origin {
    int jumpValue = 0;
    if (origin == Begin) {
        _offsetInStream = offset;
    } else if (origin == Current) {
        _offsetInStream += offset;
    } else if (origin == End) {
        _offsetInStream = [self length] - offset;
    }
    if (jumpValue < 0) {
        jumpValue = 0;
    }
    if (jumpValue > _offsetInStream) {
        jumpValue = _offsetInStream;
    }
    jumpValue = _offsetInStream;
    return jumpValue;
}

- (int)length {
    return (int)([self stream].length);
}

- (void)setLength:(int)value {
    [[self stream] setFixedSize:value];
}

- (int)position {
    return _offsetInStream;
}

- (void)setPosition:(int)position {
    [self seek:position withOrigin:Begin];
}

- (long)remaining {
    return [self stream].length - self.position;
}

- (BOOL)canRead {
    if ([self stream] != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canSeek {
    if ([self stream] != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canWrite {
    if ([self stream] != nil && [[self stream] isKindOfClass:[NSMutableData class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end

@implementation NSColor (ExtendTool)

- (CGColorRef)toCGColor {
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat*)&components];
    return (CGColorRef)[(id)CGColorCreate(colorSpace, components) autorelease];
}

+ (NSColor*)colorFromCGColor:(CGColorRef)CGColor {
    if (CGColor == NULL) return nil;
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end

@implementation NSImage (ExtendTool)

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(IMBImageResizingMethod)resizeMethod {
    float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth = dstRect.size.width;
    float targetHeight = dstRect.size.height;
    BOOL cropping = !(resizeMethod == IMBImageResizeScale);
    
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    NSRect sourceRect;
    if (cropping) {
        float destX = 0.0, destY = 0.0;
        if (resizeMethod == IMBImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == IMBImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
                // Crop top
                destX = round((scaledWidth - targetWidth) / 2.0);
                destY = round(scaledHeight - targetHeight);
            } else {
                // Crop left
                destX = 0.0;
                destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == IMBImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
                // Crop bottom
                destX = 0.0;
                destY = 0.0;
            } else {
                // Crop right
                destX = round(scaledWidth - targetWidth);
                destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = NSMakeRect(destX / scaleFactor, destY / scaleFactor,
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = NSMakeRect(0, 0, sourceWidth, sourceHeight);
        dstRect.origin.x += (targetWidth - scaledWidth) / 2.0;
        dstRect.origin.y += (targetHeight - scaledHeight) / 2.0;
        dstRect.size.width = scaledWidth;
        dstRect.size.height = scaledHeight;
    }
    
    [self drawInRect:dstRect fromRect:sourceRect operation:op fraction:delta];
}

- (NSImage *)imageToFitSize:(NSSize)size method:(IMBImageResizingMethod)resizeMethod {
    NSImage *result = [[NSImage alloc] initWithSize:size];
    
    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self drawInRect:NSMakeRect(0,0,size.width,size.height) operation:NSCompositeSourceOver fraction:1.0 method:resizeMethod];
    [result unlockFocus];
    
    return [result autorelease];
}

- (NSImage *)imageToFitRect:(NSRect)rect method:(IMBImageResizingMethod)resizeMethod {
    NSImage *result = [[NSImage alloc] initWithSize:rect.size];
    
    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self drawInRect:rect operation:NSCompositeSourceOver fraction:1.0 method:resizeMethod];
    [result unlockFocus];
    
    return [result autorelease];
}


- (NSImage *)imageCroppedToFitSize:(NSSize)size {
    return [self imageToFitSize:size method:IMBImageResizeCrop];
}

- (NSImage *)imageScaledToFitSize:(NSSize)size {
    return [self imageToFitSize:size method:IMBImageResizeScale];
}

- (NSImage *) imageFromRect: (NSRect) rect {
    NSAffineTransform * xform = [NSAffineTransform transform];
    
    // translate reference frame to map rectangle 'rect' into first quadrant
    [xform translateXBy: -rect.origin.x
                    yBy: -rect.origin.y];
    
    NSSize canvas_size = [xform transformSize: rect.size];
    
    NSImage * canvas = [[NSImage alloc] initWithSize: canvas_size];
    [canvas lockFocus];
    
    [xform concat];
    
    // Get NSImageRep of image
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSImageRep * rep = [self bestRepresentationForDevice: nil];
#pragma clang diagnostic pop
    [rep drawAtPoint: NSZeroPoint];
    
    [canvas unlockFocus];
    return [canvas autorelease];
}

@end