//
//  WNafUtilities.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "WNafUtilities.h"
#import "ECCurve.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "ECPoint.h"
#import "WNafPreCompInfo.h"
#import "ECPointMap.h"
#import "WNafPreCompInfo.h"
#import "ECAlgorithms.h"
#import "ECFieldElement.h"

@implementation WNafUtilities

+ (NSString*)PRECOMP_NAME {
    static NSString *_precomp_name = nil;
    @synchronized(self) {
        if (_precomp_name == nil) {
            _precomp_name = [[NSString alloc] initWithString:@"bc_wnaf"];
        }
    }
    return _precomp_name;
}

+ (NSArray*)DEFAULT_WINDOW_SIZE_CUTOFFS {
    static NSArray *_default_window_size_cutoffs  = nil;
    @synchronized(self) {
        if (_default_window_size_cutoffs == nil) {
            @autoreleasepool {
                _default_window_size_cutoffs = [[NSArray alloc] initWithObjects:@((int)13), @((int)41), @((int)121), @((int)337), @((int)897), @((int)2305), nil];
            }
        }
    }
    return _default_window_size_cutoffs;
}

+ (NSData*)EMPTY_BYTES {
    static NSData *_empty_bytes  = nil;
    @synchronized(self) {
        if (_empty_bytes == nil) {
            _empty_bytes = [[NSData alloc] init];
        }
    }
    return _empty_bytes;
}

+ (NSArray*)EMPTY_INTS {
    static NSArray *_empty_ints  = nil;
    @synchronized(self) {
        if (_empty_ints == nil) {
            _empty_ints = [[NSArray alloc] init];
        }
    }
    return _empty_ints;
}

// NSArray == ECPoint[]
+ (NSArray*)EMPTY_POINTS {
    static NSArray *_empty_points  = nil;
    @synchronized(self) {
        if (_empty_points == nil) {
            _empty_points = [[NSArray alloc] init];
        }
    }
    return _empty_points;
}

// return == int[]
+ (NSMutableArray*)generateCompactNaf:(BigInteger*)k {
    if (([k bitLength] >> 16) != 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"k must have bitlength < 2^16" userInfo:nil];
    }
    if ([k signValue] == 0) {
        return [[[WNafUtilities EMPTY_INTS] mutableCopy] autorelease];
    }
    
    NSMutableArray *naf = nil;
    @autoreleasepool {
        BigInteger *_3k = [[k shiftLeftWithN:1] addWithValue:k];
        
        int bits = [_3k bitLength];
        naf = [[NSMutableArray alloc] initWithSize:(bits >> 1)];
        
        BigInteger *diff = [_3k xorWithValue:k];
        
        int highBit = bits - 1, length = 0, zeroes = 0;
        for (int i = 1; i < highBit; ++i) {
            if (![diff testBitWithN:i]) {
                ++zeroes;
                continue;
            }
            
            int digit = [k testBitWithN:i] ? -1 : 1;
            naf[length++] = @((int)((digit << 16) | zeroes));
            zeroes = 1;
            ++i;
        }
        
        naf[length++] = @((int)((1 << 16) | zeroes));
        
        if ([naf count] > length) {
            [naf setFixedSize:length];
        }
    }
    return (naf ? [naf autorelease] : nil);
}

