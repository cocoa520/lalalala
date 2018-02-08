//
//  Arrays.m
//  
//
//  Created by Pallas on 5/11/16.
//
//  Complete

#import "Arrays.h"
#import "CategoryExtend.h"

@implementation Arrays

// a == b == bool[]
+ (BOOL)areEqualWithBOOLArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    if (a == b) {
        return YES;
    }
    
    if (a == nil || b == nil) {
        return NO;
    }
    
    return [Arrays haveSameContentsWithBOOLArray:a withB:b];
}

// a == b == ushort[]
+ (BOOL)areEqualWithUShortArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    if (a == b) {
        return YES;
    }
    
    if (a == nil || b == nil) {
        return NO;
    }
    
    return [Arrays haveSameContentsWithUShort:a withB:b];
}

/// <summary>
/// Are two arrays equal.
/// </summary>
/// <param name="a">Left side.</param>
/// <param name="b">Right side.</param>
/// <returns>True if equal.</returns>
+ (BOOL)areEqualWithByteArray:(NSData*)a withB:(NSData*)b {
    if (a == b) {
        return YES;
    }
    
    if (a == nil || b == nil) {
        return NO;
    }
    
    return [Arrays haveSameContentsWithByteArray:a withB:b];
}

+ (BOOL)areSameWithByteArray:(NSData*)a withB:(NSData*)b {
    return [Arrays areEqualWithByteArray:a withB:b];
}

/// <summary>
/// A constant time equals comparison - does not terminate early if
/// test will fail.
/// </summary>
/// <param name="a">first array</param>
/// <param name="b">second array</param>
/// <returns>true if arrays equal, false otherwise.</returns>
+ (BOOL)constantTimeAreEqualWithByteArray:(NSMutableData*)a withB:(NSMutableData*)b {
    int i = (int)(a.length);
    if (i != b.length) {
        return NO;
    }
    int cmp = 0;
    while (i != 0) {
        --i;
        cmp |= (((Byte*)(a.bytes))[i] ^ ((Byte*)(b.bytes))[i]);
    }
    return cmp == 0;
}

// a == b == int[]
+ (BOOL)areEqualWithIntArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    if (a == b) {
        return YES;
    }
    
    if (a == nil || b == nil) {
        return NO;
    }
    
    return [Arrays haveSameContentsWithIntArray:a withB:b];
}

// a == b == uint[]
+ (BOOL)areEqualWithUintArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    if (a == b) {
        return YES;
    }
    
    if (a == nil || b == nil) {
        return NO;
    }
    
    return [Arrays haveSameContentsWithUIntArray:a withB:b];
}

// a == b == bool[]
+ (BOOL)haveSameContentsWithBOOLArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    int i = (int)(a.count);
    if (i != b.count) {
        return NO;
    }
    while (i != 0) {
        --i;
        if ([a[i] boolValue] != [b[i] boolValue]) {
            return NO;
        }
    }
    return YES;
}

// a == b == ushort[]
+ (BOOL)haveSameContentsWithUShort:(NSMutableArray*)a withB:(NSMutableArray*)b {
    int i = (int)(a.count);
    if (i != b.count) {
        return NO;
    }
    while (i != 0) {
        --i;
        if ([a[i] unsignedShortValue] != [b[i] unsignedShortValue]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)haveSameContentsWithByteArray:(NSData*)a withB:(NSData*)b {
    int i = (int)(a.length);
    if (i != b.length) {
        return NO;
    }
    while (i != 0) {
        --i;
        if (((Byte*)(a.bytes))[i] != ((Byte*)(b.bytes))[i]) {
            return NO;
        }
    }
    return YES;
}

// a == b == int[]
+ (BOOL)haveSameContentsWithIntArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    int i = (int)(a.count);
    if (i != b.count) {
        return NO;
    }
    while (i != 0) {
        --i;
        if ([a[i] intValue] != [b[i] intValue]) {
            return NO;
        }
    }
    return YES;
}

// a == b == uint[]
+ (BOOL)haveSameContentsWithUIntArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    int i = (int)(a.count);
    if (i != b.count) {
        return NO;
    }
    while (i != 0) {
        --i;
        if ([a[i] unsignedIntValue] != [b[i] unsignedIntValue]) {
            return NO;
        }
    }
    return YES;
}

