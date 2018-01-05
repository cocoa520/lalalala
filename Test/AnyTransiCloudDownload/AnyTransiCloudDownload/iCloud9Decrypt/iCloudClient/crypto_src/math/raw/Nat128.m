//
//  Nat128.m
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import "Nat128.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat.h"
#import "Pack.h"

@implementation Nat128

static uint64_t const M = 0xFFFFFFFFUL;

// NSMutableArray == uint[]
+ (uint)add:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint64_t c = 0;
    @autoreleasepool {
        c += [x[0] unsignedLongLongValue] + [y[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += [x[1] unsignedLongLongValue] + [y[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += [x[2] unsignedLongLongValue] + [y[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += [x[3] unsignedLongLongValue] + [y[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)addBothTo:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint64_t c = 0;
    @autoreleasepool {
        c += [x[0] unsignedLongLongValue] + [y[0] unsignedIntValue] + [z[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += [x[1] unsignedLongLongValue] + [y[1] unsignedIntValue] + [z[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += [x[2] unsignedLongLongValue] + [y[2] unsignedIntValue] + [z[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += [x[3] unsignedLongLongValue] + [y[3] unsignedIntValue] + [z[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)addTo:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint64_t c = 0;
    @autoreleasepool {
        c += [x[0] unsignedLongLongValue] + [z[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += [x[1] unsignedLongLongValue] + [z[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += [x[2] unsignedLongLongValue] + [z[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += [x[3] unsignedLongLongValue] + [z[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)addTo:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff withCin:(uint)cIn {
    uint64_t c = cIn;
    @autoreleasepool {
        c += [x[xOff + 0] unsignedLongLongValue] + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 1] unsignedLongLongValue] + [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 2] unsignedLongLongValue] + [z[zOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 3] unsignedLongLongValue] + [z[zOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)addToEachOther:(NSMutableArray*)u withUoff:(int)uOff withV:(NSMutableArray*)v withVoff:(int)vOff {
    uint64_t c = 0;
    @autoreleasepool {
        c += [u[uOff + 0] unsignedLongLongValue] + [v[vOff + 0] unsignedIntValue];
        u[uOff + 0] = @((uint)c);
        v[vOff + 0] = @((uint)c);
        c >>= 32;
        c += [u[uOff + 1] unsignedLongLongValue] + [v[vOff + 1] unsignedIntValue];
        u[uOff + 1] = @((uint)c);
        v[vOff + 1] = @((uint)c);
        c >>= 32;
        c += [u[uOff + 2] unsignedLongLongValue] + [v[vOff + 2] unsignedIntValue];
        u[uOff + 2] = @((uint)c);
        v[vOff + 2] = @((uint)c);
        c >>= 32;
        c += [u[uOff + 3] unsignedLongLongValue] + [v[vOff + 3] unsignedIntValue];
        u[uOff + 3] = @((uint)c);
        v[vOff + 3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (void)copy:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    z[0] = x[0];
    z[1] = x[1];
    z[2] = x[2];
    z[3] = x[3];
}

// NSMutableArray == uint64_t[]
+ (void)copy64:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    z[0] = x[0];
    z[1] = x[1];
}

// return == uint[4]
+ (NSMutableArray*)create {
    return [[NSMutableArray alloc] initWithSize:4];
}

// return == uint64_t[2]
+ (NSMutableArray*)create64 {
    return [[NSMutableArray alloc] initWithSize:2];
}

// return == uint[8]
+ (NSMutableArray*)createExt {
    return [[NSMutableArray alloc] initWithSize:8];
}

// return == uint64_t[4]
+ (NSMutableArray*)createExt64 {
    return [[NSMutableArray alloc] initWithSize:4];
}

// NSMutableArray == uint[]
+ (BOOL)diff:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    BOOL pos = [Nat128 gte:x withXoff:xOff withY:y withYoff:yOff];
    if (pos) {
        [Nat128 sub:x withXoff:xOff withY:y withYoff:yOff withZ:z withZoff:zOff];
    } else {
        [Nat128 sub:y withXoff:yOff withY:x withYoff:xOff withZ:z withZoff:zOff];
    }
    return pos;
}

// NSMutableArray == uint[]
+ (BOOL)eq:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = 3; i >= 0; --i) {
        if ([x[i] unsignedIntValue] != [y[i] unsignedIntValue]) {
            return NO;
        }
    }
    return YES;
}

// NSMutableArray == uint64_t[]
+ (BOOL)eq64:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = 1; i >= 0; --i) {
        if ([x[i] unsignedLongLongValue] != [y[i] unsignedLongLongValue]) {
            return NO;
        }
    }
    return YES;
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    if ([x signValue] < 0 || [x bitLength] > 128) {
        @throw [NSException exceptionWithName:@"Argument" reason:nil userInfo:nil];
    }
    
    NSMutableArray *z = nil;
    @autoreleasepool {
        z = [Nat128 create];
        int i = 0;
        while ([x signValue] != 0) {
            z[i++] = @((uint)[x intValue]);
            x = [x shiftRightWithN:32];
        }
    }
    return (z ? [z autorelease] : nil);
}

// return == uint64_t[]
+ (NSMutableArray*)fromBigInteger64:(BigInteger*)x {
    if ([x signValue] < 0 || [x bitLength] > 128) {
        @throw [NSException exceptionWithName:@"Argument" reason:nil userInfo:nil];
    }
    
    NSMutableArray *z = nil;
    @autoreleasepool {
        z = [Nat128 create64];
        int i = 0;
        while ([x signValue] != 0) {
            z[i++] = @((uint64_t)[x longValue]);
            x = [x shiftRightWithN:64];
        }
    }
    return (z ? [z autorelease] : nil);
}

// NSMutableArray == uint[]
+ (uint)getBit:(NSMutableArray*)x withBit:(int)bit {
    if (bit == 0) {
        return [x[0] unsignedIntValue] & 1;
    }
    if ((bit & 127) != bit) {
        return 0;
    }
    int w = bit >> 5;
    int b = bit & 31;
    return ([x[w] unsignedIntValue] >> b) & 1;
}

// NSMutableArray == uint[]
+ (BOOL)gte:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = 3; i >= 0; --i) {
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

// NSMutableArray == uint[]
+ (BOOL)gte:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff {
    for (int i = 3; i >= 0; --i) {
        uint x_i = [x[xOff + i] unsignedIntValue], y_i = [y[yOff + i] unsignedIntValue];
        if (x_i < y_i) {
            return NO;
        }
        if (x_i > y_i) {
            return YES;
        }
    }
    return YES;
}

// NSMutableArray == uint[]
+ (BOOL)isOne:(NSMutableArray*)x {
    if ([x[0] unsignedIntValue] != 1) {
        return NO;
    }
    for (int i = 1; i < 4; ++i) {
        if ([x[i] unsignedIntValue] != 0) {
            return NO;
        }
    }
    return YES;
}

// NSMutableArray == uint64_t[]
+ (BOOL)isOne64:(NSMutableArray*)x {
    if ([x[0] unsignedLongLongValue] != 1UL) {
        return NO;
    }
    for (int i = 1; i < 2; ++i) {
        if ([x[i] unsignedLongLongValue] != 0UL) {
            return NO;
        }
    }
    return YES;
}

// NSMutableArray == uint[]
+ (BOOL)isZero:(NSMutableArray*)x {
    for (int i = 0; i < 4; ++i) {
        if ([x[i] unsignedLongLongValue] != 0) {
            return NO;
        }
    }
    return YES;
}

// NSMutableArray == uint64_t[]
+ (BOOL)isZero64:(NSMutableArray*)x {
    for (int i = 0; i < 2; ++i) {
        if ([x[i] unsignedLongLongValue] != 0UL) {
            return NO;
        }
    }
    return YES;
}

// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t y_0 = [y[0] unsignedLongLongValue];
        uint64_t y_1 = [y[1] unsignedLongLongValue];
        uint64_t y_2 = [y[2] unsignedLongLongValue];
        uint64_t y_3 = [y[3] unsignedLongLongValue];
        
        {
            uint64_t c = 0, x_0 = [x[0] unsignedLongLongValue];
            c += x_0 * y_0;
            zz[0] = @((uint)c);
            c >>= 32;
            c += x_0 * y_1;
            zz[1] = @((uint)c);
            c >>= 32;
            c += x_0 * y_2;
            zz[2] = @((uint)c);
            c >>= 32;
            c += x_0 * y_3;
            zz[3] = @((uint)c);
            c >>= 32;
            zz[4] = @((uint)c);
        }
        
        for (int i = 1; i < 4; ++i) {
            uint64_t c = 0, x_i = [x[i] unsignedLongLongValue];
            c += x_i * y_0 + [zz[i + 0] unsignedIntValue];
            zz[i + 0] = @((uint)c);
            c >>= 32;
            c += x_i * y_1 + [zz[i + 1] unsignedIntValue];
            zz[i + 1] = @((uint)c);
            c >>= 32;
            c += x_i * y_2 + [zz[i + 2] unsignedIntValue];
            zz[i + 2] = @((uint)c);
            c >>= 32;
            c += x_i * y_3 + [zz[i + 3] unsignedIntValue];
            zz[i + 3] = @((uint)c);
            c >>= 32;
            zz[i + 4] = @((uint)c);
        }
    }
}

// NSMutableArray == uint[]
+ (void)mul:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    @autoreleasepool {
        uint64_t y_0 = [y[yOff + 0] unsignedLongLongValue];
        uint64_t y_1 = [y[yOff + 1] unsignedLongLongValue];
        uint64_t y_2 = [y[yOff + 2] unsignedLongLongValue];
        uint64_t y_3 = [y[yOff + 3] unsignedLongLongValue];
        
        {
            uint64_t c = 0, x_0 = [x[xOff + 0] unsignedLongLongValue];
            c += x_0 * y_0;
            zz[zzOff + 0] = @((uint)c);
            c >>= 32;
            c += x_0 * y_1;
            zz[zzOff + 1] = @((uint)c);
            c >>= 32;
            c += x_0 * y_2;
            zz[zzOff + 2] = @((uint)c);
            c >>= 32;
            c += x_0 * y_3;
            zz[zzOff + 3] = @((uint)c);
            c >>= 32;
            zz[zzOff + 4] = @((uint)c);
        }
        
        for (int i = 1; i < 4; ++i) {
            ++zzOff;
            uint64_t c = 0, x_i = [x[xOff + i] unsignedLongLongValue];
            c += x_i * y_0 + [zz[zzOff + 0] unsignedIntValue];
            zz[zzOff + 0] = @((uint)c);
            c >>= 32;
            c += x_i * y_1 + [zz[zzOff + 1] unsignedIntValue];
            zz[zzOff + 1] = @((uint)c);
            c >>= 32;
            c += x_i * y_2 + [zz[zzOff + 2] unsignedIntValue];
            zz[zzOff + 2] = @((uint)c);
            c >>= 32;
            c += x_i * y_3 + [zz[zzOff + 3] unsignedIntValue];
            zz[zzOff + 3] = @((uint)c);
            c >>= 32;
            zz[zzOff + 4] = @((uint)c);
        }
    }
}

// NSMutableArray == uint[]
+ (uint)mulAddTo:(NSMutableArray*)x withY:(NSMutableArray*)y withZZ:(NSMutableArray*)zz {
    uint64_t zc = 0;
    @autoreleasepool {
        uint64_t y_0 = [y[0] unsignedLongLongValue];
        uint64_t y_1 = [y[1] unsignedLongLongValue];
        uint64_t y_2 = [y[2] unsignedLongLongValue];
        uint64_t y_3 = [y[3] unsignedLongLongValue];
        
        for (int i = 0; i < 4; ++i) {
            uint64_t c = 0, x_i = [x[i] unsignedLongLongValue];
            c += x_i * y_0 + [zz[i + 0] unsignedIntValue];
            zz[i + 0] = @((uint)c);
            c >>= 32;
            c += x_i * y_1 + [zz[i + 1] unsignedIntValue];
            zz[i + 1] = @((uint)c);
            c >>= 32;
            c += x_i * y_2 + [zz[i + 2] unsignedIntValue];
            zz[i + 2] = @((uint)c);
            c >>= 32;
            c += x_i * y_3 + [zz[i + 3] unsignedIntValue];
            zz[i + 3] = @((uint)c);
            c >>= 32;
            c += zc + [zz[i + 4] unsignedIntValue];
            zz[i + 4] = @((uint)c);
            zc = c >> 32;
        }
    }
    return (uint)zc;
}

// NSMutableArray == uint[]
+ (uint)mulAddTo:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    uint64_t zc = 0;
    @autoreleasepool {
        uint64_t y_0 = [y[yOff + 0] unsignedLongLongValue];
        uint64_t y_1 = [y[yOff + 1] unsignedLongLongValue];
        uint64_t y_2 = [y[yOff + 2] unsignedLongLongValue];
        uint64_t y_3 = [y[yOff + 3] unsignedLongLongValue];
        
        for (int i = 0; i < 4; ++i) {
            uint64_t c = 0, x_i = [x[xOff + i] unsignedLongLongValue];
            c += x_i * y_0 + [zz[zzOff + 0] unsignedIntValue];
            zz[zzOff + 0] = @((uint)c);
            c >>= 32;
            c += x_i * y_1 + [zz[zzOff + 1] unsignedIntValue];
            zz[zzOff + 1] = @((uint)c);
            c >>= 32;
            c += x_i * y_2 + [zz[zzOff + 2] unsignedIntValue];
            zz[zzOff + 2] = @((uint)c);
            c >>= 32;
            c += x_i * y_3 + [zz[zzOff + 3] unsignedIntValue];
            zz[zzOff + 3] = @((uint)c);
            c >>= 32;
            c += zc + [zz[zzOff + 4] unsignedIntValue];
            zz[zzOff + 4] = @((uint)c);
            zc = c >> 32;
            ++zzOff;
        }
    }
    return (uint)zc;
}

// NSMutableArray == uint[]
+ (uint64_t)mul33Add:(uint)w withX:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, wVal = w;
    @autoreleasepool {
        uint64_t x0 = [x[xOff + 0] unsignedLongLongValue];
        c += wVal * x0 + [y[yOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        uint64_t x1 = [x[xOff + 1] unsignedLongLongValue];
        c += wVal * x1 + x0 + [y[yOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        uint64_t x2 = [x[xOff + 2] unsignedLongLongValue];
        c += wVal * x2 + x1 + [y[yOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        uint64_t x3 = [x[xOff + 3] unsignedLongLongValue];
        c += wVal * x3 + x2 + [y[yOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
        c += x3;
    }
    return c;
}

// NSMutableArray == uint[]
+ (uint)mulWordAddExt:(uint)x withYY:(NSMutableArray*)yy withYYoff:(int)yyOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    uint64_t c = 0, xVal = x;
    @autoreleasepool {
        c += xVal * [yy[yyOff + 0] unsignedIntValue] + [zz[zzOff + 0] unsignedIntValue];
        zz[zzOff + 0] = @((uint)c);
        c >>= 32;
        c += xVal * [yy[yyOff + 1] unsignedIntValue] + [zz[zzOff + 1] unsignedIntValue];
        zz[zzOff + 1] = @((uint)c);
        c >>= 32;
        c += xVal * [yy[yyOff + 2] unsignedIntValue] + [zz[zzOff + 2] unsignedIntValue];
        zz[zzOff + 2] = @((uint)c);
        c >>= 32;
        c += xVal * [yy[yyOff + 3] unsignedIntValue] + [zz[zzOff + 3] unsignedIntValue];
        zz[zzOff + 3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)mul33DWordAdd:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, xVal = x;
    @autoreleasepool {
        uint64_t y00 = y & M;
        c += xVal * y00 + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        uint64_t y01 = y >> 32;
        c += xVal * y01 + y00 + [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += y01 + [z[zOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)mul33WordAdd:(uint)x withY:(uint)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = 0, yVal = y;
        c += yVal * x + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += yVal + [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:4 withZ:z withZoff:zOff withZpos:3]);
    }
    
    return retVal;
}

// NSMutableArray == uint[]
+ (uint)mulWordDwordAdd:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = 0, xVal = x;
        c += xVal * y + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += xVal * (y >> 32) + [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:4 withZ:z withZoff:zOff withZpos:3]);
    }
    return retVal;
}

// NSMutableArray == uint[]
+ (uint)mulWordsAdd:(uint)x withY:(uint)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = 0, xVal = x, yVal = y;
        c += yVal * xVal + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        retVal = (c == 0 ? 0 : [Nat incAt:4 withZ:z withZoff:zOff withZpos:2]);
    }
    return retVal;
}

// NSMutableArray == uint[]
+ (uint)mulWord:(uint)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, xVal = x;
    @autoreleasepool {
        int i = 0;
        do {
            c += xVal * [y[i] unsignedIntValue];
            z[zOff + i] = @((uint)c);
            c >>= 32;
        } while (++i < 4);
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withZZ:(NSMutableArray*)zz {
    @autoreleasepool {
        uint64_t x_0 = [x[0] unsignedLongLongValue];
        uint64_t zz_1;
        
        uint c = 0, w;
        {
            int i = 3, j = 8;
            do {
                uint64_t xVal = [x[i--] unsignedLongLongValue];
                uint64_t p = xVal * xVal;
                zz[--j] = @((c << 31) | (uint)(p >> 33));
                zz[--j] = @((uint)(p >> 1));
                c = (uint)p;
            } while (i > 0);
            
            {
                uint64_t p = x_0 * x_0;
                zz_1 = (uint64_t)(c << 31) | (p >> 33);
                zz[0] = @((uint)p);
                c = (uint)(p >> 32) & 1;
            }
        }
        
        uint64_t x_1 = [x[1] unsignedLongLongValue];
        uint64_t zz_2 = [zz[2] unsignedLongLongValue];
        
        {
            zz_1 += x_1 * x_0;
            w = (uint)zz_1;
            zz[1] = @((w << 1) | c);
            c = w >> 31;
            zz_2 += zz_1 >> 32;
        }
        
        uint64_t x_2 = [x[2] unsignedLongLongValue];
        uint64_t zz_3 = [zz[3] unsignedLongLongValue];
        uint64_t zz_4 = [zz[4] unsignedLongLongValue];
        {
            zz_2 += x_2 * x_0;
            w = (uint)zz_2;
            zz[2] = @((w << 1) | c);
            c = w >> 31;
            zz_3 += (zz_2 >> 32) + x_2 * x_1;
            zz_4 += zz_3 >> 32;
            zz_3 &= M;
        }
        
        uint64_t x_3 = [x[3] unsignedLongLongValue];
        uint64_t zz_5 = [zz[5] unsignedLongLongValue];
        uint64_t zz_6 = [zz[6] unsignedLongLongValue];
        {
            zz_3 += x_3 * x_0;
            w = (uint)zz_3;
            zz[3] = @((w << 1) | c);
            c = w >> 31;
            zz_4 += (zz_3 >> 32) + x_3 * x_1;
            zz_5 += (zz_4 >> 32) + x_3 * x_2;
            zz_6 += zz_5 >> 32;
        }
        
        w = (uint)zz_4;
        zz[4] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_5;
        zz[5] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_6;
        zz[6] = @((w << 1) | c);
        c = w >> 31;
        w = [zz[7] unsignedIntValue] + (uint)(zz_6 >> 32);
        zz[7] = @((w << 1) | c);
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withXoff:(int)xOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    @autoreleasepool {
        uint64_t x_0 = [x[xOff + 0] unsignedLongLongValue];
        uint64_t zz_1;
        
        uint c = 0, w;
        {
            int i = 3, j = 8;
            do {
                uint64_t xVal = [x[xOff + i--] unsignedLongLongValue];
                uint64_t p = xVal * xVal;
                zz[zzOff + --j] = @((c << 31) | (uint)(p >> 33));
                zz[zzOff + --j] = @((uint)(p >> 1));
                c = (uint)p;
            } while (i > 0);
            
            {
                uint64_t p = x_0 * x_0;
                zz_1 = (uint64_t)(c << 31) | (p >> 33);
                zz[zzOff + 0] = @((uint)p);
                c = (uint)(p >> 32) & 1;
            }
        }
        
        uint64_t x_1 = [x[xOff + 1] unsignedLongLongValue];
        uint64_t zz_2 = [zz[zzOff + 2] unsignedLongLongValue];
        
        {
            zz_1 += x_1 * x_0;
            w = (uint)zz_1;
            zz[zzOff + 1] = @((w << 1) | c);
            c = w >> 31;
            zz_2 += zz_1 >> 32;
        }
        
        uint64_t x_2 = [x[xOff + 2] unsignedLongLongValue];
        uint64_t zz_3 = [zz[zzOff + 3] unsignedLongLongValue];
        uint64_t zz_4 = [zz[zzOff + 4] unsignedLongLongValue];
        {
            zz_2 += x_2 * x_0;
            w = (uint)zz_2;
            zz[zzOff + 2] = @((w << 1) | c);
            c = w >> 31;
            zz_3 += (zz_2 >> 32) + x_2 * x_1;
            zz_4 += zz_3 >> 32;
            zz_3 &= M;
        }
        
        uint64_t x_3 = [x[xOff + 3] unsignedLongLongValue];
        uint64_t zz_5 = [zz[zzOff + 5] unsignedLongLongValue];
        uint64_t zz_6 = [zz[zzOff + 6] unsignedLongLongValue];
        {
            zz_3 += x_3 * x_0;
            w = (uint)zz_3;
            zz[zzOff + 3] = @((w << 1) | c);
            c = w >> 31;
            zz_4 += (zz_3 >> 32) + x_3 * x_1;
            zz_5 += (zz_4 >> 32) + x_3 * x_2;
            zz_6 += zz_5 >> 32;
        }
        
        w = (uint)zz_4;
        zz[zzOff + 4] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_5;
        zz[zzOff + 5] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_6;
        zz[zzOff + 6] = @((w << 1) | c);
        c = w >> 31;
        w = [zz[zzOff + 7] unsignedIntValue] + (uint)(zz_6 >> 32);
        zz[zzOff + 7] = @((w << 1) | c);
    }
}

// NSMutableArray == uint[]
+ (int)sub:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        c += [x[0] longLongValue] - [y[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += [x[1] longLongValue] - [y[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += [x[2] longLongValue] - [y[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += [x[3] longLongValue] - [y[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
    }
    return (int)c;
}

// NSMutableArray == uint[]
+ (int)sub:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int64_t c = 0;
    @autoreleasepool {
        c += [x[xOff + 0] longLongValue] - [y[yOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 1] longLongValue] - [y[yOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 2] longLongValue] - [y[yOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 3] longLongValue] - [y[yOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
    }
    
    return (int)c;
}

// NSMutableArray == uint[]
+ (int)subBothFrom:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        c += [z[0] longLongValue] - [x[0] unsignedIntValue] - [y[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] longLongValue] - [x[1] unsignedIntValue] - [y[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += [z[2] longLongValue] - [x[2] unsignedIntValue] - [y[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += [z[3] longLongValue] - [x[3] unsignedIntValue] - [y[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
    }
    return (int)c;
}

// NSMutableArray == uint[]
+ (int)subFrom:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    int64_t c = 0;
    @autoreleasepool {
        c += [z[0] longLongValue] - [x[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += [z[1] longLongValue] - [x[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += [z[2] longLongValue] - [x[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += [z[3] longLongValue] - [x[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
    }
    return (int)c;
}

// NSMutableArray == uint[]
+ (int)subFrom:(NSMutableArray*)x withXoff:(int)xOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    int64_t c = 0;
    @autoreleasepool {
        c += [z[zOff + 0] longLongValue] - [x[xOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 1] longLongValue] - [x[xOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 2] longLongValue] - [x[xOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 3] longLongValue] - [x[xOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
    }
    return (int)c;
}

// NSMutableArray == uint[]
+ (BigInteger*)toBigInteger:(NSMutableArray*)x {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableData *bs = [[NSMutableData alloc] initWithSize:16];
        for (int i = 0; i < 4; ++i) {
            uint x_i = [x[i] unsignedIntValue];
            if (x_i != 0) {
                [Pack UInt32_To_BE:x_i withBs:bs withOff:((3 - i) << 2)];
            }
        }
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:bs];
#if !__has_feature(objc_arc)
        if (bs != nil) [bs release]; bs = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

// NSMutableArray == uint64_t[]
+ (BigInteger*)toBigInteger64:(NSMutableArray*)x {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableData *bs = [[NSMutableData alloc] initWithSize:16];
        for (int i = 0; i < 2; ++i) {
            uint64_t x_i = [x[i] unsignedLongLongValue];
            if (x_i != 0UL) {
                [Pack UInt64_To_BE:x_i withBs:bs withOff:((1 - i) << 3)];
            }
        }
        retVal = [[BigInteger alloc] initWithSign:1 withBytes:bs];
#if !__has_feature(objc_arc)
        if (bs != nil) [bs release]; bs = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

// NSMutableArray == uint[]
+ (void)zero:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @((uint)0);
        z[1] = @((uint)0);
        z[2] = @((uint)0);
        z[3] = @((uint)0);
    }
}

@end
