//
//  Pack.m
//  
//
//  Created by Pallas on 5/9/16.
//
//  complete

#import "Pack.h"
#import "CategoryExtend.h"

@implementation Pack

// bs == byte[]
+ (void)UInt16_To_BE:(ushort)n withBs:(NSMutableData*)bs {
    ((Byte*)(bs.bytes))[0] = (Byte)(n >> 8);
    ((Byte*)(bs.bytes))[1] = (Byte)(n);
}

// bs == byte[]
+ (void)UInt16_To_BE:(ushort)n withBs:(NSMutableData*)bs withOff:(int)off {
    ((Byte*)(bs.bytes))[off] = (Byte)(n >> 8);
    ((Byte*)(bs.bytes))[off + 1] = (Byte)(n);
}

// bs == byte[]
+ (ushort)BE_To_UInt16:(NSMutableData*)bs {
    uint n = (uint)((Byte*)(bs.bytes))[0] << 8 | (uint)((Byte*)(bs.bytes))[1];
    return (ushort)n;
}

// bs == byte[]
+ (ushort)BE_To_UInt16:(NSMutableData*)bs withOff:(int)off {
    uint n = (uint)((Byte*)(bs.bytes))[off] << 8 | (uint)((Byte*)(bs.bytes))[off + 1];
    return (ushort)n;
}

// return == byte[]
+ (NSMutableData*)UInt32_To_BE:(uint)n {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:4] autorelease];
    [Pack UInt32_To_BE:n withBs:bs withOff:0];
    return bs;
}

// bs == byte[]
+ (void)UInt32_To_BE:(uint)n withBs:(NSMutableData*)bs {
    ((Byte*)(bs.bytes))[0] = (Byte)(n >> 24);
    ((Byte*)(bs.bytes))[1] = (Byte)(n >> 16);
    ((Byte*)(bs.bytes))[2] = (Byte)(n >> 8);
    ((Byte*)(bs.bytes))[3] = (Byte)(n);
}

// bs == byte[]
+ (void)UInt32_To_BE:(uint)n withBs:(NSMutableData*)bs withOff:(int)off {
    ((Byte*)(bs.bytes))[off] = (Byte)(n >> 24);
    ((Byte*)(bs.bytes))[off + 1] = (Byte)(n >> 16);
    ((Byte*)(bs.bytes))[off + 2] = (Byte)(n >> 8);
    ((Byte*)(bs.bytes))[off + 3] = (Byte)(n);
}

// ns == uint[], return ==  byte[]
+ (NSMutableData*)UInt32_To_BE_Array:(NSMutableArray*)ns {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(4 * (int)(ns.count))] autorelease];
    [Pack UInt32_To_BE_Array:ns withBs:bs withOff:0];
    return bs;
}

// ns == uint[], bs ==  byte[]
+ (void)UInt32_To_BE_Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off {
    for (int i = 0; i < ns.count; ++i) {
        [Pack UInt32_To_BE:[ns[i] unsignedIntValue] withBs:bs withOff:off];
        off += 4;
    }
}

// bs ==  byte[]
+ (uint)BE_To_UInt32:(NSMutableData*)bs {
    return (uint)((Byte*)(bs.bytes))[0] << 24 | (uint)((Byte*)(bs.bytes))[1] << 16 | (uint)((Byte*)(bs.bytes))[2] << 8 | (uint)((Byte*)(bs.bytes))[3];
}

// bs ==  byte[]
+ (uint)BE_To_UInt32:(NSMutableData*)bs withOff:(int)off {
    return (uint)((Byte*)(bs.bytes))[off] << 24 | (uint)((Byte*)(bs.bytes))[off + 1] << 16 | (uint)((Byte*)(bs.bytes))[off + 2] << 8 | (uint)((Byte*)(bs.bytes))[off + 3];
}

// bs ==  byte[], ns == uint[]
+ (void)BE_To_UInt32:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns {
    for (int i = 0; i < ns.count; ++i) {
        ns[i] = @([Pack BE_To_UInt32:bs withOff:off]);
        off += 4;
    }
}

