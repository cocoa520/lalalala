//
//  ECAlgorithms.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "ECAlgorithms.h"
#import "CategoryExtend.h"
#import "ECCurve.h"
#import "ECFieldElement.h"
#import "IFiniteField.h"
#import "ECPoint.h"
#import "ECPointMap.h"
#import "GlvEndomorphism.h"
#import "BigInteger.h"
#import "IPolynomialExtensionField.h"
#import "WNafUtilities.h"
#import "WNafPreCompInfo.h"

@implementation ECAlgorithms

+ (BOOL)isF2mCurve:(ECCurve*)c {
    return [ECAlgorithms isF2mField:[c field]];
}

+ (BOOL)isF2mField:(IFiniteField*)field {
    return [field dimension] > 1 && [[field characteristic] isEqual:[BigInteger Two]] && [field isKindOfClass:[IPolynomialExtensionField class]];
}

+ (BOOL)isFpCurve:(ECCurve*)c {
    return [ECAlgorithms isFpField:[c field]];
}

+ (BOOL)isFpField:(IFiniteField*)field {
    return [field dimension] == 1;
}

// ps == ECPoint[], ks == BigInteger[]
+ (ECPoint*)sumOfMultiplies:(NSMutableArray*)ps withKs:(NSMutableArray*)ks {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        if (ps == nil || ks == nil || ps.count != ks.count || ps.count < 1) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"point and scalar arrays should be non-null, and of equal, non-zero, length" userInfo:nil];
        }
        
        int count = (int)(ps.count);
        switch (count) {
            case 1: {
                retPoint = [((ECPoint*)ps[0]) multiply:ks[0]];
                goto jumpTo;
                break;
            }
            case 2: {
                retPoint = [ECAlgorithms sumOfTwoMultiplies:ps[0] withA:ks[0] withQ:ps[1] withB:ks[1]];
                goto jumpTo;
                break;
            }
            default: {
                break;
            }
        }
        
        ECPoint *p = ps[0];
        ECCurve *c = [p curve];
        
        // NSMutableArray == ECPoint[]
        NSMutableArray *imported = [[NSMutableArray alloc] initWithSize:count];
        imported[0] = p;
        for (int i = 1; i < count; ++i) {
            imported[i] = [ECAlgorithms importPoint:c withP:ps[i]];
        }
        
        GlvEndomorphism *glvEndomorphism = nil;
        ECEndomorphism *base = [c getEndomorphism];
        if (base != nil && [base isKindOfClass:[GlvEndomorphism class]]) {
            glvEndomorphism = (GlvEndomorphism*)base;
        }
        if (glvEndomorphism != nil) {
            retPoint = [ECAlgorithms validatePoint:[ECAlgorithms implSumOfMultipliesGlv:imported withKS:ks withGlvEndomorphism:glvEndomorphism]];
#if !__has_feature(objc_arc)
            if (imported != nil) [imported release]; imported = nil;
#endif
        } else {
            retPoint = [ECAlgorithms validatePoint:[ECAlgorithms implSumOfMultiplies:imported withKS:ks]];
#if !__has_feature(objc_arc)
            if (imported != nil) [imported release]; imported = nil;
#endif
        }
    jumpTo:;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