// return == int[]
+ (NSMutableArray*)generateCompactWindowNaf:(int)width withK:(BigInteger*)k {
    if (width == 2) {
        return [WNafUtilities generateCompactNaf:k];
    }
    
    if (width < 2 || width > 16) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"width must be in the range [2, 16]" userInfo:nil];
    }
    if (([k bitLength] >> 16) != 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"k must have bitlength < 2^16" userInfo:nil];
    }
    if ([k signValue] == 0) {
        return [[[WNafUtilities EMPTY_INTS] mutableCopy] autorelease];
    }
    
    NSMutableArray *wnaf = nil;
    @autoreleasepool {
        wnaf = [[NSMutableArray alloc] initWithSize:([k bitLength] / width + 1)];
        
        // 2^width and a mask and sign bit set accordingly
        int pow2 = 1 << width;
        int mask = pow2 - 1;
        int sign = pow2 >> 1;
        
        BOOL carry = NO;
        int length = 0, pos = 0;
        
        while (pos <= [k bitLength]) {
            if ([k testBitWithN:pos] == carry) {
                ++pos;
                continue;
            }
            
            k = [k shiftRightWithN:pos];
            
            int digit = [k intValue] & mask;
            if (carry) {
                ++digit;
            }
            
            carry = (digit & sign) != 0;
            if (carry) {
                digit -= pow2;
            }
            
            int zeroes = length > 0 ? pos - 1 : pos;
            wnaf[length++] = @((int)((digit << 16) | zeroes));
            pos = width;
        }
        
        // Reduce the WNAF array to its actual length
        if ([wnaf count] > length) {
            [wnaf setFixedSize:length];
        }
    }
    return (wnaf ? [wnaf autorelease] : nil);
}

// return == byte[]
+ (NSMutableData*)generateJsf:(BigInteger*)g withH:(BigInteger*)h {
    int digits = MAX([g bitLength], [h bitLength]) + 1;
    
    NSMutableData *jsf = nil;
    @autoreleasepool {
        jsf = [[NSMutableData alloc] initWithSize:digits];
        
        BigInteger *k0 = g, *k1 = h;
        int j = 0, d0 = 0, d1 = 0;
        
        int offset = 0;
        while ((d0 | d1) != 0 || [k0 bitLength] > offset || [k1 bitLength] > offset) {
            int n0 = ((int)((uint)[k0 intValue] >> offset) + d0) & 7;
            int n1 = ((int)((uint)[k1 intValue] >> offset) + d1) & 7;
            
            int u0 = n0 & 1;
            if (u0 != 0) {
                u0 -= (n0 & 2);
                if ((n0 + u0) == 4 && (n1 & 3) == 2) {
                    u0 = -u0;
                }
            }
            
            int u1 = n1 & 1;
            if (u1 != 0) {
                u1 -= (n1 & 2);
                if ((n1 + u1) == 4 && (n0 & 3) == 2) {
                    u1 = -u1;
                }
            }
            
            if ((d0 << 1) == 1 + u0) {
                d0 ^= 1;
            }
            if ((d1 << 1) == 1 + u1) {
                d1 ^= 1;
            }
            
            if (++offset == 30) {
                offset = 0;
                k0 = [k0 shiftRightWithN:30];
                k1 = [k1 shiftRightWithN:30];
            }
            
            ((Byte*)(jsf.bytes))[j++] = (Byte)((u0 << 4) | (u1 & 0xF));
        }
        
        // Reduce the JSF array to its actual length
        if ([jsf length] > j) {
            [jsf setFixedSize:j];
        }
    }
    return (jsf ? [jsf autorelease] : nil);
}

// return == byte[]
+ (NSMutableData*)generateNaf:(BigInteger*)k {
    if ([k signValue] == 0) {
        return [[[WNafUtilities EMPTY_BYTES] mutableCopy] autorelease];
    }
    
    NSMutableData *naf = nil;
    @autoreleasepool {
        BigInteger *_3k = [[k shiftLeftWithN:1] addWithValue:k];
        
        int digits = [_3k bitLength] - 1;
        naf = [[NSMutableData alloc] initWithSize:digits];
        
        BigInteger *diff = [_3k xorWithValue:k];
        
        for (int i = 1; i < digits; ++i) {
            if ([diff testBitWithN:i]) {
                ((Byte*)(naf.bytes))[i - 1] = (Byte)([k testBitWithN:i] ? -1 : 1);
                ++i;
            }
        }
        
        ((Byte*)(naf.bytes))[digits - 1] = (Byte)1;
        
    }
    
    return (naf ? [naf autorelease] : nil);
}

