//
//  Curve25519.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "Curve25519Ex.h"
#import "Arrays.h"
#import "CategoryExtend.h"

@implementation Curve25519Ex

+ (NSMutableData*)agreement:(NSMutableData*)publicKey withPrivateKey:(NSMutableData*)privateKey {
    return [Curve25519Ex getSharedSecret:[Curve25519Ex clampPrivateKey:privateKey] withPeerPublicKey:publicKey];
}

/* key size */
+ (int)KeySize {
    return 32;
}

/* group order (a prime near 2^252+2^124) */
+ (NSMutableData*)Order {
    static NSMutableData *_order = nil;
    @synchronized(self) {
        if (_order == nil) {
            Byte byte[] = {
                237, 211, 245, 92,
                26, 99, 18, 88,
                214, 156, 247, 162,
                222, 249, 222, 20,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 16
            };
            _order = [[NSMutableData alloc] initWithBytes:byte length:32];
        }
    }
    return _order;
}

/********* KEY AGREEMENT *********/

/// <summary>
/// Private key clamping (inline, for performance)
/// </summary>
/// <param name="key">[out] 32 random bytes</param>
+ (void)clampPrivateKeyInline:(NSMutableData*)key {
    if (key == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"key" userInfo:nil];
    }
    if (key.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"key must be 32 bytes long (but was %d bytes long)", key.length] userInfo:nil];
    }
    
    ((Byte*)(key.bytes))[31] = ((Byte*)(key.bytes))[31] & 0x7F;
    ((Byte*)(key.bytes))[31] = ((Byte*)(key.bytes))[31] | 0x40;
    ((Byte*)(key.bytes))[0] = ((Byte*)(key.bytes))[0] & 0xF8;
}

/// <summary>
/// Private key clamping
/// </summary>
/// <param name="rawKey">[out] 32 random bytes</param>
+ (NSMutableData*)clampPrivateKey:(NSMutableData*)rawKey {
    if (rawKey == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"rawKey" userInfo:nil];
    }
    if (rawKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"rawKey must be 32 bytes long (but was %d bytes long)", rawKey.length] userInfo:nil];
    }
    
    NSMutableData *res = [[[NSMutableData alloc] initWithSize:32] autorelease];
    [res copyFromIndex:0 withSource:rawKey withSourceIndex:0 withLength:32];
    
    ((Byte*)(res.bytes))[31] = ((Byte*)(res.bytes))[31] & 0x7F;
    ((Byte*)(res.bytes))[31] = ((Byte*)(res.bytes))[31] | 0x40;
    ((Byte*)(res.bytes))[0] = ((Byte*)(res.bytes))[0] & 0xF8;
    
    return res;
}

/// <summary>
/// Creates a random private key
/// </summary>
/// <returns>32 random bytes that are clamped to a suitable private key</returns>
+ (NSMutableData*)createRandomPrivateKey {
    NSMutableData *privateKey = [NSMutableData nextBytes:32];
    [Curve25519Ex clampPrivateKeyInline:privateKey];
    return privateKey;
}

/// <summary>
/// Key-pair generation (inline, for performance)
/// </summary>
/// <param name="publicKey">[out] public key</param>
/// <param name="signingKey">[out] signing key (ignored if NULL)</param>
/// <param name="privateKey">[out] private key</param>
/// <remarks>WARNING: if signingKey is not NULL, this function has data-dependent timing</remarks>
+ (void)keyGenInline:(NSMutableData*)publicKey withSigningKey:(NSMutableData*)signingKey withPrivateKey:(NSMutableData*)privateKey {
    if (publicKey == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"publicKey" userInfo:nil];
    }
    if (publicKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"publicKey must be 32 bytes long (but was %d bytes long)", publicKey.length] userInfo:nil];
    }
    
    if (signingKey == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"signingKey" userInfo:nil];
    }
    if (signingKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"signingKey must be 32 bytes long (but was %d bytes long)", signingKey.length] userInfo:nil];
    }
    
    if (privateKey == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"privateKey" userInfo:nil];
    }
    if (privateKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"privateKey must be 32 bytes long (but was %d bytes long)", privateKey.length] userInfo:nil];
    }
    
    NSMutableData *tmpData = [NSMutableData nextBytes:(int)(privateKey.length)];
    [privateKey copyFromIndex:0 withSource:tmpData withSourceIndex:0 withLength:(int)(tmpData.length)];
    [Curve25519Ex clampPrivateKeyInline:privateKey];
    
    [Curve25519Ex core:publicKey withSigningKey:signingKey withPrivateKey:privateKey withPeerPublicKey:nil];
}

/// <summary>
/// Generates the public key out of the clamped private key
/// </summary>
/// <param name="privateKey">private key (must use ClampPrivateKey first!)</param>
+ (NSMutableData*)getPublicKey:(NSMutableData*)privateKey {
    NSMutableData *publicKey = [[[NSMutableData alloc] initWithSize:32] autorelease];
    
    [Curve25519Ex core:publicKey withSigningKey:nil withPrivateKey:privateKey withPeerPublicKey:nil];
    return publicKey;
}

/// <summary>
/// Generates signing key out of the clamped private key
/// </summary>
/// <param name="privateKey">private key (must use ClampPrivateKey first!)</param>
+ (NSMutableData*)getSigningKey:(NSMutableData*)privateKey {
    NSMutableData *signingKey = [[[NSMutableData alloc] initWithSize:32] autorelease];
    NSMutableData *publicKey = [[NSMutableData alloc] initWithSize:32];
    
    [Curve25519Ex core:publicKey withSigningKey:signingKey withPrivateKey:privateKey withPeerPublicKey:nil];
#if !__has_feature(objc_arc)
    if (publicKey) [publicKey release]; publicKey = nil;
#endif
    return signingKey;
}

/// <summary>
/// Key agreement
/// </summary>
/// <param name="privateKey">[in] your private key for key agreement</param>
/// <param name="peerPublicKey">[in] peer's public key</param>
/// <returns>shared secret (needs hashing before use)</returns>
+ (NSMutableData*)getSharedSecret:(NSMutableData*)privateKey withPeerPublicKey:(NSMutableData*)peerPublicKey {
    NSMutableData *sharedSecret = [[[NSMutableData alloc] initWithSize:32] autorelease];
    
    [Curve25519Ex core:sharedSecret withSigningKey:nil withPrivateKey:privateKey withPeerPublicKey:peerPublicKey];
    return sharedSecret;
}