+ (ECPoint*)sumOfTwoMultiplies:(ECPoint*)P withA:(BigInteger*)a withQ:(ECPoint*)Q withB:(BigInteger*)b {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *cp = [P curve];
        Q = [ECAlgorithms importPoint:cp withP:Q];
        
        // Point multiplication for Koblitz curves (using WTNAF) beats Shamir's trick
        {
            AbstractF2mCurve *f2mCurve = nil;
            if (cp != nil && [cp isKindOfClass:[AbstractF2mCurve class]]) {
                f2mCurve = (AbstractF2mCurve*)cp;
            }
            if (f2mCurve != nil && [f2mCurve isKoblitz]) {
                retPoint = [ECAlgorithms validatePoint:[[P multiply:a] add:[Q multiply:b]]];
                goto jumpTo;
            }
        }
        
        GlvEndomorphism *glvEndomorphism = nil;
        ECEndomorphism *base = [cp getEndomorphism];
        if (base != nil && [base isKindOfClass:[GlvEndomorphism class]]) {
            glvEndomorphism = (GlvEndomorphism*)base;
        }
        if (glvEndomorphism != nil) {
            NSMutableArray *ps = [[NSMutableArray alloc] initWithObjects:P, Q, nil];
            NSMutableArray *ks = [[NSMutableArray alloc] initWithObjects:a, b, nil];
            retPoint = [ECAlgorithms validatePoint:[ECAlgorithms implSumOfMultipliesGlv:ps withKS:ks withGlvEndomorphism:glvEndomorphism]];
#if !__has_feature(objc_arc)
            if (ps != nil) [ps release]; ps = nil;
            if (ks != nil) [ks release]; ks = nil;
#endif
        } else {
            retPoint = [ECAlgorithms validatePoint:[ECAlgorithms implShamirsTrickWNaf:P withK:a withQ:Q withL:b]];
        }
    jumpTo:;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

/*
 * "Shamir's Trick", originally due to E. G. Straus
 * (Addition chains of vectors. American Mathematical Monthly,
 * 71(7):806-808, Aug./Sept. 1964)
 *
 * Input: The points P, Q, scalar k = (km?, ... , k1, k0)
 * and scalar l = (lm?, ... , l1, l0).
 * Output: R = k * P + l * Q.
 * 1: Z <- P + Q
 * 2: R <- O
 * 3: for i from m-1 down to 0 do
 * 4:        R <- R + R        {point doubling}
 * 5:        if (ki = 1) and (li = 0) then R <- R + P end if
 * 6:        if (ki = 0) and (li = 1) then R <- R + Q end if
 * 7:        if (ki = 1) and (li = 1) then R <- R + Z end if
 * 8: end for
 * 9: return R
 */
+ (ECPoint*)shamirsTrick:(ECPoint*)P withK:(BigInteger*)k withQ:(ECPoint*)Q withL:(BigInteger*)l {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *cp = [P curve];
        Q = [ECAlgorithms importPoint:cp withP:Q];
        
        retPoint = [ECAlgorithms validatePoint:[ECAlgorithms implShamirsTrickJsf:P withK:k withQ:Q withL:l]];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}


+ (ECPoint*)importPoint:(ECCurve*)c withP:(ECPoint*)p {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *cp = [p curve];
        if (![c equalsWithOther:cp]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Point must be on the same curve" userInfo:nil];
        }
        
        retPoint = [c importPoint:p];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

+ (void)montgomeryTrick:(NSMutableArray*)zs withOff:(int)off withLen:(int)len {
    [ECAlgorithms montgomeryTrick:zs withOff:off withLen:len withScale:nil];
}

+ (void)montgomeryTrick:(NSMutableArray*)zs withOff:(int)off withLen:(int)len withScale:(ECFieldElement*)scale {
    @autoreleasepool {
        /*
         * Uses the "Montgomery Trick" to invert many field elements, with only a single actual
         * field inversion. See e.g. the paper:
         * "Fast Multi-scalar Multiplication Methods on Elliptic Curves with Precomputation Strategy Using Montgomery Trick"
         * by Katsuyuki Okeya, Kouichi Sakurai.
         */
        // NSMutableArray == ECFieldElement[]
        NSMutableArray *c = [[NSMutableArray alloc] initWithSize:len];
        c[0] = zs[off];
        
        int i = 0;
        while (++i < len) {
            c[i] = [((ECFieldElement*)c[i - 1]) multiply:zs[off + i]];
        }
        
        --i;
        
        if (scale != nil) {
            c[i] = [c[i] multiply:scale];
        }
        
        ECFieldElement *u = [((ECFieldElement*)c[i]) invert];
        
        while (i > 0) {
            int j = off + i--;
            ECFieldElement *tmp = zs[j];
            zs[j] = [((ECFieldElement*)c[i]) multiply:u];
            u = [u multiply:tmp];
        }
#if !__has_feature(objc_arc)
        if (c != nil) [c release]; c = nil;
#endif
        zs[off] = u;
    }
}

/**
 * Simple shift-and-add multiplication. Serves as reference implementation
 * to verify (possibly faster) implementations, and for very small scalars.
 *
 * @param p
 *            The point to multiply.
 * @param k
 *            The multiplier.
 * @return The result of the point multiplication <code>kP</code>.
 */
+ (ECPoint*)referenceMultiply:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        BigInteger *x = [k abs];
        ECPoint *q = [[p curve] infinity];
        int t = [x bitLength];
        if (t > 0) {
            if ([x testBitWithN:0]) {
                q = p;
            }
            for (int i = 1; i < t; i++) {
                p = [p twice];
                if ([x testBitWithN:i]) {
                    q = [q add:p];
                }
            }
        }
        retPoint = ([k signValue] < 0 ? [q negate] : q);
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

+ (ECPoint*)validatePoint:(ECPoint*)p {
    if (![p isValid]) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"p invalid point" userInfo:nil];
    }
    return p;
}