/**
 * Computes the Window NAF (non-adjacent Form) of an integer.
 * @param width The width <code>w</code> of the Window NAF. The width is
 * defined as the minimal number <code>w</code>, such that for any
 * <code>w</code> consecutive digits in the resulting representation, at
 * most one is non-zero.
 * @param k The integer of which the Window NAF is computed.
 * @return The Window NAF of the given width, such that the following holds:
 * <code>k = &amp;sum;<sub>i=0</sub><sup>l-1</sup> k<sub>i</sub>2<sup>i</sup>
 * </code>, where the <code>k<sub>i</sub></code> denote the elements of the
 * returned <code>byte[]</code>.
 */
+ (NSMutableData*)generateWindowNaf:(int)width withK:(BigInteger*)k {
    if (width == 2) {
        return [WNafUtilities generateNaf:k];
    }
    
    if (width < 2 || width > 8) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"width must be in the range [2, 8]" userInfo:nil];
    }
    if ([k signValue] == 0) {
        return [[[WNafUtilities EMPTY_BYTES] mutableCopy] autorelease];
    }
    
    NSMutableData *wnaf = nil;
    @autoreleasepool {
        wnaf = [[NSMutableData alloc] initWithSize:([k bitLength] + 1)];
        
        // 2^width and a mask and sign bit set accordingly
        int pow2 = 1 << width;
        int mask = pow2 - 1;
        int sign = pow2 >> 1;
        
        BOOL carry = NO;
        int length = 0, pos = 0;
        
        while (pos <= [k bitLength]) {
            if ([k testBitWithN:pos] == carry) {
                ++pos;
                continue;
            }
            
            k = [k shiftRightWithN:pos];
            
            int digit = [k intValue] & mask;
            if (carry) {
                ++digit;
            }
            
            carry = (digit & sign) != 0;
            if (carry) {
                digit -= pow2;
            }
            
            length += (length > 0) ? pos - 1 : pos;
            ((Byte*)(wnaf.bytes))[length++] = (Byte)digit;
            pos = width;
        }
        
        // Reduce the WNAF array to its actual length
        if ([wnaf length] > length) {
            [wnaf setFixedSize:length];
        }
    }
    return (wnaf ? [wnaf autorelease] : nil);
}

+ (int)getNafWeight:(BigInteger*)k {
    if ([k signValue] == 0) {
        return 0;
    }
    
    int retVal = 0;
    @autoreleasepool {
        BigInteger *_3k = [[k shiftLeftWithN:1] addWithValue:k];
        BigInteger *diff = [_3k xorWithValue:k];
        retVal = [diff bitCount];
    }
    return retVal;
}

+ (WNafPreCompInfo*)getWNafPreCompInfoWithECPoint:(ECPoint*)p {
    return [WNafUtilities getWNafPreCompInfoWithPreCompInfo:[[p curve] getPreCompInfo:p withName:[WNafUtilities PRECOMP_NAME]]];
}

+ (WNafPreCompInfo*)getWNafPreCompInfoWithPreCompInfo:(PreCompInfo*)preCompInfo {
    if (preCompInfo != nil && [preCompInfo isKindOfClass:[WNafPreCompInfo class]]) {
        return (WNafPreCompInfo*)preCompInfo;
    }
    
    return [[[WNafPreCompInfo alloc] init] autorelease];
}

/**
 * Determine window width to use for a scalar multiplication of the given size.
 *
 * @param bits the bit-length of the scalar to multiply by
 * @return the window size to use
 */
+ (int)getWindowSize:(int)bits {
    int retVal = 0;
    NSMutableArray *tmpArray = [[WNafUtilities DEFAULT_WINDOW_SIZE_CUTOFFS] mutableCopy];
    retVal = [WNafUtilities getWindowSize:bits withWindowSizeCutoffs:tmpArray];
#if !__has_feature(objc_arc)
    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
    return retVal;
}

