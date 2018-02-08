//
//  Nat.m
//  
//
//  Created by Pallas on 5/9/16.
//
//  Complete

#import "Nat.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Pack.h"

uint64_t const M = 0xFFFFFFFFUL;

@implementation Nat

// x, y, z == uint[]
+ (uint)add:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[i] unsignedLongLongValue] + [y[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        }
    }
    return (uint)c;
}

// z == uint[]
+ (uint)add33At:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[zPos + 0] unsignedLongLongValue] + x;
        z[zPos + 0] = @((uint)c);
        c >>= 32;
        c += [z[zPos + 1] unsignedLongLongValue] + 1;
        z[zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)add33At:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[zOff + zPos] unsignedLongLongValue] + x;
        z[zOff + zPos] = @((uint)c);
        c >>= 32;
        c += [z[zOff + zPos + 1] unsignedLongLongValue] + 1;
        z[zOff + zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZoff:zOff withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)add33To:(int)len withX:(uint)x withZ:(NSMutableArray*)z {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[0] unsignedLongLongValue] + x;
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] unsignedLongLongValue] + 1;
        z[1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:2]);
    }
    return retVal;
}

// z == uint[]
+ (uint)add33To:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[zOff + 0] unsignedLongLongValue] + x;
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 1] unsignedLongLongValue] + 1;
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZoff:zOff withZpos:2]);
    }
    return retVal;
}

// x, y, z == uint[]
+ (uint)addBothTo:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[i] unsignedLongLongValue] + [y[i] unsignedIntValue] + [z[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        }
    }
    return (uint)c;
}

// x, y, z == uint[]
+ (uint)addBothTo:(int)len withX:(NSMutableArray *)x withXoff:(int)xOff withY:(NSMutableArray *)y withYoff:(int)yOff withZ:(NSMutableArray *)z withZoff:(int)zOff {
    uint64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[xOff + i] unsignedLongLongValue] + [y[yOff + i] unsignedIntValue] + [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        }
    }
    return (uint)c;
}

// z == uint[]
+ (uint)addDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[zPos + 0] unsignedLongLongValue] + (x & M);
        z[zPos + 0] = @((uint)c);
        c >>= 32;
        c += [z[zPos + 1] unsignedLongLongValue] + (x >> 32);
        z[zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)addDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[zOff + zPos] unsignedLongLongValue] + (x & M);
        z[zOff + zPos] = @((uint)c);
        c >>= 32;
        c += [z[zOff + zPos + 1] unsignedLongLongValue] + (x >> 32);
        z[zOff + zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZoff:zOff withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)addDWordTo:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[0] unsignedLongLongValue] + (x & M);
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] unsignedLongLongValue] + (x >> 32);
        z[1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:2]);
    }
    return retVal;
}

// z == uint[]
- (uint)addDWordTo:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = [z[zOff + 0] unsignedLongLongValue] + (x & M);
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 1] unsignedLongLongValue] + (x >> 32);
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZoff:zOff withZpos:2]);
    }
    return retVal;
}

// x, z == uint[]
+ (uint)addTo:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[i] unsignedLongLongValue] + [z[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        }
    }
    return (uint)c;
}

// x, z == uint[]
+ (uint)addTo:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[xOff + i] unsignedLongLongValue] + [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        }
    }
    return (uint)c;
}

// z == uint[]
+ (uint)addWordAt:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = (uint64_t)x + [z[zPos] unsignedIntValue];
        z[zPos] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:(zPos + 1)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)addWordAt:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = (uint64_t)x + [z[zOff + zPos] unsignedIntValue];
        z[zOff + zPos] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZoff:zOff withZpos:(zPos + 1)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)addWordTo:(int)len withX:(uint)x withZ:(NSMutableArray*)z {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = (uint64_t)x + [z[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:1]);
    }
    return retVal;
}

// z == uint[]
+ (uint)addWordTo:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = (uint64_t)x + [z[zOff] unsignedIntValue];
        z[zOff] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZoff:zOff withZpos:1]);
    }
    return retVal;
}

// x, z == uint[]
+ (void)copy:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    [z copyFromIndex:0 withSource:x withSourceIndex:0 withLength:len];
}

// x == uint[], return == uint[]
+ (NSMutableArray*)copy:(int)len withX:(NSMutableArray *)x {
    NSMutableArray *z = nil;
    @autoreleasepool {
        z = [[NSMutableArray alloc] initWithSize:len];
        [z copyFromIndex:0 withSource:x withSourceIndex:0 withLength:len];
    }
    return (z ? [z autorelease] : nil);
}