/********************* radix 2^8 math *********************/

+ (void)copy32:(NSMutableData*)source withDestination:(NSMutableData*)destination {
    [destination copyFromIndex:0 withSource:source withSourceIndex:0 withLength:32];
}

/* p[m..n+m-1] = q[m..n+m-1] + z * x */
/* n is the size of x */
/* n+m is the size of p and q */

+ (int)multiplyArraySmall:(NSMutableData*)p withQ:(NSMutableData*)q withM:(int)m withX:(NSMutableData*)x withN:(int)n withZ:(int)z {
    int v = 0;
    for (int i = 0; i < n; ++i) {
        v += (((Byte*)(q.bytes))[i + m] & 0xFF) + z * (((Byte*)(x.bytes))[i] & 0xFF);
        ((Byte*)(p.bytes))[i + m] = (Byte)v;
        v >>= 8;
    }
    return v;
}

/* p += x * y * z  where z is a small integer
 * x is size 32, y is size t, p is size 32+t
 * y is allowed to overlap with p+32 if you don't care about the upper half  */

+ (void)multiplyArray32:(NSMutableData*)p withX:(NSMutableData*)x withY:(NSMutableData*)y withT:(int)t withZ:(int)z {
    const int n = 31;
    int w = 0;
    int i = 0;
    for (; i < t; i++) {
        int zy = z * (((Byte*)(y.bytes))[i] & 0xFF);
        w += [Curve25519Ex multiplyArraySmall:p withQ:p withM:i withX:x withN:n withZ:zy] + (((Byte*)(p.bytes))[i + n] & 0xFF) + zy * (((Byte*)(x.bytes))[n] & 0xFF);
        ((Byte*)(p.bytes))[i + n] = (Byte)w;
        w >>= 8;
    }
    ((Byte*)(p.bytes))[i + n] = (Byte)(w + (((Byte*)(p.bytes))[i + n] & 0xFF));
}

/* divide r (size n) by d (size t), returning quotient q and remainder r
 * quotient is size n-t+1, remainder is size t
 * requires t > 0 && d[t-1] != 0
 * requires that r[-1] and d[-1] are valid memory locations
 * q may overlap with r+t */
+ (void)divMod:(NSMutableData*)q withR:(NSMutableData*)r withN:(int)n withD:(NSMutableData*)d withT:(int)t {
    int rn = 0;
    int dt = ((((Byte*)(d.bytes))[t - 1] & 0xFF) << 8);
    if (t > 1) {
        dt |= (((Byte*)(d.bytes))[t - 2] & 0xFF);
    }
    while (n-- >= t) {
        int z = (rn << 16) | ((((Byte*)(r.bytes))[n] & 0xFF) << 8);
        if (n > 0) {
            z |= (((Byte*)(r.bytes))[n - 1] & 0xFF);
        }
        z /= dt;
        rn += [Curve25519Ex multiplyArraySmall:r withQ:r withM:(n - t + 1) withX:d withN:t withZ:-z];
        ((Byte*)(q.bytes))[n - t + 1] = (Byte)((z + rn) & 0xFF); /* rn is 0 or -1 (underflow) */
        [Curve25519Ex multiplyArraySmall:r withQ:r withM:(n - t + 1) withX:d withN:t withZ:-rn];
        rn = (((Byte*)(r.bytes))[n] & 0xFF);
        ((Byte*)(r.bytes))[n] = 0;
    }
    ((Byte*)(r.bytes))[t - 1] = (Byte)rn;
}

+ (int)getNumSize:(NSMutableData*)num withMaxSize:(int)maxSize {
    for (int i = maxSize; i >= 0; i++) {
        if (((Byte*)(num.bytes))[i] == 0) {
            return i + 1;
        }
    }
    return 0;
}

/// <summary>
/// Returns x if a contains the gcd, y if b.
/// </summary>
/// <param name="x">x and y must have 64 bytes space for temporary use.</param>
/// <param name="y">x and y must have 64 bytes space for temporary use.</param>
/// <param name="a">requires that a[-1] and b[-1] are valid memory locations</param>
/// <param name="b">requires that a[-1] and b[-1] are valid memory locations</param>
/// <returns>Also, the returned buffer contains the inverse of a mod b as 32-byte signed.</returns>
+ (NSMutableData*)egcd32:(NSMutableData*)x withY:(NSMutableData*)y withA:(NSMutableData*)a withB:(NSMutableData*)b {
    int bn = 32;
    int i;
    for (i = 0; i < 32; i++) {
        ((Byte*)(x.bytes))[i] = ((Byte*)(y.bytes))[i] = 0;
    }
    ((Byte*)(x.bytes))[0] = 1;
    int an = [Curve25519Ex getNumSize:a withMaxSize:32];
    if (an == 0) {
        return y; /* division by zero */
    }
    NSMutableData *temp = [[NSMutableData alloc] initWithSize:32];
    while (YES) {
        int qn = bn - an + 1;
        [Curve25519Ex divMod:temp withR:b withN:bn withD:a withT:an];
        bn = [Curve25519Ex getNumSize:b withMaxSize:bn];
        if (bn == 0) {
#if !__has_feature(objc_arc)
            if (temp) [temp release]; temp = nil;
#endif
            return x;
        }
        [Curve25519Ex multiplyArray32:y withX:x withY:temp withT:qn withZ:-1];
        
        qn = an - bn + 1;
        [Curve25519Ex divMod:temp withR:a withN:an withD:b withT:bn];
        an = [Curve25519Ex getNumSize:a withMaxSize:an];
        if (an == 0) {
#if !__has_feature(objc_arc)
            if (temp) [temp release]; temp = nil;
#endif
            return y;
        }
        [Curve25519Ex multiplyArray32:x withX:y withY:temp withT:qn withZ:-1];
#if !__has_feature(objc_arc)
        if (temp) [temp release]; temp = nil;
#endif
    }
}

/********************* radix 2^25.5 GF(2^255-19) math *********************/