/**
 * Determine window width to use for a scalar multiplication of the given size.
 *
 * @param bits the bit-length of the scalar to multiply by
 * @param windowSizeCutoffs a monotonically increasing list of bit sizes at which to increment the window width
 * @return the window size to use
 */
// windowSizeCutoffs == int[]
+ (int)getWindowSize:(int)bits withWindowSizeCutoffs:(NSMutableArray*)windowSizeCutoffs {
    int w = 0;
    for (; w < [windowSizeCutoffs count]; ++w) {
        if (bits < [windowSizeCutoffs[w] intValue]) {
            break;
        }
    }
    return w + 2;
}

+ (ECPoint*)mapPointWithPrecomp:(ECPoint*)p withWidth:(int)width withIncludeNegated:(BOOL)includeNegated withPointMap:(ECPointMap*)pointMap {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *c = [p curve];
        WNafPreCompInfo *wnafPreCompP = [WNafUtilities precompute:p withWidth:width withIncludeNegated:includeNegated];
        
        ECPoint *q = [pointMap map:p];
        WNafPreCompInfo *wnafPreCompQ = [WNafUtilities getWNafPreCompInfoWithPreCompInfo:[c getPreCompInfo:q withName:[WNafUtilities PRECOMP_NAME]]];
        
        ECPoint *twiceP = [wnafPreCompP twice];
        if (twiceP != nil) {
            ECPoint *twiceQ = [pointMap map:twiceP];
            [wnafPreCompQ setTwice:twiceQ];
        }
        
        // NSMutableArray == ECPoint[]
        NSMutableArray *preCompP = [wnafPreCompP preComp];
        NSMutableArray *preCompQ = [[NSMutableArray alloc] initWithSize:(int)(preCompP.count)];
        for (int i = 0; i < [preCompP count]; ++i) {
            preCompQ[i] = [pointMap map:preCompP[i]];
        }
        [wnafPreCompQ setPreComp:preCompQ];
        
        if (includeNegated) {
            // NSMutableArray == ECPoint[]
            NSMutableArray *preCompNegQ = [[NSMutableArray alloc] initWithSize:(int)(preCompQ.count)];
            for (int i = 0; i < preCompNegQ.count; ++i) {
                preCompNegQ[i] = [preCompQ[i] negate];
            }
            [wnafPreCompQ setPreCompNeg:preCompNegQ];
#if !__has_feature(objc_arc)
            if (preCompNegQ != nil) [preCompNegQ release]; preCompNegQ = nil;
#endif
        }
        [c setPreCompInfo:q withName:[WNafUtilities PRECOMP_NAME] withPreCompInfo:wnafPreCompQ];
#if !__has_feature(objc_arc)
        if (preCompQ != nil) [preCompQ release]; preCompQ = nil;
#endif
        retPoint = q;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

+ (WNafPreCompInfo*)precompute:(ECPoint*)p withWidth:(int)width withIncludeNegated:(BOOL)includeNegated {
    ECCurve *c = [p curve];
    WNafPreCompInfo *wnafPreCompInfo = nil;
    @autoreleasepool {
        wnafPreCompInfo = [WNafUtilities getWNafPreCompInfoWithPreCompInfo:[c getPreCompInfo:p withName:[WNafUtilities PRECOMP_NAME]]];
        
        int iniPreCompLen = 0, reqPreCompLen = 1 << MAX(0, (width - 2));
        
        // preComp == ECPoint[]
        NSMutableArray *preComp = [wnafPreCompInfo preComp];
        if (preComp == nil) {
            preComp = [[WNafUtilities EMPTY_POINTS] mutableCopy];
        } else {
            [preComp retain];
            iniPreCompLen = (int)(preComp.count);
        }
        
        if (iniPreCompLen < reqPreCompLen) {
            [preComp setFixedSize:iniPreCompLen];
            
            if (reqPreCompLen == 1) {
                preComp[0] = [p normalize];
            } else {
                int curPreCompLen = iniPreCompLen;
                if (curPreCompLen == 0) {
                    preComp[0] = p;
                    curPreCompLen = 1;
                }
                
                ECFieldElement *iso = nil;
                
                if (reqPreCompLen == 2) {
                    preComp[1] = [p threeTimes];
                } else {
                    ECPoint *twiceP = [wnafPreCompInfo twice], *last = preComp[curPreCompLen - 1];
                    if (twiceP == nil) {
                        twiceP = [preComp[0] twice];
                        [wnafPreCompInfo setTwice:twiceP];
                        
                        /*
                         * For Fp curves with Jacobian projective coordinates, use a (quasi-)isomorphism
                         * where 'twiceP' is "affine", so that the subsequent additions are cheaper. This
                         * also requires scaling the initial point's X, Y coordinates, and reversing the
                         * isomorphism as part of the subsequent normalization.
                         *
                         *  NOTE: The correctness of this optimization depends on:
                         *      1) additions do not use the curve's A, B coefficients.
                         *      2) no special cases (i.e. Q +/- Q) when calculating 1P, 3P, 5P, ...
                         */
                        if ([ECAlgorithms isFpCurve:c] && [c fieldSize] >= 64) {
                            switch ([c coordinateSystem]) {
                                case COORD_JACOBIAN:
                                case COORD_JACOBIAN_CHUDNOVSKY:
                                case COORD_JACOBIAN_MODIFIED: {
                                    iso = [twiceP getZCoord:0];
                                    twiceP = [c createPoint:[[twiceP xCoord] toBigInteger] withY:[[twiceP yCoord] toBigInteger]];
                                    
                                    ECFieldElement *iso2 = [iso square], *iso3 = [iso2 multiply:iso];
                                    last = [[last scaleX:iso2] scaleY:iso3];
                                    
                                    if (iniPreCompLen == 0) {
                                        preComp[0] = last;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    
                    while (curPreCompLen < reqPreCompLen) {
                        /*
                         * Compute the new ECPoints for the precomputation array. The values 1, 3,
                         * 5, ..., 2^(width-1)-1 times p are computed
                         */
                        preComp[curPreCompLen++] = last = [last add:twiceP];
                    }
                }
                
                /*
                 * Having oft-used operands in affine form makes operations faster.
                 */
                [c normalizeAll:preComp withOff:iniPreCompLen withLen:(reqPreCompLen - iniPreCompLen) withIso:iso];
            }
        }
        
        [wnafPreCompInfo setPreComp:preComp];
        
        if (includeNegated) {
            // NSMutableArray == ECPoint[]
            NSMutableArray *preCompNeg = [wnafPreCompInfo preCompNeg];
            
            int pos;
            if (preCompNeg == nil) {
                pos = 0;
                preCompNeg = [[NSMutableArray alloc] initWithSize:reqPreCompLen];
            } else {
                [preCompNeg retain];
                pos = (int)(preCompNeg.count);
                if (pos < reqPreCompLen) {
                    [preCompNeg setFixedSize:reqPreCompLen];
                }
            }
            
            while (pos < reqPreCompLen) {
                preCompNeg[pos] = [preComp[pos] negate];
                ++pos;
            }
            
            [wnafPreCompInfo setPreCompNeg:preCompNeg];
#if !__has_feature(objc_arc)
            if (preCompNeg != nil) [preCompNeg release]; preCompNeg = nil;
#endif
        }
        
        [c setPreCompInfo:p withName:[WNafUtilities PRECOMP_NAME] withPreCompInfo:wnafPreCompInfo];
        
#if !__has_feature(objc_arc)
        if (preComp) [preComp release]; preComp = nil;
#endif
        [wnafPreCompInfo retain];
    }
    return (wnafPreCompInfo ? [wnafPreCompInfo autorelease] : nil);
}

@end