+ (ECPoint*)implShamirsTrickJsf:(ECPoint*)P withK:(BigInteger*)k withQ:(ECPoint*)Q withL:(BigInteger*)l {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *curve = [P curve];
        ECPoint *infinity = [curve infinity];
        
        // TODO conjugate co-Z addition (ZADDC) can return both of these
        ECPoint *PaddQ = [P add:Q];
        ECPoint *PsubQ = [P subtract:Q];;
        
        // NSMutableArray == ECPoint[]
        NSMutableArray *points = [[NSMutableArray alloc] initWithObjects:Q, PsubQ, P, PaddQ, nil];
        [curve normalizeAll:points];
        NSMutableArray *table = [[NSMutableArray alloc] initWithObjects:[points[3] negate], [points[2] negate], [points[1] negate], [points[0] negate], infinity, points[0], points[1], points[2], points[3], nil];
        
        NSMutableData *jsf = [WNafUtilities generateJsf:k withH:l];
        ECPoint *R = infinity;
        
        int i = (int)(jsf.length);
        while (--i >= 0) {
            int jsfi = ((Byte*)(jsf.bytes))[i];
            
            // NOTE: The shifting ensures the sign is extended correctly
            int kDigit = ((jsfi << 24) >> 28), lDigit = ((jsfi << 28) >> 28);
            
            int index = 4 + (kDigit * 3) + lDigit;
            R = [R twicePlus:table[index]];
        }
#if !__has_feature(objc_arc)
        if (points != nil) [points release]; points = nil;
        if (table != nil) [table release]; table = nil;
#endif
        
        retPoint = R;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

+ (ECPoint*)implShamirsTrickWNaf:(ECPoint*)P withK:(BigInteger*)k withQ:(ECPoint*)Q withL:(BigInteger*)l {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        BOOL negK = [k signValue] < 0, negL = [l signValue] < 0;
        
        k = [k abs];
        l = [l abs];
        
        int widthP = MAX(2, MIN(16, [WNafUtilities getWindowSize:[k bitLength]]));
        int widthQ = MAX(2, MIN(16, [WNafUtilities getWindowSize:[l bitLength]]));
        
        WNafPreCompInfo *infoP = [WNafUtilities precompute:P withWidth:widthP withIncludeNegated:YES];
        WNafPreCompInfo *infoQ = [WNafUtilities precompute:Q withWidth:widthQ withIncludeNegated:YES];
        
        // NSMutableArray == ECPoint[]
        NSMutableArray *preCompP = negK ? [infoP preCompNeg] : [infoP preComp];
        NSMutableArray *preCompQ = negL ? [infoQ preCompNeg] : [infoQ preComp];
        NSMutableArray *preCompNegP = negK ? [infoP preComp] : [infoP preCompNeg];
        NSMutableArray *preCompNegQ = negL ? [infoQ preComp] : [infoQ preCompNeg];
        
        NSMutableData *wnafP = [WNafUtilities generateWindowNaf:widthP withK:k];
        NSMutableData *wnafQ = [WNafUtilities generateWindowNaf:widthQ withK:l];
        
        retPoint = [ECAlgorithms implShamirsTrickWNaf:preCompP withPreCompNegP:preCompNegP withWnafP:wnafP withPreCompQ:preCompQ withPreCompNegQ:preCompNegQ withWnafQ:wnafQ];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

+ (ECPoint*)implShamirsTrickWNaf:(ECPoint*)P withK:(BigInteger*)k withPointMapQ:(ECPointMap*)pointMapQ withL:(BigInteger*)l {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        BOOL negK = [k signValue] < 0, negL = [l signValue] < 0;
        
        k = [k abs];
        l = [l abs];
        
        int width = MAX(2, MIN(16, [WNafUtilities getWindowSize:MAX([k bitLength], [l bitLength])]));
        
        ECPoint *Q = [WNafUtilities mapPointWithPrecomp:P withWidth:width withIncludeNegated:YES withPointMap:pointMapQ];
        WNafPreCompInfo *infoP = [WNafUtilities getWNafPreCompInfoWithECPoint:P];
        WNafPreCompInfo *infoQ = [WNafUtilities getWNafPreCompInfoWithECPoint:Q];
        
        // NSMutableArray == ECPoint[]
        NSMutableArray *preCompP = negK ? [infoP preCompNeg] : [infoP preComp];
        NSMutableArray *preCompQ = negL ? [infoQ preCompNeg] : [infoQ preComp];
        NSMutableArray *preCompNegP = negK ? [infoP preComp] : [infoP preCompNeg];
        NSMutableArray *preCompNegQ = negL ? [infoQ preComp] : [infoQ preCompNeg];
        
        NSMutableData *wnafP = [WNafUtilities generateWindowNaf:width withK:k];
        NSMutableData *wnafQ = [WNafUtilities generateWindowNaf:width withK:l];
        
        retPoint = [ECAlgorithms implShamirsTrickWNaf:preCompP withPreCompNegP:preCompNegP withWnafP:wnafP withPreCompQ:preCompQ withPreCompNegQ:preCompNegQ withWnafQ:wnafQ];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

// preCompP == ECPoint[], preCompNegP == ECPoint[], preCompQ = ECPoint[], preCompNegQ = ECPoint[]
+ (ECPoint*)implShamirsTrickWNaf:(NSMutableArray*)preCompP withPreCompNegP:(NSMutableArray*)preCompNegP withWnafP:(NSMutableData*)wnafP withPreCompQ:(NSMutableArray*)preCompQ withPreCompNegQ:(NSMutableArray*)preCompNegQ withWnafQ:(NSMutableData*)wnafQ {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        int len = MAX((int)(wnafP.length), (int)(wnafQ.length));
        
        ECCurve *curve = [preCompP[0] curve];
        ECPoint *infinity = [curve infinity];
        
        ECPoint *R = infinity;
        int zeroes = 0;
        
        for (int i = len - 1; i >= 0; --i) {
            int wiP = i < wnafP.length ? (int)((int8_t)(((Byte*)(wnafP.bytes))[i])) : 0;
            int wiQ = i < wnafQ.length ? (int)((int8_t)(((Byte*)(wnafQ.bytes))[i])) : 0;
            
            if ((wiP | wiQ) == 0) {
                ++zeroes;
                continue;
            }
            
            ECPoint *r = infinity;
            if (wiP != 0) {
                int nP = abs(wiP);
                // NSMutableArray == ECPoint[]
                NSMutableArray *tableP = wiP < 0 ? preCompNegP : preCompP;
                r = [r add:tableP[nP >> 1]];
            }
            if (wiQ != 0) {
                int nQ = abs(wiQ);
                // NSMutableArray == ECPoint[]
                NSMutableArray *tableQ = wiQ < 0 ? preCompNegQ : preCompQ;
                r = [r add:tableQ[nQ >> 1]];
            }
            
            if (zeroes > 0) {
                R = [R timesPow2:zeroes];
                zeroes = 0;
            }
            
            R = [R twicePlus:r];
        }
        
        if (zeroes > 0) {
            R = [R timesPow2:zeroes];
        }
        
        retPoint = R;
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

// ps == ECPoint[], ks == BigInteger[]
+ (ECPoint*)implSumOfMultiplies:(NSMutableArray*)ps withKS:(NSMutableArray*)ks {
    ECPoint *retVal = nil;
    @autoreleasepool {
        int count = (int)(ps.count);
        // NSMutableArray == BOOL[]
        NSMutableArray *negs = [[NSMutableArray alloc] initWithSize:count];
        // NSMutableArray == WNafPreCompInfo[]
        NSMutableArray *infos = [[NSMutableArray alloc] initWithSize:count];
        // NSMutableArray == Byte[][]
        NSMutableArray *wnafs = [[NSMutableArray alloc] initWithSize:count];
        
        for (int i = 0; i < count; ++i) {
            BigInteger *ki = ks[i]; negs[i] = @([ki signValue] < 0); ki = [ki abs];
            
            int width = MAX(2, MIN(16, [WNafUtilities getWindowSize:[ki bitLength]]));
            infos[i] = [WNafUtilities precompute:ps[i] withWidth:width withIncludeNegated:YES];
            wnafs[i] = [WNafUtilities generateWindowNaf:width withK:ki];
        }
        retVal = [ECAlgorithms implSumOfMultiplies:negs withInfos:infos withWnafs:wnafs];
#if !__has_feature(objc_arc)
        if (negs != nil) [negs release]; negs = nil;
        if (infos != nil) [infos release]; infos = nil;
        if (wnafs != nil) [wnafs release]; wnafs = nil;
#endif
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

// ps == ECPoint[], ks == BigInteger[]
+ (ECPoint*)implSumOfMultipliesGlv:(NSMutableArray*)ps withKS:(NSMutableArray*)ks withGlvEndomorphism:(GlvEndomorphism*)glvEndomorphism {
    ECPoint *retVal = nil;
    @autoreleasepool {
        BigInteger *n = [[ps[0] curve] order];
        
        int len = (int)(ps.count);
        
        // NSMutableArray == BigInteger[]
        NSMutableArray *abs = [[NSMutableArray alloc] initWithSize:(len << 1)];
        for (int i = 0, j = 0; i < len; ++i) {
            // NSMutableArray == BigInteger[]
            NSMutableArray *ab = [glvEndomorphism decomposeScalar:[ks[i] modWithM:n]];
            abs[j++] = ab[0];
            abs[j++] = ab[1];
        }
        
        ECPointMap *pointMap = [glvEndomorphism pointMap];
        if ([glvEndomorphism hasEfficientPointMap]) {
            retVal = [ECAlgorithms implSumOfMultiplies:ps withPointMap:pointMap withKS:abs];
#if !__has_feature(objc_arc)
            if (abs != nil) [abs release]; abs = nil;
#endif
        } else {
            // NSMutableArray == ECPoint[]
            NSMutableArray *pqs = [[NSMutableArray alloc] initWithSize:(len << 1)];
            for (int i = 0, j = 0; i < len; ++i) {
                ECPoint *p = ps[i], *q = [pointMap map:p];
                pqs[j++] = p;
                pqs[j++] = q;
            }
            retVal = [ECAlgorithms implSumOfMultiplies:pqs withKS:abs];
#if !__has_feature(objc_arc)
            if (abs != nil) [abs release]; abs = nil;
            if (pqs != nil) [pqs release]; pqs = nil;
#endif
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

// ps == ECPoint[], ks = BigInteger[]
+ (ECPoint*)implSumOfMultiplies:(NSMutableArray*)ps withPointMap:(ECPointMap*)pointMap withKS:(NSMutableArray*)ks {
    ECPoint *retVal = nil;
    @autoreleasepool {
        int halfCount = (int)(ps.count), fullCount = halfCount << 1;
        
        // NSMutableArray == BOOL[]
        NSMutableArray *negs = [[NSMutableArray alloc] initWithSize:fullCount];
        // NSMutableArray == WNafPreCompInfo[]
        NSMutableArray *infos = [[NSMutableArray alloc] initWithSize:fullCount];
        // NSMutableArray == Byte[][]
        NSMutableArray *wnafs = [[NSMutableArray alloc] initWithSize:fullCount];
        
        for (int i = 0; i < halfCount; ++i) {
            int j0 = i << 1, j1 = j0 + 1;
            
            BigInteger *kj0 = ks[j0]; negs[j0] = @([kj0 signValue] < 0); kj0 = [kj0 abs];
            BigInteger *kj1 = ks[j1]; negs[j1] = @([kj1 signValue] < 0); kj1 = [kj1 abs];
            
            int width = MAX(2, MIN(16, [WNafUtilities getWindowSize:MAX([kj0 bitLength], [kj1 bitLength])]));
            
            ECPoint *P = ps[i], *Q = [WNafUtilities mapPointWithPrecomp:P withWidth:width withIncludeNegated:YES withPointMap:pointMap];
            infos[j0] = [WNafUtilities getWNafPreCompInfoWithECPoint:P];
            infos[j1] = [WNafUtilities getWNafPreCompInfoWithECPoint:Q];
            wnafs[j0] = [WNafUtilities generateWindowNaf:width withK:kj0];
            wnafs[j1] = [WNafUtilities generateWindowNaf:width withK:kj1];
        }
        
        retVal = [ECAlgorithms implSumOfMultiplies:negs withInfos:infos withWnafs:wnafs];
#if !__has_feature(objc_arc)
        if (negs != nil) [negs release]; negs = nil;
        if (infos != nil) [infos release]; infos = nil;
        if (wnafs != nil) [wnafs release]; wnafs = nil;
#endif
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

// negs == bool[], infos == WNafPreCompInfo[], wnafs == byte[][]
+ (ECPoint*)implSumOfMultiplies:(NSMutableArray*)negs withInfos:(NSMutableArray*)infos withWnafs:(NSMutableArray*)wnafs {
    ECPoint *retVal = nil;
    @autoreleasepool {
        int len = 0, count = (int)(wnafs.count);
        for (int i = 0; i < count; ++i) {
            len = MAX(len, (int)(((NSMutableData*)(wnafs[i])).length));
        }
        
        ECCurve *curve = [[infos[0] preComp][0] curve];
        ECPoint *infinity = [curve infinity];
        
        ECPoint *R = infinity;
        int zeroes = 0;
        
        for (int i = len - 1; i >= 0; --i) {
            ECPoint *r = infinity;
            
            for (int j = 0; j < count; ++j) {
                NSMutableData *wnaf = wnafs[j];
                int wi = i < wnaf.length ? (int)((int8_t)(((Byte*)(wnaf.bytes))[i])) : 0;
                if (wi != 0) {
                    int n = abs(wi);
                    WNafPreCompInfo *info = infos[j];
                    // NSMutableArray == ECPoint[]
                    NSMutableArray *table = (wi < 0 == [negs[j] boolValue]) ? [info preComp] : [info preCompNeg];
                    r = [r add:table[(n >> 1)]];
                }
            }
            
            if (r == infinity) {
                ++zeroes;
                continue;
            }
            
            if (zeroes > 0) {
                R = [R timesPow2:zeroes];
                zeroes = 0;
            }
            
            R = [R twicePlus:r];
        }
        
        if (zeroes > 0) {
            R = [R timesPow2:zeroes];
        }
        
        retVal = R;
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end