// return == uint[]
+ (NSMutableArray*)create:(int)len {
    return [[NSMutableArray alloc] initWithSize:len];
}

// return == uint64_t[]
+ (NSMutableArray*)create64:(int)len {
    return [[NSMutableArray alloc] initWithSize:len];
}

// x == uint[]
+ (int)dec:(int)len withZ:(NSMutableArray*)z {
    for (int i = 0; i < len; ++i) {
        if (([z[i] unsignedIntValue] - 1) != UINT_MAX) {
            return 0;
        }
    }
    return -1;
}

// x, z == uint[]
+ (int)dec:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int i = 0;
        while (i < len) {
            uint c = [x[i] unsignedIntValue] - 1;
            z[i] = @(c);
            ++i;
            if (c != UINT_MAX) {
                while (i < len) {
                    z[i] = x[i];
                    ++i;
                }
                return 0;
            }
        }
        return -1;
    }
}

// z == uint[]
+ (int)decAt:(int)len withZ:(NSMutableArray*)z withZpos:(int)zPos {
    for (int i = zPos; i < len; ++i) {
        if (([z[i] unsignedIntValue] - 1) != UINT_MAX) {
            return 0;
        }
    }
    return -1;
}

// z == uint[]
+ (int)decAt:(int)len withZ:(NSMutableArray *)z withZoff:(int)zOff withZpos:(int)zPos {
    for (int i = zPos; i < len; ++i) {
        if (([z[zOff + i] unsignedIntValue] - 1) != UINT_MAX) {
            return 0;
        }
    }
    return -1;
}

// x, y == uint[]
+ (BOOL)eq:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = len - 1; i >= 0; --i) {
        if ([x[i] unsignedIntValue] != [y[i] unsignedIntValue]) {
            return NO;
        }
    }
    return YES;
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(int)bits withX:(BigInteger*)x {
    if ([x signValue] < 0 || [x bitLength] > bits) {
        @throw [NSException exceptionWithName:@"Argument" reason:nil userInfo:nil];
    }
    
    int len = (bits + 31) >> 5;
    NSMutableArray *z = nil;
    @autoreleasepool {
        z = [Nat create:len];
        int i = 0;
        while ([x signValue] != 0) {
            z[i++] = @((uint)[x intValue]);
            x = [x shiftRightWithN:32];
        }
    }
    return (z ? [z autorelease] : nil);
}

// x == uint[]
+ (uint)getBit:(NSMutableArray*)x withBit:(int)bit {
    if (bit == 0) {
        return [x[0] unsignedIntValue] & 1;
    }
    int w = bit >> 5;
    if (w < 0 || w >= [x count]) {
        return 0;
    }
    int b = bit & 31;
    return ([x[w] unsignedIntValue] >> b) & 1;
}

// x, y == uint[]
+ (BOOL)gte:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = len - 1; i >= 0; --i) {
        uint x_i = [x[i] unsignedIntValue], y_i = [y[i] unsignedIntValue];
        if (x_i < y_i) {
            return NO;
        }
        if (x_i > y_i) {
            return YES;
        }
    }
    return YES;
}

// z == uint[]
+ (uint)inc:(int)len withZ:(NSMutableArray*)z {
    for (int i = 0; i < len; ++i) {
        if (([z[i] unsignedIntValue] + 1) != 0) {
            return 0;
        }
    }
    return 1;
}

// x, z == uint[]
+ (uint)inc:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int i = 0;
        while (i < len) {
            uint c = [x[i] unsignedIntValue] + 1;
            z[i] = @(c);
            ++i;
            if (c != 0) {
                while (i < len) {
                    z[i] = x[i];
                    ++i;
                }
                return 0;
            }
        }
        return 1;
    }
}

// z == uint[]
+ (uint)incAt:(int)len withZ:(NSMutableArray*)z withZpos:(int)zPos {
    for (int i = zPos; i < len; ++i) {
        if (([z[i] unsignedIntValue] + 1) != 0) {
            return 0;
        }
    }
    return 1;
}

// z == uint[]
+ (uint)incAt:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos {
    for (int i = zPos; i < len; ++i) {
        if (([z[zOff + i] unsignedIntValue] + 1) != 0) {
            return 0;
        }
    }
    return 1;
}

