//
//  GcmUtilities.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "GcmUtilities.h"
#import "CategoryExtend.h"
#import "Pack.h"

@implementation GcmUtilities

static const uint E1 = 0xe1000000;
static const uint64_t E1L = (uint64_t)E1 << 32;

// return == uint[]
+ (NSMutableArray*)generateLookup {
    NSMutableArray *lookup = [[[NSMutableArray alloc] initWithSize:256] autorelease];
    @autoreleasepool {
        for (int c = 0; c < 256; ++c) {
            uint v = 0;
            for (int i = 7; i >= 0; --i) {
                if ((c & (1 << i)) != 0) {
                    v ^= (E1 >> (7 - i));
                }
            }
            lookup[c] = @(v);
        }
    }
    return lookup;
}

// return == uint[]
+ (NSMutableArray*)LOOKUP {
    static NSMutableArray *_lookup = nil;
    @synchronized(self) {
        if (_lookup == nil) {
            _lookup = [[GcmUtilities generateLookup] retain];
        }
    }
    return _lookup;
}

+ (NSMutableData*)oneAsBytes {
    NSMutableData *tmp = [[[NSMutableData alloc] initWithSize:16] autorelease];
    ((Byte*)(tmp.bytes))[0] = 0x80;
    return tmp;
}

// return == uint[]
+ (NSMutableArray*)oneAsUints {
    NSMutableArray *tmp = [[[NSMutableArray alloc] initWithSize:4] autorelease];
    tmp[0] = @(0x80000000);
    return tmp;
}

// return == uint64_t[]
+ (NSMutableArray*)oneAsUInt64_ts {
    NSMutableArray *tmp = [[[NSMutableArray alloc] initWithSize:2] autorelease];
    tmp[0] = @(1ULL << 63);
    return tmp;
}

// NSMutableArray == uint[]
+ (NSMutableData*)asBytesWithUintArray:(NSMutableArray*)x {
    return [Pack UInt32_To_BE_Array:x];
}

// NSMutableArray == uint[]
+ (void)asBytesWithUintArray:(NSMutableArray*)x withZ:(NSMutableData*)z {
    [Pack UInt32_To_BE_Array:x withBs:z withOff:0];
}

// NSMutableArray == uint64_t[]
+ (NSMutableData*)asBytesWithUint64_tArray:(NSMutableArray*)x {
    NSMutableData *z = [[[NSMutableData alloc] initWithSize:16] autorelease];
    [Pack UInt64_To_BE_Array:x withBs:z withOff:0];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)asBytesWithUint64_tArray:(NSMutableArray*)x withZ:(NSMutableData*)z {
    [Pack UInt64_To_BE_Array:x withBs:z withOff:0];
}

// return == uint[]
+ (NSMutableArray*)asUints:(NSMutableData*)bs {
    NSMutableArray *output = [[[NSMutableArray alloc] initWithSize:4] autorelease];
    [Pack BE_To_UInt32:bs withOff:0 withNs:output];
    return output;
}

// NSMutableArray == uint[]
+ (void)asUints:(NSMutableData*)bs withOutput:(NSMutableArray*)output {
    [Pack BE_To_UInt32:bs withOff:0 withNs:output];
}

// return == uint64_t[]
+ (NSMutableArray*)asUint64_ts:(NSMutableData*)x {
    NSMutableArray *z = [[[NSMutableArray alloc] initWithSize:2] autorelease];
    [Pack BE_To_UInt64:x withOff:0 withNs:z];
    return z;
}

// NSMutableArray == uint64_t[]
+ (void)asUint64_ts:(NSMutableData*)x withUint64_ts:(NSMutableArray*)z {
    [Pack BE_To_UInt64:x withOff:0 withNs:z];
}

+ (void)multiplyWithBytes:(NSMutableData*)x withY:(NSMutableData*)y {
    @autoreleasepool {
        NSMutableArray *t1 = [GcmUtilities asUints:x];
        NSMutableArray *t2 = [GcmUtilities asUints:y];
        [GcmUtilities multiplyWithUints:t1 withY:t2];
        [GcmUtilities asBytesWithUintArray:t1 withZ:x];
    }
}