+ (int)P25 {
    return 33554431; /* (1 << 25) - 1 */
}

+ (int)P26 {
    return 67108863; /* (1 << 26) - 1 */
}

/* Convert to internal format from little-endian byte format */

+ (void)unpack:(Long10*)x withM:(NSMutableData*)m {
    x.n0 = ((((Byte*)(m.bytes))[0] & 0xFF)) | ((((Byte*)(m.bytes))[1] & 0xFF)) << 8 | (((Byte*)(m.bytes))[2] & 0xFF) << 16 | ((((Byte*)(m.bytes))[3] & 0xFF) & 3) << 24;
    x.n1 = ((((Byte*)(m.bytes))[3] & 0xFF) & ~3) >> 2 | (((Byte*)(m.bytes))[4] & 0xFF) << 6 | (((Byte*)(m.bytes))[5] & 0xFF) << 14 | ((((Byte*)(m.bytes))[6] & 0xFF) & 7) << 22;
    x.n2 = ((((Byte*)(m.bytes))[6] & 0xFF) & ~7) >> 3 | (((Byte*)(m.bytes))[7] & 0xFF) << 5 | (((Byte*)(m.bytes))[8] & 0xFF) << 13 | ((((Byte*)(m.bytes))[9] & 0xFF) & 31) << 21;
    x.n3 = ((((Byte*)(m.bytes))[9] & 0xFF) & ~31) >> 5 | (((Byte*)(m.bytes))[10] & 0xFF) << 3 | (((Byte*)(m.bytes))[11] & 0xFF) << 11 | ((((Byte*)(m.bytes))[12] & 0xFF) & 63) << 19;
    x.n4 = ((((Byte*)(m.bytes))[12] & 0xFF) & ~63) >> 6 | (((Byte*)(m.bytes))[13] & 0xFF) << 2 | (((Byte*)(m.bytes))[14] & 0xFF) << 10 | (((Byte*)(m.bytes))[15] & 0xFF) << 18;
    x.n5 = (((Byte*)(m.bytes))[16] & 0xFF) | (((Byte*)(m.bytes))[17] & 0xFF) << 8 | (((Byte*)(m.bytes))[18] & 0xFF) << 16 | ((((Byte*)(m.bytes))[19] & 0xFF) & 1) << 24;
    x.n6 = ((((Byte*)(m.bytes))[19] & 0xFF) & ~1) >> 1 | (((Byte*)(m.bytes))[20] & 0xFF) << 7 | (((Byte*)(m.bytes))[21] & 0xFF) << 15 | ((((Byte*)(m.bytes))[22] & 0xFF) & 7) << 23;
    x.n7 = ((((Byte*)(m.bytes))[22] & 0xFF) & ~7) >> 3 | (((Byte*)(m.bytes))[23] & 0xFF) << 5 | (((Byte*)(m.bytes))[24] & 0xFF) << 13 | ((((Byte*)(m.bytes))[25] & 0xFF) & 15) << 21;
    x.n8 = ((((Byte*)(m.bytes))[25] & 0xFF) & ~15) >> 4 | (((Byte*)(m.bytes))[26] & 0xFF) << 4 | (((Byte*)(m.bytes))[27] & 0xFF) << 12 | ((((Byte*)(m.bytes))[28] & 0xFF) & 63) << 20;
    x.n9 = ((((Byte*)(m.bytes))[28] & 0xFF) & ~63) >> 6 | (((Byte*)(m.bytes))[29] & 0xFF) << 2 | (((Byte*)(m.bytes))[30] & 0xFF) << 10 | (((Byte*)(m.bytes))[31] & 0xFF) << 18;
}

/// <summary>
/// Check if reduced-form input >= 2^255-19
/// </summary>
+ (BOOL)isOverflow:(Long10*)x {
    return (((x.n0 > [Curve25519Ex P26] - 19)) & ((x.n1 & x.n3 & x.n5 & x.n7 & x.n9) == [Curve25519Ex P25]) & ((x.n2 & x.n4 & x.n6 & x.n8) == [Curve25519Ex P26])) || (x.n9 > [Curve25519Ex P25]);
}

/* Convert from internal format to little-endian byte format.  The
 * number must be in a reduced form which is output by the following ops:
 *     unpack, mul, sqr
 *     set --  if input in range 0 .. P25
 * If you're unsure if the number is reduced, first multiply it by 1.  */

+ (void)pack:(Long10*)x withM:(NSMutableData*)m {
    int ld = ([Curve25519Ex isOverflow:x] ? 1 : 0) - ((x.n9 < 0) ? 1 : 0);
    int ud = ld * -([Curve25519Ex P25] + 1);
    ld *= 19;
    int64_t t = ld + x.n0 + (x.n1 << 26);
    ((Byte*)(m.bytes))[0] = (Byte)t;
    ((Byte*)(m.bytes))[1] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[2] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[3] = (Byte)(t >> 24);
    t = (t >> 32) + (x.n2 << 19);
    ((Byte*)(m.bytes))[4] = (Byte)t;
    ((Byte*)(m.bytes))[5] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[6] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[7] = (Byte)(t >> 24);
    t = (t >> 32) + (x.n3 << 13);
    ((Byte*)(m.bytes))[8] = (Byte)t;
    ((Byte*)(m.bytes))[9] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[10] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[11] = (Byte)(t >> 24);
    t = (t >> 32) + (x.n4 << 6);
    ((Byte*)(m.bytes))[12] = (Byte)t;
    ((Byte*)(m.bytes))[13] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[14] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[15] = (Byte)(t >> 24);
    t = (t >> 32) + x.n5 + (x.n6 << 25);
    ((Byte*)(m.bytes))[16] = (Byte)t;
    ((Byte*)(m.bytes))[17] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[18] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[19] = (Byte)(t >> 24);
    t = (t >> 32) + (x.n7 << 19);
    ((Byte*)(m.bytes))[20] = (Byte)t;
    ((Byte*)(m.bytes))[21] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[22] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[23] = (Byte)(t >> 24);
    t = (t >> 32) + (x.n8 << 12);
    ((Byte*)(m.bytes))[24] = (Byte)t;
    ((Byte*)(m.bytes))[25] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[26] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[27] = (Byte)(t >> 24);
    t = (t >> 32) + ((x.n9 + ud) << 6);
    ((Byte*)(m.bytes))[28] = (Byte)t;
    ((Byte*)(m.bytes))[29] = (Byte)(t >> 8);
    ((Byte*)(m.bytes))[30] = (Byte)(t >> 16);
    ((Byte*)(m.bytes))[31] = (Byte)(t >> 24);
}