// x == uint[]
+ (BOOL)isOne:(int)len withX:(NSMutableArray*)x {
    if ([x[0] unsignedIntValue] != 1) {
        return NO;
    }
    for (int i = 1; i < len; ++i) {
        if ([x[i] unsignedIntValue] != 0) {
            return NO;
        }
    }
    return YES;
}

// x == uint[]
+ (BOOL)isZero:(int)len withX:(NSMutableArray*)x {
    if ([x[0] unsignedIntValue] != 0) {
        return NO;
    }
    for (int i = 1; i < len; ++i) {
        if ([x[i] unsignedIntValue] != 0) {
            return NO;
        }
    }
    return YES;
}

// x, y, zz == uint[]
+ (void)mul:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        zz[len] = @((uint)[Nat mulWord:len withX:[x[0] unsignedIntValue] withY:y withZ:zz]);
        
        for (int i = 1; i < len; ++i) {
            zz[i + len] = @((uint)([Nat mulWordAddTo:len withX:[x[i] unsignedIntValue] withY:y withYoff:0 withZ:zz withZoff:i]));
        }
    }
}

// x, y, zz == uint[]
+ (void)mul:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    @autoreleasepool {
        zz[zzOff + len] = @((uint)[Nat mulWord:len withX:[x[xOff] unsignedIntValue] withY:y withYoff:yOff withZ:zz withZoff:zzOff]);
        for (int i = 1; i < len; ++i) {
            zz[zzOff + i + len] = @((uint)[Nat mulWordAddTo:len withX:[x[xOff + i] unsignedIntValue] withY:y withYoff:yOff withZ:zz withZoff:(zzOff + i)]);
        }
    }
}

// x, y, z == uint[]
+ (uint)mul31BothAdd:(int)len withA:(uint)a withX:(NSMutableArray*)x withB:(uint)b withY:(NSMutableArray*)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, aVal = (uint64_t)a, bVal = (uint64_t)b;
    @autoreleasepool {
        int i = 0;
        do {
            c += aVal * [x[i] unsignedIntValue] + bVal * [y[i] unsignedIntValue] + [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        } while (++i < len);
    }
    return (uint)c;
}

// y, z == uint[]
+ (uint)mulWord:(int)len withX:(uint)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint64_t c = 0, xVal = (uint64_t)x;
    @autoreleasepool {
        int i = 0;
        do {
            c += xVal * [y[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        } while (++i < len);
    }
    return (uint)c;
}

// y, z == uint[]
+ (uint)mulWord:(int)len withX:(uint)x withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, xVal = (uint64_t)x;
    @autoreleasepool {
        int i = 0;
        do {
            c += xVal * [y[yOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        } while (++i < len);
    }
    return (uint)c;
}

// y, z == uint[]
+ (uint)mulWordAddTo:(int)len withX:(uint)x withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, xVal = (uint64_t)x;
    @autoreleasepool {
        int i = 0;
        do {
            c += xVal * [y[yOff + i] unsignedIntValue] + [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        } while (++i < len);
    }
    return (uint)c;
}

// z == uint[]
+ (uint)mulWordDwordAddAt:(int)len withX:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZpos:(int)zPos {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = 0, xVal = (uint64_t)x;
        c += xVal * (uint)y + [z[zPos + 0] unsignedIntValue];
        z[zPos + 0] = @((uint)c);
        c >>= 32;
        c += xVal * (y >> 32) + [z[zPos + 1] unsignedIntValue];
        z[zPos + 1] = @((uint)c);
        c >>= 32;
        c += [z[zPos + 2] unsignedLongLongValue];
        z[zPos + 2] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:len withZ:z withZpos:(zPos + 3)]);
    }
    return retVal;
}

// z == uint[]
+ (uint)shiftDownBit:(int)len withZ:(NSMutableArray*)z withC:(uint)c {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [z[i] unsignedIntValue];
            z[i] = @((uint)((next >> 1) | (c << 31)));
            c = next;
        }
    }
    return c << 31;
}

// z == uint[]
+ (uint)shiftDownBit:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withC:(uint)c {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next >> 1) | (c << 31)));
            c = next;
        }
    }
    return c << 31;
}

// x, z == uint[]
+ (uint)shiftDownBit:(int)len withX:(NSMutableArray*)x withC:(uint)c withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [x[i] unsignedIntValue];
            z[i] = @((uint)((next >> 1) | (c << 31)));
            c = next;
        }
    }
    return c << 31;
}