// return == byte[]
+ (NSMutableData*)UInt64_To_BE:(uint64_t)n {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:8] autorelease];
    [Pack UInt64_To_BE:n withBs:bs withOff:0];
    return bs;
}

// bs == byte[]
+ (void)UInt64_To_BE:(uint64_t)n withBs:(NSMutableData*)bs {
    [Pack UInt32_To_BE:(uint)(n >> 32) withBs:bs];
    [Pack UInt32_To_BE:(uint)(n) withBs:bs withOff:4];
}

// bs == byte[]
+ (void)UInt64_To_BE:(uint64_t)n withBs:(NSMutableData*)bs withOff:(int)off {
    [Pack UInt32_To_BE:(uint)(n >> 32) withBs:bs withOff:off];
    [Pack UInt32_To_BE:(uint)(n) withBs:bs withOff:(off + 4)];
}

// return ==  byte[], ns == uint64_t[]
+ (NSMutableData*)UInt64_To_BE_Array:(NSMutableArray*)ns {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(8 * (int)(ns.count))] autorelease];
    [Pack UInt64_To_BE_Array:ns withBs:bs withOff:0];
    return bs;
}

// ns == uint64_t[], bs ==  byte[]
+ (void)UInt64_To_BE_Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off {
    for (int i = 0; i < ns.count; ++i) {
        [Pack UInt64_To_BE:[ns[i] unsignedLongLongValue] withBs:bs withOff:off];
        off += 8;
    }
}

// bs ==  byte[]
+ (uint64_t)BE_To_UInt64:(NSMutableData*)bs {
    uint hi = [Pack BE_To_UInt32:bs];
    uint lo = [Pack BE_To_UInt32:bs withOff:4];
    return ((uint64_t)hi << 32) | (uint64_t)lo;
}

// bs ==  byte[]
+ (uint64_t)BE_To_UInt64:(NSMutableData*)bs withOff:(int)off {
    uint hi = [Pack BE_To_UInt32:bs withOff:off];
    uint lo = [Pack BE_To_UInt32:bs withOff:(off + 4)];
    return ((uint64_t)hi << 32) | (uint64_t)lo;
}

// bs ==  byte[], ns == uint64_t[]
+ (void)BE_To_UInt64:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns {
    for (int i = 0; i < ns.count; ++i) {
        ns[i] = @([Pack BE_To_UInt64:bs withOff:off]);
        off += 8;
    }
}

// bs ==  byte[]
+ (void)UInt16_To_LE:(ushort)n withBs:(NSMutableData*)bs {
    ((Byte*)(bs.bytes))[0] = (Byte)(n);
    ((Byte*)(bs.bytes))[1] = (Byte)(n >> 8);
}

// bs ==  byte[]
+ (void)UInt16_To_LE:(ushort)n withBs:(NSMutableData*)bs withOff:(int)off {
    ((Byte*)(bs.bytes))[off] = (Byte)(n);
    ((Byte*)(bs.bytes))[off + 1] = (Byte)(n >> 8);
}

// bs ==  byte[]
+ (ushort)LE_To_UInt16:(NSMutableData*)bs {
    uint n = (uint)((Byte*)(bs.bytes))[0] | (uint)((Byte*)(bs.bytes))[1] << 8;
    return (ushort)n;
}

// bs ==  byte[]
+ (ushort)LE_To_UInt16:(NSMutableData*)bs withOff:(int)off {
    uint n = (uint)((Byte*)(bs.bytes))[off] | (uint)((Byte*)(bs.bytes))[off + 1] << 8;
    return (ushort)n;
}

// return ==  byte[]
+ (NSMutableData*)UInt32_To_LE:(uint)n {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:4] autorelease];
    [Pack UInt32_To_LE:n withBs:bs withOff:0];
    return bs;
}

// bs ==  byte[]
+ (void)UInt32_To_LE:(uint)n withBs:(NSMutableData*)bs {
    ((Byte*)(bs.bytes))[0] = (Byte)(n);
    ((Byte*)(bs.bytes))[1] = (Byte)(n >> 8);
    ((Byte*)(bs.bytes))[2] = (Byte)(n >> 16);
    ((Byte*)(bs.bytes))[3] = (Byte)(n >> 24);
}