+ (NSString*)toString:(NSMutableArray*)a {
    NSMutableString *mStr = [[[NSMutableString alloc] initWithString:@"["] autorelease];
    if (a.count > 0) {
        [mStr appendFormat:@"%@", a[0]];
        for (int index = 1; index < a.count; ++index) {
            [mStr appendString:@", "];
            [mStr appendFormat:@"%@", a[index]];
        }
    }
    [mStr appendString:@"]"];
    return mStr;
}

+ (int)getHashCodeWithByteArray:(NSData*)data {
    if (data == nil) {
        return 0;
    }
    
    int i = (int)(data.length);
    int hc = i + 1;
    
    while (--i >= 0) {
        hc *= 257;
        hc ^= ((Byte*)(data.bytes))[i];
    }
    
    return hc;
}

+ (int)getHashCodeWithByteArray:(NSData*)data withOff:(int)off withLen:(int)len {
    if (data == nil) {
        return 0;
    }
    
    int i = len;
    int hc = i + 1;
    
    while (--i >= 0) {
        hc *= 257;
        hc ^= ((Byte*)(data.bytes))[off + i];
    }
    
    return hc;
}

// data == int[]
+ (int)getHashCodeWithIntArray:(NSMutableArray*)data {
    if (data == nil) {
        return 0;
    }
    
    int i = (int)(data.count);
    int hc = i + 1;
    
    while (--i >= 0) {
        hc *= 257;
        hc ^= [data[i] intValue];
    }
    
    return hc;
}

// data == int[]
+ (int)getHashCodeWithIntArray:(NSMutableArray*)data withOff:(int)off withLen:(int)len {
    if (data == nil) {
        return 0;
    }
    
    int i = len;
    int hc = i + 1;
    
    while (--i >= 0) {
        hc *= 257;
        hc ^= [data[off + i] intValue];
    }
    
    return hc;
}

// data == uint[]
+ (BOOL)getHashCodeWithUIntArray:(NSMutableArray*)data {
    if (data == nil) {
        return 0;
    }
    
    int i = (int)(data.count);
    int hc = i + 1;
    
    while (--i >= 0) {
        hc *= 257;
        hc ^= [data[i] intValue];
    }
    
    return hc;
}

// data == uint[]
+ (BOOL)getHashCodeWithUIntArray:(NSMutableArray*)data withOff:(int)off withLen:(int)len {
    if (data == nil) {
        return 0;
    }
    
    int i = len;
    int hc = i + 1;
    
    while (--i >= 0) {
        hc *= 257;
        hc ^= [data[off + i] intValue];
    }
    
    return hc;
}

// data == uint64_t[]
+ (int)getHashCodeWithUInt64Array:(NSMutableArray*)data {
    if (data == nil) {
        return 0;
    }
    
    int i = (int)(data.count);
    int hc = i + 1;
    
    while (--i >= 0) {
        uint64_t di = [data[i] unsignedLongLongValue];
        hc *= 257;
        hc ^= (int)di;
        hc *= 257;
        hc ^= (int)(di >> 32);
    }
    
    return hc;
}

// data == uint64_t[]
+ (int)getHashCodeWithUInt64Array:(NSMutableArray*)data withOff:(int)off withLen:(int)len {
    if (data == nil) {
        return 0;
    }
    
    int i = len;
    int hc = i + 1;
    
    while (--i >= 0) {
        uint64_t di = [data[off + i] unsignedLongLongValue];
        hc *= 257;
        hc ^= (int)di;
        hc *= 257;
        hc ^= (int)(di >> 32);
    }
    
    return hc;
}

+ (NSMutableData*)cloneWithByteArray:(NSMutableData*)data {
    if (data == nil) {
        return nil;
    }
    int length = (int)(data.length);
    NSMutableData *retVal = [[NSMutableData alloc] initWithSize:length];
    [retVal copyFromIndex:0 withSource:data withSourceIndex:0 withLength:length];
    return retVal;
}

+ (NSMutableData*)cloneWithByteArray:(NSMutableData*)data withExisting:(NSMutableData*)existing {
    if (data == nil) {
        return nil;
    }
    if ((existing == nil) || (existing.length != data.length)) {
        return [[Arrays cloneWithByteArray:data] autorelease];
    }
    [existing copyFromIndex:0 withSource:data withSourceIndex:0 withLength:(int)(existing.length)];
    return existing;
}