// x, z == uint[]
+ (uint)shiftDownBit:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withC:(uint)c withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [x[xOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next >> 1) | (c << 31)));
            c = next;
        }
    }
    return c << 31;
}

// z == uint[]
+ (uint)shiftDownBits:(int)len withZ:(NSMutableArray*)z withBits:(int)bits withC:(uint)c {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [z[i] unsignedIntValue];
            z[i] = @((uint)((next >> bits) | (c << -bits)));
            c = next;
        }
    }
    return c << -bits;
}

// z == uint[]
+ (uint)shiftDownBits:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withBits:(int)bits withC:(uint)c {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next >> bits) | (c << -bits)));
            c = next;
        }
    }
    return c << -bits;
}

// x, z == uint[]
+ (uint)shiftDownBits:(int)len withX:(NSMutableArray*)x withBits:(int)bits withC:(uint)c withZ:(NSMutableArray*)z {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [x[i] unsignedIntValue];
            z[i] = @((uint)((next >> bits) | (c << -bits)));
            c = next;
        }
    }
    return c << -bits;
}

// x, z == uint[]
+ (uint)shiftDownBits:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withBits:(int)bits withC:(uint)c withZ:(NSMutableArray *)z withZoff:(int)zOff {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [x[xOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next >> bits) | (c << -bits)));
            c = next;
        }
    }
    return c << -bits;
}

// z == uint[]
+ (uint)shiftDownWord:(int)len withZ:(NSMutableArray*)z withC:(uint)c {
    @autoreleasepool {
        int i = len;
        while (--i >= 0) {
            uint next = [z[i] unsignedIntValue];
            z[i] = @(c);
            c = next;
        }
    }
    return c;
}

// z == uint[]
+ (uint)shiftUpBit:(int)len withZ:(NSMutableArray*)z withC:(uint)c {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [z[i] unsignedIntValue];
            z[i] = @((uint)((next << 1) | (c >> 31)));
            c = next;
        }
    }
    return c >> 31;
}

// z == uint[]
+ (uint)shiftUpBit:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withC:(uint)c {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next << 1) | (c >> 31)));
            c = next;
        }
    }
    return c >> 31;
}

// x, z == uint[]
+ (uint)shiftUpBit:(int)len withX:(NSMutableArray *)x withC:(uint)c withZ:(NSMutableArray*)z {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [x[i] unsignedIntValue];
            z[i] = @((uint)((next << 1) | (c >> 31)));
            c = next;
        }
    }
    return c >> 31;
}

// x, z == uint[]
+ (uint)shiftUpBit:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withC:(uint)c withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [x[xOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next << 1) | (c >> 31)));
            c = next;
        }
    }
    return c >> 31;
}

// x, z == uint64_t[]
+ (uint64_t)shiftUpBit64:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withC:(uint64_t)c withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint64_t next = [x[xOff + i] unsignedLongLongValue];
            z[zOff + i] = @((uint64_t)((next << 1) | (c >> 63)));
            c = next;
        }
    }
    return c >> 63;
}

// z == uint[]
+ (uint)shiftUpBits:(int)len withZ:(NSMutableArray*)z withBits:(int)bits withC:(uint)c {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [z[i] unsignedIntValue];
            z[i] = @((uint)((next << bits) | (c >> -bits)));
            c = next;
        }
    }
    return c >> -bits;
}

// z == uint[]
+ (uint)shiftUpBits:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withBits:(int)bits withC:(uint)c {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [z[zOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next << bits) | (c >> -bits)));
            c = next;
        }
    }
    return c >> -bits;
}

// z == uint64_t[]
+ (uint64_t)shiftUpBits64:(int)len withZ:(NSMutableArray*)z withZoff:(int)zOff withBits:(int)bits withC:(uint64_t)c {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint64_t next = [z[zOff + i] unsignedLongLongValue];
            z[zOff + i] = @((uint64_t)((next << bits) | (c >> -bits)));
            c = next;
        }
    }
    return c >> -bits;
}

// x, z == uint[]
+ (uint)shiftUpBits:(int)len withX:(NSMutableArray*)x withBits:(int)bits withC:(uint)c withZ:(NSMutableArray*)z {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [x[i] unsignedIntValue];
            z[i] = @((uint)((next << bits) | (c >> -bits)));
            c = next;
        }
    }
    return c >> -bits;
}

