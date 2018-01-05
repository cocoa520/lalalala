//
//  Nat224.m
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import "Nat224.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Nat.h"
#import "Pack.h"

@implementation Nat224

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
        c += [x[4] unsignedLongLongValue] + [y[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += [x[5] unsignedLongLongValue] + [y[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += [x[6] unsignedLongLongValue] + [y[6] unsignedIntValue];
        z[6] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)add:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0;
    @autoreleasepool {
        c += [x[xOff + 0] unsignedLongLongValue] + [y[yOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 1] unsignedLongLongValue] + [y[yOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 2] unsignedLongLongValue] + [y[yOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 3] unsignedLongLongValue] + [y[yOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 4] unsignedLongLongValue] + [y[yOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 5] unsignedLongLongValue] + [y[yOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 6] unsignedLongLongValue] + [y[yOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
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
        c += [x[4] unsignedLongLongValue] + [y[4] unsignedIntValue] + [z[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += [x[5] unsignedLongLongValue] + [y[5] unsignedIntValue] + [z[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += [x[6] unsignedLongLongValue] + [y[6] unsignedIntValue] + [z[6] unsignedIntValue];
        z[6] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)addBothTo:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0;
    @autoreleasepool {
        c += [x[xOff + 0] unsignedLongLongValue] + [y[yOff + 0] unsignedIntValue] + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 1] unsignedLongLongValue] + [y[yOff + 1] unsignedIntValue] + [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 2] unsignedLongLongValue] + [y[yOff + 2] unsignedIntValue] + [z[zOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 3] unsignedLongLongValue] + [y[yOff + 3] unsignedIntValue] + [z[zOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 4] unsignedLongLongValue] + [y[yOff + 4] unsignedIntValue] + [z[zOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 5] unsignedLongLongValue] + [y[yOff + 5] unsignedIntValue] + [z[zOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 6] unsignedLongLongValue] + [y[yOff + 6] unsignedIntValue] + [z[zOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
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
        c += [x[4] unsignedLongLongValue] + [z[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += [x[5] unsignedLongLongValue] + [z[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += [x[6] unsignedLongLongValue] + [z[6] unsignedIntValue];
        z[6] = @((uint)c);
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
        c += [x[xOff + 4] unsignedLongLongValue] + [z[zOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 5] unsignedLongLongValue] + [z[zOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 6] unsignedLongLongValue] + [z[zOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
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
        c += [u[uOff + 4] unsignedLongLongValue] + [v[vOff + 4] unsignedIntValue];
        u[uOff + 4] = @((uint)c);
        v[vOff + 4] = @((uint)c);
        c >>= 32;
        c += [u[uOff + 5] unsignedLongLongValue] + [v[vOff + 5] unsignedIntValue];
        u[uOff + 5] = @((uint)c);
        v[vOff + 5] = @((uint)c);
        c >>= 32;
        c += [u[uOff + 6] unsignedLongLongValue] + [v[vOff + 6] unsignedIntValue];
        u[uOff + 6] = @((uint)c);
        v[vOff + 6] = @((uint)c);
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
    z[4] = x[4];
    z[5] = x[5];
    z[6] = x[6];
}

// return == uint[7]
+ (NSMutableArray*)create {
    return [[NSMutableArray alloc] initWithSize:7];
}

// return == uint[14]
+ (NSMutableArray*)createExt {
    return [[NSMutableArray alloc] initWithSize:14];
}

// NSMutableArray == uint[]
+ (BOOL)diff:(NSMutableArray*)x withXoff:(int)xOff withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    BOOL pos = [Nat224 gte:x withXoff:xOff withY:y withYoff:yOff];
    if (pos) {
        [Nat224 sub:x withXoff:xOff withY:y withYoff:yOff withZ:z withZoff:zOff];
    } else {
        [Nat224 sub:y withXoff:yOff withY:x withYoff:xOff withZ:z withZoff:zOff];
    }
    return pos;
}

// NSMutableArray == uint[]
+ (BOOL)eq:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = 6; i >= 0; --i) {
        if ([x[i] unsignedIntValue] != [y[i] unsignedIntValue]) {
            return NO;
        }
    }
    return YES;
}

// return == uint[]
+ (NSMutableArray*)fromBigInteger:(BigInteger*)x {
    if ([x signValue] < 0 || [x bitLength] > 224) {
        @throw [NSException exceptionWithName:@"Argument" reason:nil userInfo:nil];
    }
    
    NSMutableArray *z = nil;
    @autoreleasepool {
        z = [Nat224 create];
        int i = 0;
        while ([x signValue] != 0) {
            z[i++] = @((uint)[x intValue]);
            x = [x shiftRightWithN:32];
        }
    }
    return (z ? [z autorelease] : nil);
}

// NSMutableArray == uint[]
+ (uint)getBit:(NSMutableArray*)x withBit:(int)bit {
    if (bit == 0) {
        return [x[0] unsignedIntValue] & 1;
    }
    int w = bit >> 5;
    if (w < 0 || w >= 7) {
        return 0;
    }
    int b = bit & 31;
    return ([x[w] unsignedIntValue] >> b) & 1;
}

// NSMutableArray == uint[]
+ (BOOL)gte:(NSMutableArray*)x withY:(NSMutableArray*)y {
    for (int i = 6; i >= 0; --i) {
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
    for (int i = 6; i >= 0; --i) {
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
    for (int i = 1; i < 7; ++i) {
        if ([x[i] unsignedIntValue] != 0) {
            return NO;
        }
    }
    return YES;
}

// NSMutableArray == uint[]
+ (BOOL)isZero:(NSMutableArray*)x {
    for (int i = 0; i < 7; ++i) {
        if ([x[i] unsignedIntValue] != 0) {
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
        uint64_t y_4 = [y[4] unsignedLongLongValue];
        uint64_t y_5 = [y[5] unsignedLongLongValue];
        uint64_t y_6 = [y[6] unsignedLongLongValue];
        
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
            c += x_0 * y_4;
            zz[4] = @((uint)c);
            c >>= 32;
            c += x_0 * y_5;
            zz[5] = @((uint)c);
            c >>= 32;
            c += x_0 * y_6;
            zz[6] = @((uint)c);
            c >>= 32;
            zz[7] = @((uint)c);
        }
        
        for (int i = 1; i < 7; ++i) {
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
            c += x_i * y_4 + [zz[i + 4] unsignedIntValue];
            zz[i + 4] = @((uint)c);
            c >>= 32;
            c += x_i * y_5 + [zz[i + 5] unsignedIntValue];
            zz[i + 5] = @((uint)c);
            c >>= 32;
            c += x_i * y_6 + [zz[i + 6] unsignedIntValue];
            zz[i + 6] = @((uint)c);
            c >>= 32;
            zz[i + 7] = @((uint)c);
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
        uint64_t y_4 = [y[yOff + 4] unsignedLongLongValue];
        uint64_t y_5 = [y[yOff + 5] unsignedLongLongValue];
        uint64_t y_6 = [y[yOff + 6] unsignedLongLongValue];
        
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
            c += x_0 * y_4;
            zz[zzOff + 4] = @((uint)c);
            c >>= 32;
            c += x_0 * y_5;
            zz[zzOff + 5] = @((uint)c);
            c >>= 32;
            c += x_0 * y_6;
            zz[zzOff + 6] = @((uint)c);
            c >>= 32;
            zz[zzOff + 7] = @((uint)c);
        }
        
        for (int i = 1; i < 7; ++i) {
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
            c += x_i * y_4 + [zz[zzOff + 4] unsignedIntValue];
            zz[zzOff + 4] = @((uint)c);
            c >>= 32;
            c += x_i * y_5 + [zz[zzOff + 5] unsignedIntValue];
            zz[zzOff + 5] = @((uint)c);
            c >>= 32;
            c += x_i * y_6 + [zz[zzOff + 6] unsignedIntValue];
            zz[zzOff + 6] = @((uint)c);
            c >>= 32;
            zz[zzOff + 7] = @((uint)c);
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
        uint64_t y_4 = [y[4] unsignedLongLongValue];
        uint64_t y_5 = [y[5] unsignedLongLongValue];
        uint64_t y_6 = [y[6] unsignedLongLongValue];
        
        for (int i = 0; i < 7; ++i) {
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
            c += x_i * y_4 + [zz[i + 4] unsignedIntValue];
            zz[i + 4] = @((uint)c);
            c >>= 32;
            c += x_i * y_5 + [zz[i + 5] unsignedIntValue];
            zz[i + 5] = @((uint)c);
            c >>= 32;
            c += x_i * y_6 + [zz[i + 6] unsignedIntValue];
            zz[i + 6] = @((uint)c);
            c >>= 32;
            c += zc + [zz[i + 7] unsignedIntValue];
            zz[i + 7] = @((uint)c);
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
        uint64_t y_4 = [y[yOff + 4] unsignedLongLongValue];
        uint64_t y_5 = [y[yOff + 5] unsignedLongLongValue];
        uint64_t y_6 = [y[yOff + 6] unsignedLongLongValue];
        
        for (int i = 0; i < 7; ++i) {
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
            c += x_i * y_4 + [zz[zzOff + 4] unsignedIntValue];
            zz[zzOff + 4] = @((uint)c);
            c >>= 32;
            c += x_i * y_5 + [zz[zzOff + 5] unsignedIntValue];
            zz[zzOff + 5] = @((uint)c);
            c >>= 32;
            c += x_i * y_6 + [zz[zzOff + 6] unsignedIntValue];
            zz[zzOff + 6] = @((uint)c);
            c >>= 32;
            c += zc + [zz[zzOff + 7] unsignedIntValue];
            zz[zzOff + 7] = @((uint)c);
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
        uint64_t x4 = [x[xOff + 4] unsignedLongLongValue];
        c += wVal * x4 + x3 + [y[yOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        uint64_t x5 = [x[xOff + 5] unsignedLongLongValue];
        c += wVal * x5 + x4 + [y[yOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        uint64_t x6 = [x[xOff + 6] unsignedLongLongValue];
        c += wVal * x6 + x5 + [y[yOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
        c >>= 32;
        c += x6;
    }
    return c;
}

// NSMutableArray == uint[]
+ (uint)mulByWord:(uint)x withZ:(NSMutableArray*)z {
    uint64_t c = 0, xVal = x;
    @autoreleasepool {
        c += xVal * [z[0] unsignedLongLongValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += xVal * [z[1] unsignedLongLongValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += xVal * [z[2] unsignedLongLongValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += xVal * [z[3] unsignedLongLongValue];
        z[3] = @((uint)c);
        c >>= 32;
        c += xVal * [z[4] unsignedLongLongValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += xVal * [z[5] unsignedLongLongValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += xVal * [z[6] unsignedLongLongValue];
        z[6] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)mulByWordAddTo:(uint)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    uint64_t c = 0, xVal = x;
    @autoreleasepool {
        c += xVal * [z[0] unsignedLongLongValue] + [y[0] unsignedIntValue];
        z[0] = @((uint)c);
        c >>= 32;
        c += xVal * [z[1] unsignedLongLongValue] + [y[1] unsignedIntValue];
        z[1] = @((uint)c);
        c >>= 32;
        c += xVal * [z[2] unsignedLongLongValue] + [y[2] unsignedIntValue];
        z[2] = @((uint)c);
        c >>= 32;
        c += xVal * [z[3] unsignedLongLongValue] + [y[3] unsignedIntValue];
        z[3] = @((uint)c);
        c >>= 32;
        c += xVal * [z[4] unsignedLongLongValue] + [y[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += xVal * [z[5] unsignedLongLongValue] + [y[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += xVal * [z[6] unsignedLongLongValue] + [y[6] unsignedIntValue];
        z[6] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)mulWordAddTo:(uint)x withY:(NSMutableArray*)y withYoff:(int)yOff withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint64_t c = 0, xVal = x;
    @autoreleasepool {
        c += xVal * [y[yOff + 0] unsignedIntValue] + [z[zOff + 0] unsignedIntValue];
        z[zOff + 0] = @((uint)c);
        c >>= 32;
        c += xVal * [y[yOff + 1] unsignedIntValue] + [z[zOff + 1] unsignedIntValue];
        z[zOff + 1] = @((uint)c);
        c >>= 32;
        c += xVal * [y[yOff + 2] unsignedIntValue] + [z[zOff + 2] unsignedIntValue];
        z[zOff + 2] = @((uint)c);
        c >>= 32;
        c += xVal * [y[yOff + 3] unsignedIntValue] + [z[zOff + 3] unsignedIntValue];
        z[zOff + 3] = @((uint)c);
        c >>= 32;
        c += xVal * [y[yOff + 4] unsignedIntValue] + [z[zOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        c += xVal * [y[yOff + 5] unsignedIntValue] + [z[zOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        c += xVal * [y[yOff + 6] unsignedIntValue] + [z[zOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
        c >>= 32;
    }
    return (uint)c;
}

// NSMutableArray == uint[]
+ (uint)mul33DWordAdd:(uint)x withY:(uint64_t)y withZ:(NSMutableArray*)z withZoff:(int)zOff {
    uint retVal = 0;
    @autoreleasepool {
        uint64_t c = 0, xVal = x;
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
        retVal = (c == 0 ? 0 : [Nat incAt:7 withZ:z withZoff:zOff withZpos:4]);
    }
    return retVal;
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
        retVal = (c == 0 ? 0 : [Nat incAt:7 withZ:z withZoff:zOff withZpos:3]);
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
        retVal = (c == 0 ? 0 : [Nat incAt:7 withZ:z withZoff:zOff withZpos:3]);
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
        } while (++i < 7);
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
            int i = 6, j = 14;
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
            zz_4 &= M;
            zz_6 += zz_5 >> 32;
            zz_5 &= M;
        }
        
        uint64_t x_4 = [x[4] unsignedLongLongValue];
        uint64_t zz_7 = [zz[7] unsignedLongLongValue];
        uint64_t zz_8 = [zz[8] unsignedLongLongValue];
        {
            zz_4 += x_4 * x_0;
            w = (uint)zz_4;
            zz[4] = @((w << 1) | c);
            c = w >> 31;
            zz_5 += (zz_4 >> 32) + x_4 * x_1;
            zz_6 += (zz_5 >> 32) + x_4 * x_2;
            zz_5 &= M;
            zz_7 += (zz_6 >> 32) + x_4 * x_3;
            zz_6 &= M;
            zz_8 += zz_7 >> 32;
            zz_7 &= M;
        }
        
        uint64_t x_5 = [x[5] unsignedLongLongValue];
        uint64_t zz_9 = [zz[9] unsignedLongLongValue];
        uint64_t zz_10 = [zz[10] unsignedLongLongValue];
        {
            zz_5 += x_5 * x_0;
            w = (uint)zz_5;
            zz[5] = @((w << 1) | c);
            c = w >> 31;
            zz_6 += (zz_5 >> 32) + x_5 * x_1;
            zz_7 += (zz_6 >> 32) + x_5 * x_2;
            zz_6 &= M;
            zz_8 += (zz_7 >> 32) + x_5 * x_3;
            zz_7 &= M;
            zz_9 += (zz_8 >> 32) + x_5 * x_4;
            zz_8 &= M;
            zz_10 += zz_9 >> 32;
            zz_9 &= M;
        }
        
        uint64_t x_6 = [x[6] unsignedLongLongValue];
        uint64_t zz_11 = [zz[11] unsignedLongLongValue];
        uint64_t zz_12 = [zz[12] unsignedLongLongValue];
        {
            zz_6 += x_6 * x_0;
            w = (uint)zz_6;
            zz[6] = @((w << 1) | c);
            c = w >> 31;
            zz_7 += (zz_6 >> 32) + x_6 * x_1;
            zz_8 += (zz_7 >> 32) + x_6 * x_2;
            zz_9 += (zz_8 >> 32) + x_6 * x_3;
            zz_10 += (zz_9 >> 32) + x_6 * x_4;
            zz_11 += (zz_10 >> 32) + x_6 * x_5;
            zz_12 += zz_11 >> 32;
        }
        
        w = (uint)zz_7;
        zz[7] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_8;
        zz[8] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_9;
        zz[9] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_10;
        zz[10] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_11;
        zz[11] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_12;
        zz[12] = @((w << 1) | c);
        c = w >> 31;
        w = [zz[13] unsignedIntValue] + (uint)(zz_12 >> 32);
        zz[13] = @((w << 1) | c);
    }
}

// NSMutableArray == uint[]
+ (void)square:(NSMutableArray*)x withXoff:(int)xOff withZZ:(NSMutableArray*)zz withZZoff:(int)zzOff {
    @autoreleasepool {
        uint64_t x_0 = [x[xOff + 0] unsignedLongLongValue];
        uint64_t zz_1;
        
        uint c = 0, w;
        {
            int i = 6, j = 14;
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
            zz_4 &= M;
            zz_6 += zz_5 >> 32;
            zz_5 &= M;
        }
        
        uint64_t x_4 = [x[xOff + 4] unsignedLongLongValue];
        uint64_t zz_7 = [zz[zzOff + 7] unsignedLongLongValue];
        uint64_t zz_8 = [zz[zzOff + 8] unsignedLongLongValue];
        {
            zz_4 += x_4 * x_0;
            w = (uint)zz_4;
            zz[zzOff + 4] = @((w << 1) | c);
            c = w >> 31;
            zz_5 += (zz_4 >> 32) + x_4 * x_1;
            zz_6 += (zz_5 >> 32) + x_4 * x_2;
            zz_5 &= M;
            zz_7 += (zz_6 >> 32) + x_4 * x_3;
            zz_6 &= M;
            zz_8 += zz_7 >> 32;
            zz_7 &= M;
        }
        
        uint64_t x_5 = [x[xOff + 5] unsignedLongLongValue];
        uint64_t zz_9 = [zz[zzOff + 9] unsignedLongLongValue];
        uint64_t zz_10 = [zz[zzOff + 10] unsignedLongLongValue];
        {
            zz_5 += x_5 * x_0;
            w = (uint)zz_5;
            zz[zzOff + 5] = @((w << 1) | c);
            c = w >> 31;
            zz_6 += (zz_5 >> 32) + x_5 * x_1;
            zz_7 += (zz_6 >> 32) + x_5 * x_2;
            zz_6 &= M;
            zz_8 += (zz_7 >> 32) + x_5 * x_3;
            zz_7 &= M;
            zz_9 += (zz_8 >> 32) + x_5 * x_4;
            zz_8 &= M;
            zz_10 += zz_9 >> 32;
            zz_9 &= M;
        }
        
        uint64_t x_6 = [x[xOff + 6] unsignedLongLongValue];
        uint64_t zz_11 = [zz[zzOff + 11] unsignedLongLongValue];
        uint64_t zz_12 = [zz[zzOff + 12] unsignedLongLongValue];
        {
            zz_6 += x_6 * x_0;
            w = (uint)zz_6;
            zz[zzOff + 6] = @((w << 1) | c);
            c = w >> 31;
            zz_7 += (zz_6 >> 32) + x_6 * x_1;
            zz_8 += (zz_7 >> 32) + x_6 * x_2;
            zz_9 += (zz_8 >> 32) + x_6 * x_3;
            zz_10 += (zz_9 >> 32) + x_6 * x_4;
            zz_11 += (zz_10 >> 32) + x_6 * x_5;
            zz_12 += zz_11 >> 32;
        }
        
        w = (uint)zz_7;
        zz[zzOff + 7] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_8;
        zz[zzOff + 8] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_9;
        zz[zzOff + 9] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_10;
        zz[zzOff + 10] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_11;
        zz[zzOff + 11] = @((w << 1) | c);
        c = w >> 31;
        w = (uint)zz_12;
        zz[zzOff + 12] = @((w << 1) | c);
        c = w >> 31;
        w = [zz[zzOff + 13] unsignedIntValue] + (uint)(zz_12 >> 32);
        zz[zzOff + 13] = @((w << 1) | c);
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
        c += [x[4] longLongValue] - [y[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += [x[5] longLongValue] - [y[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += [x[6] longLongValue] - [y[6] unsignedIntValue];
        z[6] = @((uint)c);
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
        c += [x[xOff + 4] longLongValue] - [y[yOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 5] longLongValue] - [y[yOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        c += [x[xOff + 6] longLongValue] - [y[yOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
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
        c += [z[4] longLongValue] - [x[4] unsignedIntValue] - [y[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += [z[5] longLongValue] - [x[5] unsignedIntValue] - [y[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += [z[6] longLongValue] - [x[6] unsignedIntValue] - [y[6] unsignedIntValue];
        z[6] = @((uint)c);
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
        c += [z[4] longLongValue] - [x[4] unsignedIntValue];
        z[4] = @((uint)c);
        c >>= 32;
        c += [z[5] longLongValue] - [x[5] unsignedIntValue];
        z[5] = @((uint)c);
        c >>= 32;
        c += [z[6] longLongValue] - [x[6] unsignedIntValue];
        z[6] = @((uint)c);
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
        c += [z[zOff + 4] longLongValue] - [x[xOff + 4] unsignedIntValue];
        z[zOff + 4] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 5] longLongValue] - [x[xOff + 5] unsignedIntValue];
        z[zOff + 5] = @((uint)c);
        c >>= 32;
        c += [z[zOff + 6] longLongValue] - [x[xOff + 6] unsignedIntValue];
        z[zOff + 6] = @((uint)c);
        c >>= 32;
    }
    return (int)c;
}

// NSMutableArray == uint[]
+ (BigInteger*)toBigInteger:(NSMutableArray*)x {
    BigInteger *retVal = nil;
    @autoreleasepool {
        NSMutableData *bs = [[NSMutableData alloc] initWithSize:28];
        for (int i = 0; i < 7; ++i) {
            uint x_i = [x[i] unsignedIntValue];
            if (x_i != 0) {
                [Pack UInt32_To_BE:x_i withBs:bs withOff:((6 - i) << 2)];
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
        z[4] = @((uint)0);
        z[5] = @((uint)0);
        z[6] = @((uint)0);
    }
}

@end