// NSMutableArray == int[]
+ (NSMutableArray*)cloneWithIntArray:(NSMutableArray*)data {
    return data == nil ? nil : [[data clone] autorelease];
}

// NSMutableArray == uint[]
+ (NSMutableArray*)cloneWithUIntArray:(NSMutableArray*)data {
    return data == nil ? nil : [[data clone] autorelease];
}

// NSMutableArray == long[]
+ (NSMutableArray*)cloneWithLongArray:(NSMutableArray*)data {
    return data == nil ? nil : [[data clone] autorelease];
}

// NSMutableArray == uint64_t[]
+ (NSMutableArray*)cloneWithUInt64Array:(NSMutableArray*)data {
    return data == nil ? nil : [[data clone] autorelease];
}

// NSMutableArray == uint64_t[]
+ (NSMutableArray*)cloneWithUInt64Array:(NSMutableArray*)data withExisting:(NSMutableArray*)existing {
    if (data == nil) {
        return nil;
    }
    if ((existing == nil) || (existing.count != data.count)) {
        return [Arrays cloneWithUInt64Array:data];
    }
    [existing copyFromIndex:0 withSource:data withSourceIndex:0 withLength:(int)(existing.count)];
    return existing;
}

+ (BOOL)containsWithByteArray:(NSMutableData*)a withN:(Byte)n {
    for (int i = 0; i < a.length; ++i) {
        if (((Byte*)(a.bytes))[i] == n) {
            return YES;
        }
    }
    return NO;
}

// NSMutableArray == short[]
+ (BOOL)containsWithShortArray:(NSMutableArray*)a withN:(short)n {
    for (int i = 0; i < a.count; ++i) {
        if ([a[i] shortValue] == n) {
            return YES;
        }
    }
    return NO;
}

// NSMutableArray == int[]
+ (BOOL)containsWithIntArray:(NSMutableArray*)a withN:(int)n {
    for (int i = 0; i < a.count; ++i) {
        if ([a[i] intValue] == n) {
            return YES;
        }
    }
    return NO;
}

+ (void)fillWithByteArray:(NSMutableData*)buf withB:(Byte)b {
    int i = (int)(buf.length);
    while (i > 0) {
        ((Byte*)(buf.bytes))[--i] = b;
    }
}

+ (NSMutableData*)copyOfWithData:(NSMutableData*)data withNewLength:(int)newLength {
    NSMutableData *tmp = [[NSMutableData alloc] initWithSize:newLength];
    int length = MIN(newLength, (int)(data.length));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:0 withLength:length];
    return tmp;
}

// NSMutableArray == ushort[]
+ (NSMutableArray*)copyOfWithUShortArray:(NSMutableArray*)data withNewLength:(int)newLength {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, (int)(data.count));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:0 withLength:length];
    return tmp;
}

// NSMutableArray == int[]
+ (NSMutableArray*)copyOfWithIntArray:(NSMutableArray*)data withNewLength:(int)newLength {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, (int)(data.count));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:0 withLength:length];
    return tmp;
}

// NSMutableArray == long[]
+ (NSMutableArray*)copyOfLongArray:(NSMutableArray*)data withNewLength:(int)newLength {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, (int)(data.count));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:0 withLength:length];
    return tmp;
}

// NSMutableArray == BigInteger[]
+ (NSMutableArray*)copyOfBigIntegerArray:(NSMutableArray*)data withNewLength:(int)newLength {
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, (int)(data.count));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:0 withLength:length];
    return tmp;
}

/**
 * Make a copy of a range of bytes from the passed in data array. The range can
 * extend beyond the end of the input array, in which case the return array will
 * be padded with zeroes.
 *
 * @param data the array from which the data is to be copied.
 * @param from the start index at which the copying should take place.
 * @param to the final index of the range (exclusive).
 *
 * @return a new byte array containing the range given.
 */
+ (NSMutableData*)copyOfRangeWithByteArray:(NSMutableData*)data withFrom:(int)from withTo:(int)to {
    int newLength = [Arrays getLength:from withTo:to];
    NSMutableData *tmp = [[NSMutableData alloc] initWithSize:newLength];
    int length = MIN(newLength, ((int)(data.length) - from));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:from withLength:length];
    return tmp;
}