// bs ==  byte[]
+ (void)UInt32_To_LE:(uint)n withBs:(NSMutableData*)bs withOff:(int)off {
    ((Byte*)(bs.bytes))[off] = (Byte)(n);
    ((Byte*)(bs.bytes))[off + 1] = (Byte)(n >> 8);
    ((Byte*)(bs.bytes))[off + 2] = (Byte)(n >> 16);
    ((Byte*)(bs.bytes))[off + 3] = (Byte)(n >> 24);
}

// ns ==  uint[]
+ (NSMutableData*)UInt32_To_LE_Array:(NSMutableArray*)ns {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(4 * (int)(ns.count))] autorelease];
    [Pack UInt32_To_LE_Array:ns withBs:bs withOff:0];
    return bs;
}

// ns ==  uint[], bs == byte[]
+ (void)UInt32_To_LE_Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off {
    for (int i = 0; i < ns.count; ++i) {
        [Pack UInt32_To_LE:[ns[i] unsignedIntValue] withBs:bs withOff:off];
        off += 4;
    }
}

// bs == byte[]
+ (uint)LE_To_UInt32:(NSMutableData*)bs {
    return (uint)((Byte*)(bs.bytes))[0] | (uint)((Byte*)(bs.bytes))[1] << 8 | (uint)((Byte*)(bs.bytes))[2] << 16 | (uint)((Byte*)(bs.bytes))[3] << 24;
}

// bs == byte[]
+ (uint)LE_To_UInt32:(NSMutableData*)bs withOff:(int)off {
    return (uint)((Byte*)(bs.bytes))[off] | (uint)((Byte*)(bs.bytes))[off + 1] << 8 | (uint)((Byte*)(bs.bytes))[off + 2] << 16 | (uint)((Byte*)(bs.bytes))[off + 3] << 24;
}

// bs == byte[], ns == uint[]
+ (void)LE_To_UInt32:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns {
    for (int i = 0; i < ns.count; ++i) {
        ns[i] = @([Pack LE_To_UInt32:bs withOff:off]);
        off += 4;
    }
}

// bs == byte[], ns == uint[]
+ (void)LE_To_UInt32:(NSMutableData*)bs withBoff:(int)bOff withNs:(NSMutableArray*)ns withNoff:(int)nOff withCount:(int)count {
    for (int i = 0; i < count; ++i) {
        ns[nOff + i] = @([Pack LE_To_UInt32:bs withOff:bOff]);
        bOff += 4;
    }
}

// return == byte[]
+ (NSMutableData*)UInt64_To_LE:(uint64_t)n {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:8] autorelease];
    [Pack UInt64_To_LE:n withBs:bs withOff:0];
    return bs;
}

// bs == byte[]
+ (void)UInt64_To_LE:(uint64_t)n withBs:(NSMutableData*)bs {
    [Pack UInt32_To_LE:(uint)(n) withBs:bs];
    [Pack UInt32_To_LE:(uint)(n >> 32) withBs:bs withOff:4];
}

// bs == byte[]
+ (void)UInt64_To_LE:(uint64_t)n withBs:(NSMutableData*)bs withOff:(int)off {
    [Pack UInt32_To_LE:(uint)(n) withBs:bs withOff:off];
    [Pack UInt32_To_LE:(uint)(n >> 32) withBs:bs withOff:(off + 4)];
}

// bs == byte[]
+ (uint64_t)LE_To_UInt64:(NSMutableData*)bs {
    uint lo = [Pack LE_To_UInt32:bs];
    uint hi = [Pack LE_To_UInt32:bs withOff:4];
    return ((uint64_t)hi << 32) | (uint64_t)lo;
}

// bs == byte[]
+ (uint64_t)LE_To_UInt64:(NSMutableData*)bs withOff:(int)off {
    uint lo = [Pack LE_To_UInt32:bs withOff:off];
    uint hi = [Pack LE_To_UInt32:bs withOff:(off + 4)];
    return ((uint64_t)hi << 32) | (uint64_t)lo;
}