/// <summary>
/// Copy a number
/// </summary>
+ (void)copy:(Long10*)numOut withNumIn:(Long10*)numIn {
    numOut.n0 = numIn.n0;
    numOut.n1 = numIn.n1;
    numOut.n2 = numIn.n2;
    numOut.n3 = numIn.n3;
    numOut.n4 = numIn.n4;
    numOut.n5 = numIn.n5;
    numOut.n6 = numIn.n6;
    numOut.n7 = numIn.n7;
    numOut.n8 = numIn.n8;
    numOut.n9 = numIn.n9;
}

/// <summary>
/// Set a number to value, which must be in range -185861411 .. 185861411
/// </summary>
+ (void)set:(Long10*)numOut withNumIn:(int)numIn {
    numOut.n0 = numIn;
    numOut.n1 = 0;
    numOut.n2 = 0;
    numOut.n3 = 0;
    numOut.n4 = 0;
    numOut.n5 = 0;
    numOut.n6 = 0;
    numOut.n7 = 0;
    numOut.n8 = 0;
    numOut.n9 = 0;
}

/* Add/subtract two numbers.  The inputs must be in reduced form, and the
 * output isn't, so to do another addition or subtraction on the output,
 * first multiply it by one to reduce it. */
+ (void)add:(Long10*)xy withX:(Long10*)x withY:(Long10*)y {
    xy.n0 = x.n0 + y.n0;
    xy.n1 = x.n1 + y.n1;
    xy.n2 = x.n2 + y.n2;
    xy.n3 = x.n3 + y.n3;
    xy.n4 = x.n4 + y.n4;
    xy.n5 = x.n5 + y.n5;
    xy.n6 = x.n6 + y.n6;
    xy.n7 = x.n7 + y.n7;
    xy.n8 = x.n8 + y.n8;
    xy.n9 = x.n9 + y.n9;
}

+ (void)sub:(Long10*)xy withX:(Long10*)x withY:(Long10*)y {
    xy.n0 = x.n0 - y.n0;
    xy.n1 = x.n1 - y.n1;
    xy.n2 = x.n2 - y.n2;
    xy.n3 = x.n3 - y.n3;
    xy.n4 = x.n4 - y.n4;
    xy.n5 = x.n5 - y.n5;
    xy.n6 = x.n6 - y.n6;
    xy.n7 = x.n7 - y.n7;
    xy.n8 = x.n8 - y.n8;
    xy.n9 = x.n9 - y.n9;
}

/// <summary>
/// Multiply a number by a small integer in range -185861411 .. 185861411.
/// The output is in reduced form, the input x need not be.  x and xy may point
/// to the same buffer.
/// </summary>
+ (void)mulSmall:(Long10*)xy withX:(Long10*)x withY:(long)y {
    int64_t temp = (x.n8 * y);
    xy.n8 = (temp & ((1 << 26) - 1));
    temp = (temp >> 26) + (x.n9 * y);
    xy.n9 = (temp & ((1 << 25) - 1));
    temp = 19 * (temp >> 25) + (x.n0 * y);
    xy.n0 = (temp & ((1 << 26) - 1));
    temp = (temp >> 26) + (x.n1 * y);
    xy.n1 = (temp & ((1 << 25) - 1));
    temp = (temp >> 25) + (x.n2 * y);
    xy.n2 = (temp & ((1 << 26) - 1));
    temp = (temp >> 26) + (x.n3 * y);
    xy.n3 = (temp & ((1 << 25) - 1));
    temp = (temp >> 25) + (x.n4 * y);
    xy.n4 = (temp & ((1 << 26) - 1));
    temp = (temp >> 26) + (x.n5 * y);
    xy.n5 = (temp & ((1 << 25) - 1));
    temp = (temp >> 25) + (x.n6 * y);
    xy.n6 = (temp & ((1 << 26) - 1));
    temp = (temp >> 26) + (x.n7 * y);
    xy.n7 = (temp & ((1 << 25) - 1));
    temp = (temp >> 25) + xy.n8;
    xy.n8 = (temp & ((1 << 26) - 1));
    xy.n9 += (temp >> 26);
}