// NSMutableArray == int[]
+ (NSMutableArray*)copyOfRangeWithIntArray:(NSMutableArray*)data withFrom:(int)from withTo:(int)to {
    int newLength = [Arrays getLength:from withTo:to];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, ((int)(data.count) - from));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:from withLength:length];
    return tmp;
}

// NSMutableArray == long[]
+ (NSMutableArray*)copyOfRangeWithLongArray:(NSMutableArray*)data withFrom:(int)from withTo:(int)to {
    int newLength = [Arrays getLength:from withTo:to];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, ((int)(data.count) - from));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:from withLength:length];
    return tmp;
}

// NSMutableArray == BigInteger[]
+ (NSMutableArray*)copyOfRangeWithBigIntegerArray:(NSMutableArray*)data withFrom:(int)from withTo:(int)to {
    int newLength = [Arrays getLength:from withTo:to];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:newLength];
    int length = MIN(newLength, ((int)(data.count) - from));
    [tmp copyFromIndex:0 withSource:data withSourceIndex:from withLength:length];
    return tmp;
}

+ (int)getLength:(int)from withTo:(int)to {
    int newLength = to - from;
    if (newLength < 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"%d > %d", from, to] userInfo:nil];
    }
    return newLength;
}

+ (NSMutableData*)appendWithByteArray:(NSMutableData*)a withB:(Byte)b {
    if (a == nil) {
        NSMutableData *retVal = [[[NSMutableData alloc] initWithSize:1] autorelease];
        ((Byte*)(retVal.bytes))[0] = b;
        return retVal;
    }
    
    int length = (int)(a.length);
    NSMutableData *result = [[[NSMutableData alloc] initWithSize:(length + 1)] autorelease];
    [result copyFromIndex:0 withSource:a withSourceIndex:0 withLength:length];
    ((Byte*)(result.bytes))[length] = b;
    return result;
}

// NSMutableArray == short[]
+ (NSMutableArray*)appendWithShortArray:(NSMutableArray*)a withB:(short)b {
    if (a == nil) {
        NSMutableArray *retVal = [[[NSMutableArray alloc] initWithSize:1] autorelease];
        retVal[0] = @(b);
        return retVal;
    }
    
    int length = (int)(a.count);
    NSMutableArray *result = [[[NSMutableArray alloc] initWithSize:(length + 1)] autorelease];
    [result copyFromIndex:0 withSource:a withSourceIndex:0 withLength:length];
    result[length] = @(b);
    return result;
}

// NSMutableArray == int[]
+ (NSMutableArray*)appendWithIntArray:(NSMutableArray*)a withB:(int)b {
    if (a == nil) {
        NSMutableArray *retVal = [[[NSMutableArray alloc] initWithSize:1] autorelease];
        retVal[0] = @(b);
        return retVal;
    }
    
    int length = (int)(a.count);
    NSMutableArray *result = [[[NSMutableArray alloc] initWithSize:(length + 1)] autorelease];
    [result copyFromIndex:0 withSource:a withSourceIndex:0 withLength:length];
    result[length] = @(b);
    return result;
}

+ (NSMutableData*)concatenateWithByteArray:(NSMutableData*)a withB:(NSMutableData*)b {
    if (a == nil) {
        return [[Arrays cloneWithByteArray:b] autorelease];
    }
    if (b == nil) {
        return [[Arrays cloneWithByteArray:a] autorelease];
    }
    
    int length = (int)(a.length + b.length);
    NSMutableData *rv = [[[NSMutableData alloc] initWithSize:length] autorelease];
    [rv copyFromIndex:0 withSource:a withSourceIndex:0 withLength:(int)(a.length)];
    [rv copyFromIndex:(int)(a.length) withSource:b withSourceIndex:0 withLength:(int)(b.length)];
    return rv;
}