// NSMutableArray == uint[]
+ (void)multiplyWithUints:(NSMutableArray*)x withY:(NSMutableArray*)y {
    @autoreleasepool {
        uint r00 = [x[0] unsignedIntValue], r01 = [x[1] unsignedIntValue], r02 = [x[2] unsignedIntValue], r03 = [x[3] unsignedIntValue];
        uint r10 = 0, r11 = 0, r12 = 0, r13 = 0;
        
        for (int i = 0; i < 4; ++i) {
            int bits = [y[i] intValue];
            for (int j = 0; j < 32; ++j) {
                uint m1 = (uint)(bits >> 31); bits <<= 1;
                r10 ^= (r00 & m1);
                r11 ^= (r01 & m1);
                r12 ^= (r02 & m1);
                r13 ^= (r03 & m1);
                
                uint m2 = (uint)((int)(r03 << 31) >> 8);
                r03 = (r03 >> 1) | (r02 << 31);
                r02 = (r02 >> 1) | (r01 << 31);
                r01 = (r01 >> 1) | (r00 << 31);
                r00 = (r00 >> 1) ^ (m2 & E1);
            }
        }
        
        x[0] = @(r10);
        x[1] = @(r11);
        x[2] = @(r12);
        x[3] = @(r13);
    }
}

// NSMutableArray == uint64_t[]
+ (void)multiplyWithUint64_ts:(NSMutableArray*)x withY:(NSMutableArray*)y {
    @autoreleasepool {
        uint64_t r00 = [x[0] unsignedLongLongValue], r01 = [x[1] unsignedLongLongValue], r10 = 0, r11 = 0;
        
        for (int i = 0; i < 2; ++i) {
            int64_t bits = [y[i] longLongValue];
            for (int j = 0; j < 64; ++j) {
                uint64_t m1 = (uint64_t)(bits >> 63); bits <<= 1;
                r10 ^= (r00 & m1);
                r11 ^= (r01 & m1);
                
                uint64_t m2 = (uint64_t)((int64_t)(r01 << 63) >> 8);
                r01 = (r01 >> 1) | (r00 << 63);
                r00 = (r00 >> 1) ^ (m2 & E1L);
            }
        }
        
        x[0] = @(r10);
        x[1] = @(r11);
    }
}

// P is the value with only bit i=1 set
// NSMutableArray == uint[]
+ (void)multiplyP:(NSMutableArray*)x {
    @autoreleasepool {
        uint m = (uint)((int)[GcmUtilities shiftRight:x] >> 8);
        x[0] = @([x[0] unsignedIntValue] ^ (m & E1));
    }
}

// NSMutableArray == uint[]
+ (void)multiplyP:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    @autoreleasepool {
        uint m = (uint)((int)[GcmUtilities shiftRight:x withZ:z] >> 8);
        z[0] = @([z[0] unsignedIntValue] ^ (m & E1));
    }
}

// NSMutableArray == uint[]
+ (void)multiplyP8:(NSMutableArray*)x {
    // for (int i = 8; i != 0; --i) {
    //    [GcmUtilities multiplyP:x];
    // }
    
    @autoreleasepool {
        uint c = [GcmUtilities shiftRightN:x withN:8];
        x[0] = @([x[0] unsignedIntValue] ^ [[GcmUtilities LOOKUP][c >> 24] unsignedIntValue]);
    }
}

// NSMutableArray == uint[]
+ (void)multiplyP8:(NSMutableArray*)x withY:(NSMutableArray*)y {
    @autoreleasepool {
        uint c = [GcmUtilities shiftRightN:x withN:8 withZ:y];
        y[0] = @([y[0] unsignedIntValue] ^ [[GcmUtilities LOOKUP][c >> 24] unsignedIntValue]);
    }
}

// NSMutableArray == uint[]
+ (uint)shiftRight:(NSMutableArray*)x {
    uint retVal = 0;
    @autoreleasepool {
        uint b = [x[0] unsignedIntValue];
        x[0] = @(b >> 1);
        uint c = b << 31;
        b = [x[1] unsignedIntValue];
        x[1] = @((b >> 1) | c);
        c = b << 31;
        b = [x[2] unsignedIntValue];
        x[2] = @((b >> 1) | c);
        c = b << 31;
        b = [x[3] unsignedIntValue];
        x[3] = @((b >> 1) | c);
        retVal = (b << 31);
    }
    return retVal;
}

// NSMutableArray == uint[]
+ (uint)shiftRight:(NSMutableArray*)x withZ:(NSMutableArray*)z {
    uint retVal = 0;
    @autoreleasepool {
        uint b = [x[0] unsignedIntValue];
        z[0] = @(b >> 1);
        uint c = b << 31;
        b = [x[1] unsignedIntValue];
        z[1] = @((b >> 1) | c);
        c = b << 31;
        b = [x[2] unsignedIntValue];
        z[2] = @((b >> 1) | c);
        c = b << 31;
        b = [x[3] unsignedIntValue];
        z[3] = @((b >> 1) | c);
        retVal = (b << 31);
    }
    return retVal;
}