/// <summary>
/// Multiply two numbers. The output is in reduced form, the inputs need not be.
/// </summary>
+ (void)multiply:(Long10*)xy withX:(Long10*)x withY:(Long10*)y {
    /* sahn0:
     * Using local variables to avoid class access.
     * This seem to improve performance a bit...
     */
    int64_t x0 = x.n0, x1 = x.n1, x2 = x.n2, x3 = x.n3, x4 = x.n4, x5 = x.n5, x6 = x.n6, x7 = x.n7, x8 = x.n8, x9 = x.n9;
    int64_t y0 = y.n0, y1 = y.n1, y2 = y.n2, y3 = y.n3, y4 = y.n4, y5 = y.n5, y6 = y.n6, y7 = y.n7, y8 = y.n8, y9 = y.n9;
    int64_t
    t = (x0 * y8) + (x2 * y6) + (x4 * y4) + (x6 * y2) + (x8 * y0) + 2 * ((x1 * y7) + (x3 * y5) + (x5 * y3) + (x7 * y1)) + 38 * (x9 * y9);
    xy.n8 = (t & ((1 << 26) - 1));
    t = (t >> 26) + (x0 * y9) + (x1 * y8) + (x2 * y7) + (x3 * y6) + (x4 * y5) + (x5 * y4) + (x6 * y3) + (x7 * y2) + (x8 * y1) + (x9 * y0);
    xy.n9 = (t & ((1 << 25) - 1));
    t = (x0 * y0) + 19 * ((t >> 25) + (x2 * y8) + (x4 * y6) + (x6 * y4) + (x8 * y2)) + 38 * ((x1 * y9) + (x3 * y7) + (x5 * y5) + (x7 * y3) + (x9 * y1));
    xy.n0 = (t & ((1 << 26) - 1));
    t = (t >> 26) + (x0 * y1) + (x1 * y0) + 19 * ((x2 * y9) + (x3 * y8) + (x4 * y7) + (x5 * y6) + (x6 * y5) + (x7 * y4) + (x8 * y3) + (x9 * y2));
    xy.n1 = (t & ((1 << 25) - 1));
    t = (t >> 25) + (x0 * y2) + (x2 * y0) + 19 * ((x4 * y8) + (x6 * y6) + (x8 * y4)) + 2 * (x1 * y1) + 38 * ((x3 * y9) + (x5 * y7) + (x7 * y5) + (x9 * y3));
    xy.n2 = (t & ((1 << 26) - 1));
    t = (t >> 26) + (x0 * y3) + (x1 * y2) + (x2 * y1) + (x3 * y0) + 19 * ((x4 * y9) + (x5 * y8) + (x6 * y7) + (x7 * y6) + (x8 * y5) + (x9 * y4));
    xy.n3 = (t & ((1 << 25) - 1));
    t = (t >> 25) + (x0 * y4) + (x2 * y2) + (x4 * y0) + 19 * ((x6 * y8) + (x8 * y6)) + 2 * ((x1 * y3) + (x3 * y1)) + 38 * ((x5 * y9) + (x7 * y7) + (x9 * y5));
    xy.n4 = (t & ((1 << 26) - 1));
    t = (t >> 26) + (x0 * y5) + (x1 * y4) + (x2 * y3) + (x3 * y2) + (x4 * y1) + (x5 * y0) + 19 * ((x6 * y9) + (x7 * y8) + (x8 * y7) + (x9 * y6));
    xy.n5 = (t & ((1 << 25) - 1));
    t = (t >> 25) + (x0 * y6) + (x2 * y4) + (x4 * y2) + (x6 * y0) + 19 * (x8 * y8) + 2 * ((x1 * y5) + (x3 * y3) + (x5 * y1)) + 38 * ((x7 * y9) + (x9 * y7));
    xy.n6 = (t & ((1 << 26) - 1));
    t = (t >> 26) + (x0 * y7) + (x1 * y6) + (x2 * y5) + (x3 * y4) + (x4 * y3) + (x5 * y2) + (x6 * y1) + (x7 * y0) + 19 * ((x8 * y9) + (x9 * y8));
    xy.n7 = (t & ((1 << 25) - 1));
    t = (t >> 25) + xy.n8;
    xy.n8 = (t & ((1 << 26) - 1));
    xy.n9 += (t >> 26);
}

/// <summary>
/// Square a number.  Optimization of  Multiply(x2, x, x)
/// </summary>
+ (void)square:(Long10*)xsqr withX:(Long10*)x {
    int64_t x0 = x.n0, x1 = x.n1, x2 = x.n2, x3 = x.n3, x4 = x.n4, x5 = x.n5, x6 = x.n6, x7 = x.n7, x8 = x.n8, x9 = x.n9;
    
    int64_t t = (x4 * x4) + 2 * ((x0 * x8) + (x2 * x6)) + 38 * (x9 * x9) + 4 * ((x1 * x7) + (x3 * x5));
    
    xsqr.n8 = (t & ((1 << 26) - 1));
    t = (t >> 26) + 2 * ((x0 * x9) + (x1 * x8) + (x2 * x7) + (x3 * x6) + (x4 * x5));
    xsqr.n9 = (t & ((1 << 25) - 1));
    t = 19 * (t >> 25) + (x0 * x0) + 38 * ((x2 * x8) + (x4 * x6) + (x5 * x5)) + 76 * ((x1 * x9) + (x3 * x7));
    xsqr.n0 = (t & ((1 << 26) - 1));
    t = (t >> 26) + 2 * (x0 * x1) + 38 * ((x2 * x9) + (x3 * x8) + (x4 * x7) + (x5 * x6));
    xsqr.n1 = (t & ((1 << 25) - 1));
    t = (t >> 25) + 19 * (x6 * x6) + 2 * ((x0 * x2) + (x1 * x1)) + 38 * (x4 * x8) + 76 * ((x3 * x9) + (x5 * x7));
    xsqr.n2 = (t & ((1 << 26) - 1));
    t = (t >> 26) + 2 * ((x0 * x3) + (x1 * x2)) + 38 * ((x4 * x9) + (x5 * x8) + (x6 * x7));
    xsqr.n3 = (t & ((1 << 25) - 1));
    t = (t >> 25) + (x2 * x2) + 2 * (x0 * x4) + 38 * ((x6 * x8) + (x7 * x7)) + 4 * (x1 * x3) + 76 * (x5 * x9);
    xsqr.n4 = (t & ((1 << 26) - 1));
    t = (t >> 26) + 2 * ((x0 * x5) + (x1 * x4) + (x2 * x3)) + 38 * ((x6 * x9) + (x7 * x8));
    xsqr.n5 = (t & ((1 << 25) - 1));
    t = (t >> 25) + 19 * (x8 * x8) + 2 * ((x0 * x6) + (x2 * x4) + (x3 * x3)) + 4 * (x1 * x5) + 76 * (x7 * x9);
    xsqr.n6 = (t & ((1 << 26) - 1));
    t = (t >> 26) + 2 * ((x0 * x7) + (x1 * x6) + (x2 * x5) + (x3 * x4)) + 38 * (x8 * x9);
    xsqr.n7 = (t & ((1 << 25) - 1));
    t = (t >> 25) + xsqr.n8;
    xsqr.n8 = (t & ((1 << 26) - 1));
    xsqr.n9 += (t >> 26);
}