// NSMutableArray == byte[][]
+ (NSMutableData*)concatenateAllWithByte2Array:(NSMutableArray*)vs {
    NSMutableArray *nonNull = [[NSMutableArray alloc] initWithSize:(int)(vs.count)];
    
    int count = 0;
    int totalLength = 0;
    
    for (int i = 0; i < vs.count; ++i) {
        NSMutableData *v = (NSMutableData*)vs[i];
        if (v != nil) {
            nonNull[count++] = v;
            totalLength += (int)(v.length);
        }
    }
    
    NSMutableData *result = [[[NSMutableData alloc] initWithSize:totalLength] autorelease];
    int pos = 0;
    
    for (int j = 0; j < count; ++j) {
        NSMutableData *v = (NSMutableData*)nonNull[j];
        [result copyFromIndex:pos withSource:v withSourceIndex:0 withLength:(int)(v.length)];
        pos += (int)(v.length);
    }
    
#if !__has_feature(objc_arc)
    if (nonNull != nil) [nonNull release]; nonNull = nil;
#endif
    return result;
}

// NSMutableArray == int[]
+ (NSMutableArray*)concatenateWithIntArray:(NSMutableArray*)a withB:(NSMutableArray*)b {
    if (a == nil) {
        return [Arrays cloneWithIntArray:b];
    }
    if (b == nil) {
        return [Arrays cloneWithIntArray:a];
    }
    
    int length = (int)(a.count + b.count);
    NSMutableArray *rv = [[[NSMutableArray alloc] initWithSize:length] autorelease];
    [rv copyFromIndex:0 withSource:a withSourceIndex:0 withLength:(int)(a.count)];
    [rv copyFromIndex:(int)(a.count) withSource:b withSourceIndex:0 withLength:(int)(b.count)];
    return rv;
}

+ (NSMutableData*)prependWithByteArray:(NSMutableData*)a withB:(Byte)b {
    if (a == nil) {
        NSMutableData *retVal = [[[NSMutableData alloc] initWithSize:1] autorelease];
        ((Byte*)(retVal.bytes))[0] = b;
        return retVal;
    }
    
    int length = (int)(a.length);
    NSMutableData *result = [[[NSMutableData alloc] initWithSize:(length + 1)] autorelease];
    [result copyFromIndex:1 withSource:a withSourceIndex:0 withLength:length];
    ((Byte*)(result.bytes))[0] = b;
    return result;
}

// NSMutableArray == short[]
+ (NSMutableArray*)prependWithShortArray:(NSMutableArray*)a withB:(short)b {
    if (a == nil) {
        NSMutableArray *retVal = [[[NSMutableArray alloc] initWithSize:1] autorelease];
        retVal[0] = @(b);
        return retVal;
    }
    
    int length = (int)(a.count);
    NSMutableArray *result = [[[NSMutableArray alloc] initWithSize:(length + 1)] autorelease];
    [result copyFromIndex:1 withSource:a withSourceIndex:0 withLength:length];
    result[0] = @(b);
    return result;
}

// NSMutableArray == int[]
+ (NSMutableArray*)prependWithIntArray:(NSMutableArray*)a withB:(int)b {
    if (a == nil) {
        NSMutableArray *retVal = [[[NSMutableArray alloc] initWithSize:1] autorelease];
        retVal[0] = @(b);
        return retVal;
    }
    
    int length = (int)(a.count);
    NSMutableArray *result = [[[NSMutableArray alloc] initWithSize:(length + 1)] autorelease];
    [result copyFromIndex:1 withSource:a withSourceIndex:0 withLength:length];
    result[0] = @(b);
    return result;
}

+ (NSMutableData*)reverse:(NSMutableData*)a {
    if (a == nil) {
        return nil;
    }
    
    int p1 = 0, p2 = (int)(a.length);
    NSMutableData *result = [[[NSMutableData alloc] initWithSize:p2] autorelease];
    
    while (--p2 >= 0) {
        ((Byte*)(result.bytes))[p2] = ((Byte*)(a.bytes))[p1++];
    }
    
    return result;
}

// NSMutableArray == int[]
+ (NSMutableArray*)reverseWithIntArray:(NSMutableArray*)a {
    if (a == nil) {
        return nil;
    }
    
    int p1 = 0, p2 = (int)(a.count);
    NSMutableArray *result = [[[NSMutableArray alloc] initWithSize:p2] autorelease];
    
    while (--p2 >= 0) {
        result[p2] = a[p1++];
    }
    
    return result;
}

@end
