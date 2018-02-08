//
//  Interleave.m
//  
//
//  Created by Pallas on 5/26/16.
//
//  Complete

#import "Interleave.h"

@implementation Interleave

static uint64_t const M32 = 0x55555555UL;
static uint64_t const M64 = 0x5555555555555555UL;

+ (uint)expand8to16:(uint)x {
    x &= 0xFFU;
    x = (x | (x << 4)) & 0x0F0FU;
    x = (x | (x << 2)) & 0x3333U;
    x = (x | (x << 1)) & 0x5555U;
    return x;
}

+ (uint)expand16to32:(uint)x {
    x &= 0xFFFFU;
    x = (x | (x << 8)) & 0x00FF00FFU;
    x = (x | (x << 4)) & 0x0F0F0F0FU;
    x = (x | (x << 2)) & 0x33333333U;
    x = (x | (x << 1)) & 0x55555555U;
    return x;
}

+ (uint64_t)expand32to64:(uint)x {
    // "shuffle" low half to even bits and high half to odd bits
    uint64_t retVal = 0;
    uint t;
    t = (x ^ (x >>  8)) & 0x0000FF00U; x ^= (t ^ (t <<  8));
    t = (x ^ (x >>  4)) & 0x00F000F0U; x ^= (t ^ (t <<  4));
    t = (x ^ (x >>  2)) & 0x0C0C0C0CU; x ^= (t ^ (t <<  2));
    t = (x ^ (x >>  1)) & 0x22222222U; x ^= (t ^ (t <<  1));
    retVal = ((x >> 1) & M32) << 32 | (x & M32);
    return retVal;
}

// NSMutableArray == uint64_t[]
+ (void)expand64To128:(uint64_t)x withZ:(NSMutableArray*)z withZ0ff:(int)zOff {
    // "shuffle" low half to even bits and high half to odd bits
    @autoreleasepool {
        uint64_t t;
        t = (x ^ (x >> 16)) & 0x00000000FFFF0000UL; x ^= (t ^ (t << 16));
        t = (x ^ (x >> 8)) & 0x0000FF000000FF00UL; x ^= (t ^ (t <<  8));
        t = (x ^ (x >> 4)) & 0x00F000F000F000F0UL; x ^= (t ^ (t <<  4));
        t = (x ^ (x >> 2)) & 0x0C0C0C0C0C0C0C0CUL; x ^= (t ^ (t <<  2));
        t = (x ^ (x >> 1)) & 0x2222222222222222UL; x ^= (t ^ (t <<  1));
        
        z[zOff] = @((uint64_t)(x & M64));
        z[zOff + 1] = @((uint64_t)((x >> 1) & M64));
    }
}

+ (uint64_t)unshuffle:(uint64_t)x {
    // "unshuffle" even bits to low half and odd bits to high half
    uint64_t t;
    t = (x ^ (x >>  1)) & 0x2222222222222222UL; x ^= (t ^ (t <<  1));
    t = (x ^ (x >>  2)) & 0x0C0C0C0C0C0C0C0CUL; x ^= (t ^ (t <<  2));
    t = (x ^ (x >>  4)) & 0x00F000F000F000F0UL; x ^= (t ^ (t <<  4));
    t = (x ^ (x >>  8)) & 0x0000FF000000FF00UL; x ^= (t ^ (t <<  8));
    t = (x ^ (x >> 16)) & 0x00000000FFFF0000UL; x ^= (t ^ (t << 16));
    return x;
}

@end