// x, z == uint[]
+ (uint)shiftUpBits:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withBits:(int)bits withC:(uint)c withZ:(NSMutableArray *)z withZoff:(int)zOff {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint next = [x[xOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)((next << bits) | (c >> -bits)));
            c = next;
        }
    }
    return c >> -bits;
}

// x, z == uint64_t[]
+ (uint64_t)shiftUpBits64:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withBits:(int)bits withC:(uint64_t)c withZ:(NSMutableArray*)z withZoff:(int)zOff {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            uint64_t next = [x[xOff + i] unsignedLongLongValue];
            z[zOff + i] = @((uint64_t)((next << bits) | (c >> -bits)));
            c = next;
        }
    }
    return c >> -bits;
}

// x, zz == uint[]
+ (void)square:(int)len withX:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        int extLen = len << 1;
        uint c = 0;
        int j = len, k = extLen;
        do {
            uint64_t xVal = [x[--j] unsignedLongLongValue];
            uint64_t p = xVal * xVal;
            zz[--k] = @((uint)((c << 31) | (uint)(p >> 33)));
            zz[--k] = @((uint)(p >> 1));
            c = (uint)p;
        } while (j > 0);
        
        for (int i = 1; i < len; ++i) {
            c = [Nat squareWordAdd:x withXpos:i withZ:zz];
            [Nat addWordAt:extLen withX:c withZ:zz withZpos:(i << 1)];
        }
        
        [Nat shiftUpBit:extLen withZ:zz withC:([x[0] unsignedIntValue] << 31)];
    }
}

// x, zz == uint[]
+ (void)square:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    @autoreleasepool {
        int extLen = len << 1;
        uint c = 0;
        int j = len, k = extLen;
        do {
            uint64_t xVal = [x[xOff + --j] unsignedLongLongValue];
            uint64_t p = xVal * xVal;
            zz[zzOff + --k] = @((uint)((c << 31) | (uint)(p >> 33)));
            zz[zzOff + --k] = @((uint)(p >> 1));
            c = (uint)p;
        } while (j > 0);
        
        for (int i = 1; i < len; ++i) {
            c = [Nat squareWordAdd:x withXoff:xOff withXpos:i withZ:zz withZoff:zzOff];
            [Nat addWordAt:extLen withX:c withZ:zz withZoff:zzOff withZpos:(i << 1)];
        }
        
        [Nat shiftUpBit:extLen withZ:zz withZoff:zzOff withC:([x[xOff] unsignedIntValue] << 31)];
    }
}

// x, z == uint[]
+ (uint)squareWordAdd:(NSMutableArray*)x withXpos:(int)xPos withZ:(NSMutableArray*)z {
    uint64_t c = 0, xVal = [x[xPos] unsignedLongLongValue];
    @autoreleasepool {
        int i = 0;
        do {
            c += xVal * [x[i] unsignedIntValue] + [z[xPos + i] unsignedIntValue];
            z[xPos + i] = @((uint)c);
            c >>= 32;
        }
        while (++i < xPos);
    }
    return (uint)c;
}

// x, z == uint[]
+ (uint)squareWordAdd:(NSMutableArray*)x withXoff:(int)xOff withXpos:(int)xPos withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, xVal = [x[xOff + xPos] unsignedLongLongValue];
    @autoreleasepool {
        int i = 0;
        do {
            c += xVal * ([x[xOff + i] unsignedIntValue] & M) + ([z[xPos + zOff] unsignedIntValue] & M);
            z[xPos + zOff] = @((uint)c);
            c >>= 32;
            ++zOff;
        } while (++i < xPos);
    }
    return (uint)c;
}

// x, y, z == uint[]
+ (int)sub:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[i] longLongValue] - [y[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        }
    }
    return (int)c;
}

// x, y, z == uint[]
+ (int)sub:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [x[xOff + i] longLongValue] - [y[yOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        }
    }
    return (int)c;
}

// z == uint[]
+ (int)sub33At:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zPos + 0] longLongValue] - x;
        z[zPos + 0] = @((uint)c);
        c >>= 32;
        c += [z[zPos + 1] longLongValue] - 1;
        z[zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (int)sub33At:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zOff + zPos] longLongValue] - x;
        z[zOff + zPos] = @((uint)c);
        c >>= 32;
        c += [z[zOff + zPos + 1] longLongValue] - 1;
        z[zOff + zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZoff:zOff withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (int)sub33From:(int)len withX:(uint)x withZ:(NSMutableArray*)z {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - x;
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] longLongValue] - 1;
        z[1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZpos:2]);
    }
    return retVal;
}