/// <summary>
/// Calculates a reciprocal.  The output is in reduced form, the inputs need not
/// be.  Simply calculates  y = x^(p-2)  so it's not too fast. */
/// When sqrtassist is true, it instead calculates y = x^((p-5)/8)
/// </summary>
+ (void)reciprocal:(Long10*)y withX:(Long10*)x withSqrtAssist:(BOOL)sqrtAssist {
    Long10 *t0 = [[Long10 alloc] init], *t1 = [[Long10 alloc] init], *t2 = [[Long10 alloc] init], *t3 = [[Long10 alloc] init], *t4 = [[Long10 alloc] init];
    int i;
    /* the chain for x^(2^255-21) is straight from djb's implementation */
    [Curve25519Ex square:t1 withX:x]; /*  2 == 2 * 1	*/
    [Curve25519Ex square:t2 withX:t1]; /*  4 == 2 * 2	*/
    [Curve25519Ex square:t0 withX:t2]; /*  8 == 2 * 4	*/
    [Curve25519Ex multiply:t2 withX:t0 withY:x]; /*  9 == 8 + 1	*/
    [Curve25519Ex multiply:t0 withX:t2 withY:t1]; /* 11 == 9 + 2	*/
    [Curve25519Ex square:t1 withX:t0]; /* 22 == 2 * 11	*/
    [Curve25519Ex multiply:t3 withX:t1 withY:t2]; /* 31 == 22 + 9 == 2^5   - 2^0	*/
    [Curve25519Ex square:t1 withX:t3]; /* 2^6   - 2^1	*/
    [Curve25519Ex square:t2 withX:t1]; /* 2^7   - 2^2	*/
    [Curve25519Ex square:t1 withX:t2]; /* 2^8   - 2^3	*/
    [Curve25519Ex square:t2 withX:t1]; /* 2^9   - 2^4	*/
    [Curve25519Ex square:t1 withX:t2]; /* 2^10  - 2^5	*/
    [Curve25519Ex multiply:t2 withX:t1 withY:t3]; /* 2^10  - 2^0	*/
    [Curve25519Ex square:t1 withX:t2]; /* 2^11  - 2^1	*/
    [Curve25519Ex square:t3 withX:t1]; /* 2^12  - 2^2	*/
    for (i = 1; i < 5; i++) {
        [Curve25519Ex square:t1 withX:t3];
        [Curve25519Ex square:t3 withX:t1];
    } /* t3 */ /* 2^20  - 2^10	*/
    [Curve25519Ex multiply:t1 withX:t3 withY:t2]; /* 2^20  - 2^0	*/
    [Curve25519Ex square:t3 withX:t1]; /* 2^21  - 2^1	*/
    [Curve25519Ex square:t4 withX:t3]; /* 2^22  - 2^2	*/
    for (i = 1; i < 10; i++) {
        [Curve25519Ex square:t3 withX:t4];
        [Curve25519Ex square:t4 withX:t3];
    } /* t4 */ /* 2^40  - 2^20	*/
    [Curve25519Ex multiply:t3 withX:t4 withY:t1]; /* 2^40  - 2^0	*/
    for (i = 0; i < 5; i++) {
        [Curve25519Ex square:t1 withX:t3];
        [Curve25519Ex square:t3 withX:t1];
    } /* t3 */ /* 2^50  - 2^10	*/
    [Curve25519Ex multiply:t1 withX:t3 withY:t2]; /* 2^50  - 2^0	*/
    [Curve25519Ex square:t2 withX:t1]; /* 2^51  - 2^1	*/
    [Curve25519Ex square:t3 withX:t2]; /* 2^52  - 2^2	*/
    for (i = 1; i < 25; i++) {
        [Curve25519Ex square:t2 withX:t3];
        [Curve25519Ex square:t3 withX:t2];
    } /* t3 */ /* 2^100 - 2^50 */
    [Curve25519Ex multiply:t2 withX:t3 withY:t1]; /* 2^100 - 2^0	*/
    [Curve25519Ex square:t3 withX:t2]; /* 2^101 - 2^1	*/
    [Curve25519Ex square:t4 withX:t3]; /* 2^102 - 2^2	*/
    for (i = 1; i < 50; i++) {
        [Curve25519Ex square:t3 withX:t4];
        [Curve25519Ex square:t4 withX:t3];
    } /* t4 */ /* 2^200 - 2^100 */
    [Curve25519Ex multiply:t3 withX:t4 withY:t2]; /* 2^200 - 2^0	*/
    for (i = 0; i < 25; i++) {
        [Curve25519Ex square:t4 withX:t3];
        [Curve25519Ex square:t3 withX:t4];
    } /* t3 */ /* 2^250 - 2^50	*/
    [Curve25519Ex multiply:t2 withX:t3 withY:t1]; /* 2^250 - 2^0	*/
    [Curve25519Ex square:t1 withX:t2]; /* 2^251 - 2^1	*/
    [Curve25519Ex square:t2 withX:t1]; /* 2^252 - 2^2	*/
    if (sqrtAssist) {
        [Curve25519Ex multiply:y withX:x withY:t2]; /* 2^252 - 3 */
    } else {
        [Curve25519Ex square:t1 withX:t2]; /* 2^253 - 2^3	*/
        [Curve25519Ex square:t2 withX:t1]; /* 2^254 - 2^4	*/
        [Curve25519Ex square:t1 withX:t2]; /* 2^255 - 2^5	*/
        [Curve25519Ex multiply:y withX:t1 withY:t0]; /* 2^255 - 21	*/
    }
#if !__has_feature(objc_arc)
    if (t0) [t0 release]; t0 = nil;
    if (t1) [t1 release]; t1 = nil;
    if (t2) [t2 release]; t2 = nil;
    if (t3) [t3 release]; t3 = nil;
    if (t4) [t4 release]; t4 = nil;
#endif
}

/// <summary>
/// Checks if x is "negative", requires reduced input
/// </summary>
/// <param name="x">must be reduced input</param>
+ (int)isNegative:(Long10*)x {
    return (int)((([Curve25519Ex isOverflow:x] | (x.n9 < 0)) ? 1 : 0) ^ (x.n0 & 1));
}

/********************* Elliptic curve *********************/

/* y^2 = x^3 + 486662 x^2 + x  over GF(2^255-19) */

/* t1 = ax + az
 * t2 = ax - az  */

+ (void)montyPrepare:(Long10*)t1 withT2:(Long10*)t2 withAx:(Long10*)ax withAz:(Long10*)az {
    [Curve25519Ex add:t1 withX:ax withY:az];
    [Curve25519Ex sub:t2 withX:ax withY:az];
}