// bs == byte[]
+ (int)LE_To_Int:(NSMutableData*)bs withOff:(int)off {
    int n = ((Byte*)(bs.bytes))[off] & 0xff;
    n |= (((Byte*)(bs.bytes))[++off] & 0xff) << 8;
    n |= (((Byte*)(bs.bytes))[++off] & 0xff) << 16;
    n |= ((Byte*)(bs.bytes))[++off] << 24;
    return n;
}

// bs == byte[], ns == int[]
+ (void)LE_To_Int:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns {
    for (int i = 0; i < ns.count; ++i) {
        ns[i] = @([Pack LE_To_Int:bs withOff:off]);
        off += 4;
    }
}

// return == byte[]
+ (NSMutableData*)Int_To_LE:(int)n {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:4] autorelease];
    [Pack Int_To_LE:n withBs:bs withOff:0];
    return bs;
}

// bs == byte[]
+ (void)Int_To_LE:(int)n withBs:(NSMutableData*)bs withOff:(int)off {
    ((Byte*)(bs.bytes))[off] = (Byte)n;
    ((Byte*)(bs.bytes))[++off] = (Byte)(((uint)n) >> 8);
    ((Byte*)(bs.bytes))[++off] = (Byte)(((uint)n) >> 16);
    ((Byte*)(bs.bytes))[++off] = (Byte)(((uint)n) >> 24);
}

// return == byte[], ns == int[]
+ (NSMutableData*)Int_To_LE_IntArray:(NSMutableArray*)ns {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(4 * (int)(ns.count))] autorelease];
    [Pack Int_To_LE_IntArray:ns withBs:bs withOff:0];
    return bs;
}

// ns == int[], bs == byte[]
+ (void)Int_To_LE_IntArray:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off {
    for (int i = 0; i < ns.count; ++i) {
        [Pack Int_To_LE:[ns[i] intValue] withBs:bs withOff:off];
        off += 4;
    }
}

// bs == byte[]
+ (int64_t)LE_To_Int64:(NSMutableData*)bs withOff:(int)off {
    int lo = [Pack LE_To_Int:bs withOff:off];
    int hi = [Pack LE_To_Int:bs withOff:(off + 4)];
    return ((int64_t)(hi & 0xffffffffLL) << 32) | (int64_t)(lo & 0xffffffffLL);
}

// bs == byte[], ns == long[]
+ (void)LE_To_Int64:(NSMutableData*)bs withOff:(int)off withNs:(NSMutableArray*)ns {
    for (int i = 0; i < ns.count; ++i) {
        ns[i] = @([Pack LE_To_Int64:bs withOff:off]);
        off += 8;
    }
}

// return == byte[]
+ (NSMutableData*)Int64_To_LE:(int64_t)n {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:8] autorelease];
    [Pack Int64_To_LE:n withBs:bs withOff:0];
    return bs;
}

// bs == byte[]
+ (void)Int64_To_LE:(int64_t)n withBs:(NSMutableData*)bs withOff:(int)off {
    [Pack Int_To_LE:(int)(n & 0xffffffffLL) withBs:bs withOff:off];
    [Pack Int_To_LE:(int)(((uint64_t)(n)) >> 32) withBs:bs withOff:(off + 4)];
}

// return == byte[], ns == long[]
+ (NSMutableData*)Int64_To_LE_Int64Array:(NSMutableArray*)ns {
    NSMutableData *bs = [[[NSMutableData alloc] initWithSize:(8 * ns.count)] autorelease];
    [Pack Int64_To_LE_Int64Array:ns withBs:bs withOff:0];
    return bs;
}

// ns = long[], bs == byte[]
+ (void)Int64_To_LE_Int64Array:(NSMutableArray*)ns withBs:(NSMutableData*)bs withOff:(int)off {
    for (int i = 0; i < ns.count; ++i) {
        [Pack Int64_To_LE:[ns[i] longLongValue] withBs:bs withOff:off];
        off += 8;
    }
}

@end