// z == uint[]
+ (int)sub33From:(int)len withX:(uint)x withZ:(NSMutableArray *)z withZoff:(int)zOff {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zOff + 0] longLongValue] - x;
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 1] longLongValue] - 1;
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZoff:zOff withZpos:2]);
    }
    return retVal;
}

// x, y, z == uint[]
+ (int)subBothFrom:(int)len withX:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [z[i] longLongValue] - [x[i] unsignedIntValue] - [y[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        }
    }
    return (int)c;
}

// x, y, z == uint[]
+ (int)subBothFrom:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [z[zOff + i] longLongValue] - [x[xOff + i] unsignedIntValue] - [y[yOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        }
    }
    return (int)c;
}

// z == uint[]
+ (int)subDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZpos:(int)zPos {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zPos + 0] longLongValue] - (int64_t)(x & M);
        z[zPos + 0] = @((uint)c);
        c >>= 32;
        c += [z[zPos + 1] longLongValue] - (int64_t)(x >> 32);
        z[zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (int)subDWordAt:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zOff + zPos] longLongValue] - (int64_t)(x & M);
        z[zOff + zPos] = @((uint)c);
        c >>= 32;
        c += [z[zOff + zPos + 1] longLongValue] - (int64_t)(x >> 32);
        z[zOff + zPos + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZoff:zOff withZpos:(zPos + 2)]);
    }
    return retVal;
}

// z == uint[]
+ (int)subDWordFrom:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - (int64_t)(x & M);
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] longLongValue] - (int64_t)(x >> 32);
        z[1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZpos:2]);
    }
    return retVal;
}

// z == uint[]
+ (int)subDWordFrom:(int)len withX:(uint64_t)x withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zOff + 0] longLongValue] - (int64_t)(x & M);
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 1] longLongValue] - (int64_t)(x >> 32);
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZoff:zOff withZpos:2]);
    }
    return retVal;
}

// x, z == uint[]
+ (int)subFrom:(int)len withX:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [z[i] longLongValue] - [x[i] unsignedIntValue];
            z[i] = @((uint)c);
            c >>= 32;
        }
    }
    return (int)c;
}

// x, z == uint[]
+ (int)subFrom:(int)len withX:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int64_t c = 0;
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            c += [z[zOff + i] longLongValue] - [x[xOff + i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        }
    }
    return (int)c;
}

// z == uint[]
+ (int)subWordAt:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZpos:(int)zPos {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zPos] longLongValue] - x;
        z[zPos] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZpos:(zPos + 1)]);
    }
    return retVal;
}

// z == uint[]
+ (int)subWordAt:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZoff:(int)zOff withZpos:(int)zPos {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zOff + zPos] longLongValue] - x;
        z[zOff + zPos] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZoff:zOff withZpos:(zPos + 1)]);
    }
    return retVal;
}

// z == uint[]
+ (int)subWordFrom:(int)len withX:(uint)x withZ:(NSMutableArray*)z {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[0] longLongValue] - x;
        z[0] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZpos:1]);
    }
    return retVal;
}

// z == uint[]
+ (int)subWordFrom:(int)len withX:(uint)x withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int retVal = 0;
    @autoreleasepool {
        int64_t c = [z[zOff + 0] longLongValue] - x;
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat decAt:len withZ:z withZoff:zOff withZpos:1]);
    }
    return retVal;
}

// x == uint[]
+ (BigInteger*)toBigInteger:(int)len withX:(NSMutableArray*)x {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableData *bs = [[NSMutableData alloc] initWithSize:(len << 2)];
        for (int i = 0; i < len; ++i) {
            uint x_i = [x[i] unsignedIntValue];
            if (x_i != 0) {
                [Pack UInt32_To_BE:x_i withBs:bs withOff:((len - 1 - i) << 2)];
            }
        }
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:bs];
#if !__has_feature(objc_arc)
        if (bs != nil) [bs release]; bs = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

// z == uint[]
+ (void)zero:(int)len withZ:(NSMutableArray*)z {
    @autoreleasepool {
        for (int i = 0; i < len; ++i) {
            z[i] = @((uint)0);
        }
    }
}

@end