/* A = P + Q   where
 *  X(A) = ax/az
 *  X(P) = (t1+t2)/(t1-t2)
 *  X(Q) = (t3+t4)/(t3-t4)
 *  X(P-Q) = dx
 * clobbers t1 and t2, preserves t3 and t4  */

+ (void)montyAdd:(Long10*)t1 withT2:(Long10*)t2 withT3:(Long10*)t3 withT4:(Long10*)t4 withAx:(Long10*)ax withAz:(Long10*)az withDx:(Long10*)dx {
    [Curve25519Ex multiply:ax withX:t2 withY:t3];
    [Curve25519Ex multiply:az withX:t1 withY:t4];
    [Curve25519Ex add:t1 withX:ax withY:az];
    [Curve25519Ex sub:t2 withX:ax withY:az];
    [Curve25519Ex square:ax withX:t1];
    [Curve25519Ex square:t1 withX:t2];
    [Curve25519Ex multiply:az withX:t1 withY:dx];
}

/* B = 2 * Q   where
 *  X(B) = bx/bz
 *  X(Q) = (t3+t4)/(t3-t4)
 * clobbers t1 and t2, preserves t3 and t4  */

+ (void)montyDouble:(Long10*)t1 withT2:(Long10*)t2 withT3:(Long10*)t3 withT4:(Long10*)t4 withBx:(Long10*)bx withBz:(Long10*)bz {
    [Curve25519Ex square:t1 withX:t3];
    [Curve25519Ex square:t2 withX:t4];
    [Curve25519Ex multiply:bx withX:t1 withY:t2];
    [Curve25519Ex sub:t2 withX:t1 withY:t2];
    [Curve25519Ex mulSmall:bz withX:t2 withY:121665];
    [Curve25519Ex add:t1 withX:t1 withY:bz];
    [Curve25519Ex multiply:bz withX:t1 withY:t2];
}

/// <summary>
/// Y^2 = X^3 + 486662 X^2 + X
/// </summary>
/// <param name="y2">output</param>
/// <param name="x">X</param>
/// <param name="temp">temporary</param>
+ (void)curveEquationInline:(Long10*)y2 withX:(Long10*)x withTemp:(Long10*)temp {
    [Curve25519Ex square:temp withX:x];
    [Curve25519Ex mulSmall:y2 withX:x withY:486662];
    [Curve25519Ex add:temp withX:temp withY:y2];
    temp.n0++;
    [Curve25519Ex multiply:y2 withX:temp withY:x];
}

/// <summary>
/// P = kG   and  s = sign(P)/k
/// </summary>
+ (void)core:(NSMutableData*)publicKey withSigningKey:(NSMutableData*)signingKey withPrivateKey:(NSMutableData*)privateKey withPeerPublicKey:(NSMutableData*)peerPublicKey {
    if (publicKey == nil) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"publicKey" userInfo:nil];
    }
    if (publicKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"publicKey must be 32 bytes long (but was %d bytes long)", publicKey.length] userInfo:nil];
    }
    
    if (signingKey != nil && signingKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"signingKey must be 32 bytes long (but was %d bytes long)", signingKey.length] userInfo:nil];
    }
    
    if (privateKey == nil) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"privateKey" userInfo:nil];
    }
    if (privateKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"privateKey must be 32 bytes long (but was %d bytes long)", privateKey.length] userInfo:nil];
    }
    
    if (peerPublicKey != nil && peerPublicKey.length != 32) {
        @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"peerPublicKey must be 32 bytes long (but was %d bytes long)", peerPublicKey.length] userInfo:nil];
    }
    
    Long10 *dx = [[Long10 alloc] init], *t1 = [[Long10 alloc] init], *t2 = [[Long10 alloc] init], *t3 = [[Long10 alloc] init], *t4 = [[Long10 alloc] init];
    
    NSMutableArray *x = [[NSMutableArray alloc] init];
    Long10 *tmp = [[Long10 alloc] init];
    [x addObject:tmp];
#if !__has_feature(objc_arc)
    if (tmp) [tmp release]; tmp = nil;
#endif
    tmp = [[Long10 alloc] init];
    [x addObject:tmp];
#if !__has_feature(objc_arc)
    if (tmp) [tmp release]; tmp = nil;
#endif
    NSMutableArray *z = [[NSMutableArray alloc] init];
    tmp = [[Long10 alloc] init];
    [z addObject:tmp];
#if !__has_feature(objc_arc)
    if (tmp) [tmp release]; tmp = nil;
#endif
    tmp = [[Long10 alloc] init];
    [z addObject:tmp];
#if !__has_feature(objc_arc)
    if (tmp) [tmp release]; tmp = nil;