// NSMutableArray == uint[]
+ (uint)shiftRightN:(NSMutableArray*)x withN:(int)n {
    uint retVal = 0;
    @autoreleasepool {
        uint b = [x[0] unsignedIntValue]; int nInv = 32 - n;
        x[0] = @(b >> n);
        uint c = b << nInv;
        b = [x[1] unsignedIntValue];
        x[1] = @((b >> n) | c);
        c = b << nInv;
        b = [x[2] unsignedIntValue];
        x[2] = @((b >> n) | c);
        c = b << nInv;
        b = [x[3] unsignedIntValue];
        x[3] = @((b >> n) | c);
        retVal = (b << nInv);
    }
    return retVal;
}

// NSMutableArray == uint[]
+ (uint)shiftRightN:(NSMutableArray*)x withN:(int)n withZ:(NSMutableArray*)z {
    uint retVal = 0;
    @autoreleasepool {
        uint b = [x[0] unsignedIntValue]; int nInv = 32 - n;
        z[0] = @(b >> n);
        uint c = b << nInv;
        b = [x[1] unsignedIntValue];
        z[1] = @((b >> n) | c);
        c = b << nInv;
        b = [x[2] unsignedIntValue];
        z[2] = @((b >> n) | c);
        c = b << nInv;
        b = [x[3] unsignedIntValue];
        z[3] = @((b >> n) | c);
        retVal = (b << nInv);
    }
    return retVal;
}

+ (void)xorWithBytes:(NSMutableData*)x withY:(NSMutableData*)y {
    int i = 0;
    do {
        ((Byte*)(x.bytes))[i] = ((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]; ++i;
        ((Byte*)(x.bytes))[i] = ((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]; ++i;
        ((Byte*)(x.bytes))[i] = ((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]; ++i;
        ((Byte*)(x.bytes))[i] = ((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]; ++i;
    } while (i < 16);
}

+ (void)xorWithBytes:(NSMutableData*)x withY:(NSMutableData*)y withYoff:(int)yOff withYlen:(int)yLen {
    while (--yLen >= 0) {
        ((Byte*)(x.bytes))[yLen] = ((Byte*)(x.bytes))[yLen] ^ ((Byte*)(y.bytes))[yOff + yLen];
    }
}

+ (void)xorWithBytes:(NSMutableData*)x withY:(NSMutableData*)y withZ:(NSMutableData*)z {
    int i = 0;
    do {
        ((Byte*)(z.bytes))[i] = (Byte)(((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]); ++i;
        ((Byte*)(z.bytes))[i] = (Byte)(((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]); ++i;
        ((Byte*)(z.bytes))[i] = (Byte)(((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]); ++i;
        ((Byte*)(z.bytes))[i] = (Byte)(((Byte*)(x.bytes))[i] ^ ((Byte*)(y.bytes))[i]); ++i;
    } while (i < 16);
}

// NSMutableArray == uint[]
+ (void)xorWithUints:(NSMutableArray*)x withY:(NSMutableArray*)y {
    @autoreleasepool {
        x[0] = @([x[0] unsignedIntValue] ^ [y[0] unsignedIntValue]);
        x[1] = @([x[1] unsignedIntValue] ^ [y[1] unsignedIntValue]);
        x[2] = @([x[2] unsignedIntValue] ^ [y[2] unsignedIntValue]);
        x[3] = @([x[3] unsignedIntValue] ^ [y[3] unsignedIntValue]);
    }
}

// NSMutableArray == uint[]
+ (void)xorWithUints:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedIntValue] ^ [y[0] unsignedIntValue]);
        z[1] = @([x[1] unsignedIntValue] ^ [y[1] unsignedIntValue]);
        z[2] = @([x[2] unsignedIntValue] ^ [y[2] unsignedIntValue]);
        z[3] = @([x[3] unsignedIntValue] ^ [y[3] unsignedIntValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)xorWithUint64_ts:(NSMutableArray*)x withY:(NSMutableArray*)y {
    @autoreleasepool {
        x[0] = @([x[0] unsignedLongLongValue] ^ [y[0] unsignedLongLongValue]);
        x[1] = @([x[1] unsignedLongLongValue] ^ [y[1] unsignedLongLongValue]);
    }
}

// NSMutableArray == uint64_t[]
+ (void)xorWithUint64_ts:(NSMutableArray*)x withY:(NSMutableArray*)y withZ:(NSMutableArray*)z {
    @autoreleasepool {
        z[0] = @([x[0] unsignedLongLongValue] ^ [y[0] unsignedLongLongValue]);
        z[1] = @([x[1] unsignedLongLongValue] ^ [y[1] unsignedLongLongValue]);        
    }
}

@end