#endif
    
    /* unpack the base */
    if (peerPublicKey != nil) {
        [Curve25519Ex unpack:dx withM:peerPublicKey];
    } else {
        [Curve25519Ex set:dx withNumIn:9];
    }
    
    /* 0G = point-at-infinity */
    [Curve25519Ex set:(Long10*)[x objectAtIndex:0] withNumIn:1];
    [Curve25519Ex set:(Long10*)[z objectAtIndex:0] withNumIn:0];
    
    /* 1G = G */
    [Curve25519Ex copy:(Long10*)[x objectAtIndex:1] withNumIn:dx];
    [Curve25519Ex set:(Long10*)[z objectAtIndex:1] withNumIn:1];
    
    for (int i = 32; i-- != 0; ) {
        for (int j = 8; j-- != 0; ) {
            /* swap arguments depending on bit */
            int bit1 = (((Byte*)(privateKey.bytes))[i] & 0xFF) >> j & 1;
            int bit0 = ~(((Byte*)(privateKey.bytes))[i] & 0xFF) >> j & 1;
            Long10 *ax = (Long10*)[x objectAtIndex:bit0];
            Long10 *az = (Long10*)[z objectAtIndex:bit0];
            Long10 *bx = (Long10*)[x objectAtIndex:bit1];
            Long10 *bz = (Long10*)[z objectAtIndex:bit1];
            
            /* a' = a + b	*/
            /* b' = 2 b	*/
            [Curve25519Ex montyPrepare:t1 withT2:t2 withAx:ax withAz:az];
            [Curve25519Ex montyPrepare:t3 withT2:t4 withAx:bx withAz:bz];
            [Curve25519Ex montyAdd:t1 withT2:t2 withT3:t3 withT4:t4 withAx:ax withAz:az withDx:dx];
            [Curve25519Ex montyDouble:t1 withT2:t2 withT3:t3 withT4:t4 withBx:bx withBz:bz];
        }
    }
    
    [Curve25519Ex reciprocal:t1 withX:(Long10*)[z objectAtIndex:0] withSqrtAssist:NO];
    [Curve25519Ex multiply:dx withX:(Long10*)[x objectAtIndex:0] withY:t1];
    [Curve25519Ex pack:dx withM:publicKey];
    
    /* calculate s such that s abs(P) = G  .. assumes G is std base point */
    if (signingKey != nil) {
        [Curve25519Ex curveEquationInline:t1 withX:dx withTemp:t2]; /* t1 = Py^2  */
        [Curve25519Ex reciprocal:t3 withX:(Long10*)[z objectAtIndex:1] withSqrtAssist:NO]; /* where Q=P+G ... */
        [Curve25519Ex multiply:t2 withX:(Long10*)[x objectAtIndex:1] withY:t3]; /* t2 = Qx  */
        [Curve25519Ex add:t2 withX:t2 withY:dx]; /* t2 = Qx + Px  */
        t2.n0 += 9 + 486662; /* t2 = Qx + Px + Gx + 486662  */
        dx.n0 -= 9; /* dx = Px - Gx  */
        [Curve25519Ex square:t3 withX:dx]; /* t3 = (Px - Gx)^2  */
        [Curve25519Ex multiply:dx withX:t2 withY:t3]; /* dx = t2 (Px - Gx)^2  */
        [Curve25519Ex sub:dx withX:dx withY:t1]; /* dx = t2 (Px - Gx)^2 - Py^2  */
        dx.n0 -= 39420360; /* dx = t2 (Px - Gx)^2 - Py^2 - Gy^2  */
        [Curve25519Ex multiply:t1 withX:dx withY:[Curve25519Ex BaseR2Y]]; /* t1 = -Py  */
        if ([Curve25519Ex isNegative:t1] != 0) {
            /* sign is 1, so just copy  */
            [Curve25519Ex copy32:privateKey withDestination:signingKey];
        } else {
            /* sign is -1, so negate  */
            [Curve25519Ex multiplyArraySmall:signingKey withQ:[Curve25519Ex OrderTimes8] withM:0 withX:privateKey withN:32 withZ:-1];
        }
        
        /* take reciprocal of s mod q */
        NSMutableData *temp1 = [[NSMutableData alloc] initWithSize:32];
        NSMutableData *temp2 = [[NSMutableData alloc] initWithSize:64];
        NSMutableData *temp3 = [[NSMutableData alloc] initWithSize:64];
        [Curve25519Ex copy32:[Curve25519Ex Order] withDestination:temp1];
        [Curve25519Ex copy32:[Curve25519Ex egcd32:temp2 withY:temp3 withA:signingKey withB:temp1] withDestination:signingKey];
        if ((((Byte*)(signingKey.bytes))[31] & 0x80) != 0) {
            [Curve25519Ex multiplyArraySmall:signingKey withQ:signingKey withM:0 withX:[Curve25519Ex Order] withN:32 withZ:1];
        }
#if !__has_feature(objc_arc)
        if (temp1) [temp1 release]; temp1 = nil;
        if (temp2) [temp2 release]; temp2 = nil;
        if (temp3) [temp3 release]; temp3 = nil;
#endif
    }
    
#if !__has_feature(objc_arc)
    if (x) [x release]; x = nil;
    if (z) [z release]; z = nil;
    if (dx) [dx release]; dx = nil;
    if (t1) [t1 release]; t1 = nil;
    if (t2) [t2 release]; t2 = nil;
    if (t3) [t3 release]; t3 = nil;
    if (t4) [t4 release]; t4 = nil;
#endif
}

/// <summary>
/// Smallest multiple of the order that's >= 2^255
/// </summary>
+ (NSMutableData*)OrderTimes8 {
    static NSMutableData *_orderTimes8 = nil;
    @synchronized(self) {
        if (_orderTimes8 == nil) {
            Byte byte[] = {
                104, 159, 174, 231,
                210, 24, 147, 192,
                178, 230, 188, 23,
                245, 206, 247, 166,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 128
            };
            _orderTimes8 = [[NSMutableData alloc] initWithBytes:byte length:32];
        }
    }
    return _orderTimes8;
}

/// <summary>
/// Constant 1/(2Gy)
/// </summary>
+ (Long10*)BaseR2Y {
    static Long10 *_baseR2Y = nil;
    @synchronized(self) {
        if (_baseR2Y == nil) {
            _baseR2Y = [[Long10 alloc] initWithN0:5744 withN1:8160848 withN2:4790893 withN3:13779497 withN4:35730846 withN5:12541209 withN6:49101323 withN7:30047407 withN8:40071253 withN9:6226132];
        }
    }
    return _baseR2Y;
}

@end


/* sahn0:
 * Using this class instead of long[10] to avoid bounds checks. */

@implementation Long10
@synthesize n0 = _n0;
@synthesize n1 = _n1;
@synthesize n2 = _n2;
@synthesize n3 = _n3;
@synthesize n4 = _n4;
@synthesize n5 = _n5;
@synthesize n6 = _n6;
@synthesize n7 = _n7;
@synthesize n8 = _n8;
@synthesize n9 = _n9;

- (id)initWithN0:(int64_t)n0 withN1:(int64_t)n1 withN2:(int64_t)n2 withN3:(int64_t)n3 withN4:(int64_t)n4 withN5:(int64_t)n5 withN6:(int64_t)n6 withN7:(int64_t)n7 withN8:(int64_t)n8 withN9:(int64_t)n9 {
    if (self = [super init]) {
        [self setN0:n0];
        [self setN1:n1];
        [self setN2:n2];
        [self setN3:n3];
        [self setN4:n4];
        [self setN5:n5];
        [self setN6:n6];
        [self setN7:n7];
        [self setN8:n8];
        [self setN9:n9];
        return self;
    } else {
        return nil;
    }
}

@end