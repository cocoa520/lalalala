//
//  Tnaf.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "Tnaf.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "ZTauElement.h"
#import "SimpleBigDecimal.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "ECFieldElement.h"

@implementation Tnaf

/**
 * The window width of WTNAF. The standard value of 4 is slightly less
 * than optimal for running time, but keeps space requirements for
 * precomputation low. For typical curves, a value of 5 or 6 results in
 * a better running time. When changing this value, the
 * <code>&#945;<sub>u</sub></code>'s must be computed differently, see
 * e.g. "Guide to Elliptic Curve Cryptography", Darrel Hankerson,
 * Alfred Menezes, Scott Vanstone, Springer-Verlag New York Inc., 2004,
 * p. 121-122
 */
+ (int8_t)Width {
    return 4;
}

/**
 * 2<sup>4</sup>
 */
+ (int8_t)Pow2Width {
    return 16;
}

+ (BigInteger*)MinusOne {
    static BigInteger *_minusOne = nil;
    @synchronized(self) {
        if (_minusOne == nil) {
            @autoreleasepool {
                _minusOne = [[BigInteger One] negate];
                [_minusOne retain];
            }
        }
    }
    return _minusOne;
}

+ (BigInteger*)MinusTwo {
    static BigInteger *_minusTwo = nil;
    @synchronized(self) {
        if (_minusTwo == nil) {
            @autoreleasepool {
                _minusTwo = [[BigInteger Two] negate];
                [_minusTwo retain];
            }
        }
    }
    return _minusTwo;
}

+ (BigInteger*)MinusThree {
    static BigInteger *_minusThree = nil;
    @synchronized(self) {
        if (_minusThree == nil) {
            @autoreleasepool {
                _minusThree = [[BigInteger Three] negate];
                [_minusThree retain];
            }
        }
    }
    return _minusThree;
}

+ (BigInteger*)Four {
    static BigInteger *_four = nil;
    @synchronized(self) {
        if (_four == nil) {
            _four = [BigInteger Four];
        }
    }
    return _four;
}

/**
 * The <code>&#945;<sub>u</sub></code>'s for <code>a=0</code> as an array
 * of <code>ZTauElement</code>s.
 */
// NSArray =ZTauElement[] contain [NSNull null]
+ (NSArray*)Alpha0 {
    static NSArray *_alpha0 = nil;
    @synchronized(self) {
        if (_alpha0 == nil) {
            @autoreleasepool {
                _alpha0 = [@[[NSNull null], [[[ZTauElement alloc] initWithU:[BigInteger One] withV:[BigInteger Zero]] autorelease], [NSNull null], [[[ZTauElement alloc] initWithU:[Tnaf MinusThree] withV:[Tnaf MinusOne]] autorelease], [NSNull null], [[[ZTauElement alloc] initWithU:[Tnaf MinusOne] withV:[Tnaf MinusOne]] autorelease], [NSNull null], [[[ZTauElement alloc] initWithU:[BigInteger One] withV:[Tnaf MinusOne]] autorelease], [NSNull null]] retain];
            }
        }
    }
    return _alpha0;
}

/**
 * The <code>&#945;<sub>u</sub></code>'s for <code>a=0</code> as an array
 * of TNAFs.
 */
// NSArray = int8_t[][] contain [NSNull null]
+ (NSArray*)Alpha0Tnaf {
    static NSArray *_alpha0Tnaf = nil;
    @synchronized(self) {
        if (_alpha0Tnaf == nil) {
            @autoreleasepool {
                _alpha0Tnaf = [@[[NSNull null], @[@((int8_t)1)], [NSNull null], @[@((int8_t)-1), @((int8_t)0), @((int8_t)1)], [NSNull null], @[@((int8_t)1), @((int8_t)0), @((int8_t)1)], [NSNull null], @[@((int8_t)-1), @((int8_t)0), @((int8_t)0), @((int8_t)1)]] retain];
            }
        }
    }
    return _alpha0Tnaf;
}

/**
 * The <code>&#945;<sub>u</sub></code>'s for <code>a=1</code> as an array
 * of <code>ZTauElement</code>s.
 */
// NSArray == ZTauElement[] contain [NSNull null]
+ (NSArray*)Alpha1 {
    static NSArray *_alpha1 = nil;
    @synchronized(self) {
        if (_alpha1 == nil) {
            @autoreleasepool {
                _alpha1 = [@[[NSNull null], [[[ZTauElement alloc] initWithU:[BigInteger One] withV:[BigInteger Zero]] autorelease], [NSNull null], [[[ZTauElement alloc] initWithU:[Tnaf MinusThree] withV:[BigInteger One]] autorelease], [NSNull null], [[[ZTauElement alloc] initWithU:[Tnaf MinusOne] withV:[BigInteger One]] autorelease], [NSNull null], [[[ZTauElement alloc] initWithU:[BigInteger One] withV:[BigInteger One]] autorelease], [NSNull null]] retain];
            }
        }
    }
    return _alpha1;
}


/**
 * The <code>&#945;<sub>u</sub></code>'s for <code>a=1</code> as an array
 * of TNAFs.
 */
// NSArray = int8_t[][] contain [NSNull null]
+ (NSArray*)Alpha1Tnaf {
    static NSArray *_alpha1Tnaf = nil;
    @synchronized(self) {
        if (_alpha1Tnaf == nil) {
            @autoreleasepool {
                _alpha1Tnaf = [@[[NSNull null], @[@((int8_t)1)], [NSNull null], @[@((int8_t)-1), @((int8_t)0), @((int8_t)1)], [NSNull null], @[@((int8_t)1), @((int8_t)0), @((int8_t)1)], [NSNull null], @[@((int8_t)-1), @((int8_t)0), @((int8_t)0), @((int8_t)-1)]] retain];
            }
        }
    }
    return _alpha1Tnaf;
}

/**
 * Computes the norm of an element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @return The norm of <code>&#955;</code>.
 */
+ (BigInteger*)norm:(int8_t)mu withLambda:(ZTauElement*)lambda {
    BigInteger *norm = nil;
    
    @autoreleasepool {
        // s1 = u^2
        BigInteger *s1 = [[lambda u] multiplyWithVal:[lambda u]];
        
        // s2 = u * v
        BigInteger *s2 = [[lambda u] multiplyWithVal:[lambda v]];
        
        // s3 = 2 * v^2
        BigInteger *s3 = [[[lambda v] multiplyWithVal:[lambda v]] shiftLeftWithN:1];
        
        if (mu == 1) {
            norm = [[s1 addWithValue:s2] addWithValue:s3];
        } else if (mu == -1) {
            norm = [[s1 subtractWithN:s2] addWithValue:s3];
        } else {
            @throw [NSException exceptionWithName:@"Argument" reason:@"mu must be 1 or -1" userInfo:nil];
        }
        
        [norm retain];
    }
    
    return (norm ? [norm autorelease] : nil);
}


/**
 * Computes the norm of an element <code>&#955;</code> of
 * <code><b>R</b>[&#964;]</code>, where <code>&#955; = u + v&#964;</code>
 * and <code>u</code> and <code>u</code> are real numbers (elements of
 * <code><b>R</b></code>).
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param u The real part of the element <code>&#955;</code> of
 * <code><b>R</b>[&#964;]</code>.
 * @param v The <code>&#964;</code>-adic part of the element
 * <code>&#955;</code> of <code><b>R</b>[&#964;]</code>.
 * @return The norm of <code>&#955;</code>.
 */
+ (SimpleBigDecimal*)norm:(int8_t)mu withU:(SimpleBigDecimal*)u withV:(SimpleBigDecimal*)v {
    SimpleBigDecimal *norm = nil;
    
    @autoreleasepool {
        // s1 = u^2
        SimpleBigDecimal *s1 = [u multiplyWithSimpleBigDecimal:u];
        
        // s2 = u * v
        SimpleBigDecimal *s2 = [u multiplyWithSimpleBigDecimal:v];
        
        // s3 = 2 * v^2
        SimpleBigDecimal *s3 = [[v multiplyWithSimpleBigDecimal:v] shiftLeft:1];
        
        if (mu == 1) {
            norm = [[s1 addWithSimpleBigDecimal:s2] addWithSimpleBigDecimal:s3];
        } else if (mu == -1) {
            norm = [[s1 subtractWithSimpleBigDecimal:s2] addWithSimpleBigDecimal:s3];
        } else {
            @throw [NSException exceptionWithName:@"Argument" reason:@"mu must be 1 or -1" userInfo:nil];
        }
        
        [norm retain];
    }
    
    return (norm ? [norm autorelease] : nil);
}

/**
 * Rounds an element <code>&#955;</code> of <code><b>R</b>[&#964;]</code>
 * to an element of <code><b>Z</b>[&#964;]</code>, such that their difference
 * has minimal norm. <code>&#955;</code> is given as
 * <code>&#955; = &#955;<sub>0</sub> + &#955;<sub>1</sub>&#964;</code>.
 * @param lambda0 The component <code>&#955;<sub>0</sub></code>.
 * @param lambda1 The component <code>&#955;<sub>1</sub></code>.
 * @param mu The parameter <code>&#956;</code> of the elliptic curve. Must
 * equal 1 or -1.
 * @return The rounded element of <code><b>Z</b>[&#964;]</code>.
 * @throws ArgumentException if <code>lambda0</code> and
 * <code>lambda1</code> do not have same scale.
 */
+ (ZTauElement*)round:(SimpleBigDecimal*)lambda0 withLambda1:(SimpleBigDecimal*)lambda1 withMu:(int8_t)mu {
    ZTauElement *retVal = nil;
    @autoreleasepool {
        int scale = [lambda0 scale];
        if ([lambda1 scale] != scale) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"lambda0 and lambda1 do not have same scale" userInfo:nil];
        }
        
        if (!((mu == 1) || (mu == -1))) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"mu must be 1 or -1" userInfo:nil];
        }
        
        BigInteger *f0 = [lambda0 round];
        BigInteger *f1 = [lambda1 round];
        
        SimpleBigDecimal *eta0 = [lambda0 subtractWithBigInteger:f0];
        SimpleBigDecimal *eta1 = [lambda1 subtractWithBigInteger:f1];
        
        // eta = 2*eta0 + mu*eta1
        SimpleBigDecimal *eta = [eta0 addWithSimpleBigDecimal:eta0];
        if (mu == 1) {
            eta = [eta addWithSimpleBigDecimal:eta1];
        } else {
            // mu == -1
            eta = [eta subtractWithSimpleBigDecimal:eta1];
        }
        
        // check1 = eta0 - 3*mu*eta1
        // check2 = eta0 + 4*mu*eta1
        SimpleBigDecimal *threeEta1 = [[eta1 addWithSimpleBigDecimal:eta1] addWithSimpleBigDecimal:eta1];
        SimpleBigDecimal *fourEta1 = [threeEta1 addWithSimpleBigDecimal:eta1];
        SimpleBigDecimal *check1;
        SimpleBigDecimal *check2;
        if (mu == 1) {
            check1 = [eta0 subtractWithSimpleBigDecimal:threeEta1];
            check2 = [eta0 addWithSimpleBigDecimal:fourEta1];
        } else {
            // mu == -1
            check1 = [eta0 addWithSimpleBigDecimal:threeEta1];
            check2 = [eta0 subtractWithSimpleBigDecimal:fourEta1];
        }
        
        int8_t h0 = 0;
        int8_t h1 = 0;
        
        // if eta >= 1
        if ([eta compareToWithBigInteger:[BigInteger One]] >= 0) {
            if ([check1 compareToWithBigInteger:[Tnaf MinusOne]] < 0) {
                h1 = mu;
            } else {
                h0 = 1;
            }
        } else {
            // eta < 1
            if ([check2 compareToWithBigInteger:[BigInteger Two]] >= 0) {
                h1 = mu;
            }
        }
        
        // if eta < -1
        if ([eta compareToWithBigInteger:[Tnaf MinusOne]] < 0) {
            if ([check1 compareToWithBigInteger:[BigInteger One]] >= 0) {
                h1 = (int8_t)-mu;
            } else {
                h0 = -1;
            }
        } else {
            // eta >= -1
            if ([check2 compareToWithBigInteger:[Tnaf MinusTwo]] < 0) {
                h1 = (int8_t)-mu;
            }
        }
        
        BigInteger *q0 = [f0 addWithValue:[BigInteger valueOf:h0]];
        BigInteger *q1 = [f1 addWithValue:[BigInteger valueOf:h1]];
        retVal = [[ZTauElement alloc] initWithU:q0 withV:q1];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Approximate division by <code>n</code>. For an integer
 * <code>k</code>, the value <code>&#955; = s k / n</code> is
 * computed to <code>c</code> bits of accuracy.
 * @param k The parameter <code>k</code>.
 * @param s The curve parameter <code>s<sub>0</sub></code> or
 * <code>s<sub>1</sub></code>.
 * @param vm The Lucas Sequence element <code>V<sub>m</sub></code>.
 * @param a The parameter <code>a</code> of the elliptic curve.
 * @param m The bit length of the finite field
 * <code><b>F</b><sub>m</sub></code>.
 * @param c The number of bits of accuracy, i.e. the scale of the returned
 * <code>SimpleBigDecimal</code>.
 * @return The value <code>&#955; = s k / n</code> computed to
 * <code>c</code> bits of accuracy.
 */
+ (SimpleBigDecimal*)approximateDivisionByN:(BigInteger*)k withS:(BigInteger*)s withVm:(BigInteger*)vm withA:(int8_t)a withM:(int)m withC:(int)c {
    SimpleBigDecimal *retVal = nil;
    @autoreleasepool {
        int _k = (m + 5)/2 + c;
        BigInteger *ns = [k shiftRightWithN:(m - _k - 2 + a)];
        
        BigInteger *gs = [s multiplyWithVal:ns];
        
        BigInteger *hs = [gs shiftRightWithN:m];
        
        BigInteger *js = [vm multiplyWithVal:hs];
        
        BigInteger *gsPlusJs = [gs addWithValue:js];
        BigInteger *ls = [gsPlusJs shiftRightWithN:(_k - c)];
        if ([gsPlusJs testBitWithN:(_k - c - 1)]) {
            // round up
            ls = [ls addWithValue:[BigInteger One]];
        }
        retVal = [[SimpleBigDecimal alloc] initWithBigInt:ls withScale:c];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Computes the <code>&#964;</code>-adic NAF (non-adjacent form) of an
 * element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>.
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @return The <code>&#964;</code>-adic NAF of <code>&#955;</code>.
 */
// NSMutableArray == int8_t[]
+ (NSMutableArray*)tauAdicNaf:(int8_t)mu withLambda:(ZTauElement*)lambda {
    NSMutableArray *tnaf = nil;
    @autoreleasepool {
        if (!((mu == 1) || (mu == -1))) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"mu must be 1 or -1" userInfo:nil];
        }
        
        BigInteger *norm = [self norm:mu withLambda:lambda];
        
        // Ceiling of log2 of the norm
        int log2Norm = [norm bitLength];
        
        // If length(TNAF) > 30, then length(TNAF) < log2Norm + 3.52
        int maxLength = log2Norm > 30 ? log2Norm + 4 : 34;
        
        // The array holding the TNAF
        // NSMutableArray == int8_t[]
        NSMutableArray *u = [[NSMutableArray alloc] initWithSize:maxLength];
        int i = 0;
        
        // The actual length of the TNAF
        int length = 0;
        
        BigInteger *r0 = [lambda u];
        BigInteger *r1 = [lambda v];
        
        while(!([r0 isEqual:[BigInteger Zero]] && [r1 isEqual:[BigInteger Zero]])) {
            // If r0 is odd
            if ([r0 testBitWithN:0]) {
                u[i] = @((int8_t)[[[BigInteger Two] subtractWithN:[[r0 subtractWithN:[r1 shiftLeftWithN:1]] modWithM:[Tnaf Four]]] intValue]);
                
                // r0 = r0 - u[i]
                if ([u[i] charValue] == 1) {
                    r0 = [r0 clearBitWithN:0];
                } else {
                    // u[i] == -1
                    r0 = [r0 addWithValue:[BigInteger One]];
                }
                length = i;
            } else {
                u[i] = @((int8_t)0);
            }
            
            BigInteger *t = r0;
            BigInteger *s = [r0 shiftRightWithN:1];
            if (mu == 1) {
                r0 = [r1 addWithValue:s];
            } else {
                // mu == -1
                r0 = [r1 subtractWithN:s];
            }
            
            r1 = [[t shiftRightWithN:1] negate];
            i++;
        }
        
        length++;
        
        // Reduce the TNAF array to its actual length
        tnaf = [[NSMutableArray alloc] initWithSize:length];
        [tnaf copyFromIndex:0 withSource:u withSourceIndex:0 withLength:length];
#if !__has_feature(objc_arc)
        if (u != nil) [u release]; u = nil;
#endif
    }
    return (tnaf ? [tnaf autorelease] : nil);
}

/**
 * Applies the operation <code>&#964;()</code> to an
 * <code>AbstractF2mPoint</code>.
 * @param p The AbstractF2mPoint to which <code>&#964;()</code> is applied.
 * @return <code>&#964;(p)</code>
 */
+ (AbstractF2mPoint*)tau:(AbstractF2mPoint*)p {
    AbstractF2mPoint *retVal = nil;
    @autoreleasepool {
        retVal = [p tau];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Returns the parameter <code>&#956;</code> of the elliptic curve.
 * @param curve The elliptic curve from which to obtain <code>&#956;</code>.
 * The curve must be a Koblitz curve, i.e. <code>a</code> Equals
 * <code>0</code> or <code>1</code> and <code>b</code> Equals
 * <code>1</code>.
 * @return <code>&#956;</code> of the elliptic curve.
 * @throws ArgumentException if the given ECCurve is not a Koblitz
 * curve.
 */
+ (int8_t)getMuWithCurve:(AbstractF2mCurve*)curve {
    int8_t mu = 0;
    @autoreleasepool {
        BigInteger *a = [[curve a] toBigInteger];
        
        if ([a signValue] == 0) {
            mu = -1;
        } else if ([a isEqual:[BigInteger One]]) {
            mu = 1;
        } else {
            @throw [NSException exceptionWithName:@"Argument" reason:@"No Koblitz curve (ABC), TNAF multiplication not possible" userInfo:nil];
        }
    }
    return mu;
}

+ (int8_t)getMuWithField:(ECFieldElement*)curveA {
    return (int8_t)([curveA isZero] ? -1 : 1);
}

+ (int8_t)getMuWithInt:(int)curveA {
    return (int8_t)(curveA == 0 ? -1 : 1);
}

/**
 * Calculates the Lucas Sequence elements <code>U<sub>k-1</sub></code> and
 * <code>U<sub>k</sub></code> or <code>V<sub>k-1</sub></code> and
 * <code>V<sub>k</sub></code>.
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param k The index of the second element of the Lucas Sequence to be
 * returned.
 * @param doV If set to true, computes <code>V<sub>k-1</sub></code> and
 * <code>V<sub>k</sub></code>, otherwise <code>U<sub>k-1</sub></code> and
 * <code>U<sub>k</sub></code>.
 * @return An array with 2 elements, containing <code>U<sub>k-1</sub></code>
 * and <code>U<sub>k</sub></code> or <code>V<sub>k-1</sub></code>
 * and <code>V<sub>k</sub></code>.
 */
// NSMutableArray == BigInteger[]
+ (NSMutableArray*)getLucas:(int8_t)mu withK:(int)k withDoV:(BOOL)doV {
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        if (!(mu == 1 || mu == -1)) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"mu must be 1 or -1" userInfo:nil];
        }
        
        BigInteger *u0;
        BigInteger *u1;
        BigInteger *u2;
        
        if (doV) {
            u0 = [BigInteger Two];
            u1 = [BigInteger valueOf:mu];
        } else {
            u0 = [BigInteger Zero];
            u1 = [BigInteger One];
        }
        
        for (int i = 1; i < k; i++) {
            // u2 = mu*u1 - 2*u0;
            BigInteger *s = nil;
            if (mu == 1) {
                s = u1;
            } else {
                // mu == -1
                s = [u1 negate];
            }
            
            u2 = [s subtractWithN:[u0 shiftLeftWithN:1]];
            u0 = u1;
            u1 = u2;
        }
        
        retVal = [[NSMutableArray alloc] initWithObjects:u0, u1, nil];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Computes the auxiliary value <code>t<sub>w</sub></code>. If the width is
 * 4, then for <code>mu = 1</code>, <code>t<sub>w</sub> = 6</code> and for
 * <code>mu = -1</code>, <code>t<sub>w</sub> = 10</code>
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param w The window width of the WTNAF.
 * @return the auxiliary value <code>t<sub>w</sub></code>
 */
+ (BigInteger*)getTw:(int8_t)mu withW:(int)w {
    if (w == 4) {
        if (mu == 1) {
            return [BigInteger Six];
        } else {
            // mu == -1
            return [BigInteger Ten];
        }
    } else {
        BigInteger *tw = nil;
        @autoreleasepool {
            // For w <> 4, the values must be computed
            // NSMutableArray == BigInteger[]
            NSMutableArray *us = [Tnaf getLucas:mu withK:w withDoV:NO];
            BigInteger *twoToW = [[BigInteger Zero] setBitWithN:w];
            BigInteger *u1invert = [(BigInteger*)us[1] modInverseWithM:twoToW];
            tw = [[[[BigInteger Two] multiplyWithVal:(BigInteger*)us[0]] multiplyWithVal:u1invert] modWithM:twoToW];
            [tw retain];
        }
        return (tw ? [tw autorelease] : nil);
    }
}

/**
 * Computes the auxiliary values <code>s<sub>0</sub></code> and
 * <code>s<sub>1</sub></code> used for partial modular reduction.
 * @param curve The elliptic curve for which to compute
 * <code>s<sub>0</sub></code> and <code>s<sub>1</sub></code>.
 * @throws ArgumentException if <code>curve</code> is not a
 * Koblitz curve (Anomalous Binary Curve, ABC).
 */
// NSMutableArray == BigInteger[]
+ (NSMutableArray*)getSi:(AbstractF2mCurve*)curve {
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        if (![curve isKoblitz]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"si is defined for Koblitz curves only" userInfo:nil];
        }
        
        int m = [curve fieldSize];
        int a = [[[curve a] toBigInteger] intValue];
        int8_t mu = [Tnaf getMuWithInt:a];
        int shifts = [Tnaf getShiftsForCofactor:[curve cofactor]];
        int index = m + 3 - a;
        //NSMutableArray == BigInteger[]
        NSMutableArray *ui = [Tnaf getLucas:mu withK:index withDoV:NO];
        
        if (mu == 1) {
            ui[0] = [ui[0] negate];
            ui[1] = [ui[1] negate];
        }
        
        BigInteger *dividend0 = [[[BigInteger One] addWithValue:ui[1]] shiftRightWithN:shifts];
        BigInteger *dividend1 = [[[[BigInteger One] addWithValue:ui[0]] shiftRightWithN:shifts] negate];
        
        retVal = [[NSMutableArray alloc] initWithObjects:dividend0, dividend1, nil];
    }
    return (retVal ? [retVal autorelease] : nil);
}

// NSMutableArray == BigInteger[]
+ (NSMutableArray*)getSi:(int)fieldSize withCurveA:(int)curveA withCofactor:(BigInteger*)cofactor {
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        int8_t mu = [Tnaf getMuWithInt:curveA];
        int shifts = [Tnaf getShiftsForCofactor:cofactor];
        int index = fieldSize + 3 - curveA;
        // NSMutableArray == BigInteger[]
        NSMutableArray *ui = [Tnaf getLucas:mu withK:index withDoV:NO];
        if (mu == 1) {
            ui[0] = [ui[0] negate];
            ui[1] = [ui[1] negate];
        }
        
        BigInteger *dividend0 = [[[BigInteger One] addWithValue:ui[1]] shiftRightWithN:shifts];
        BigInteger *dividend1 = [[[[BigInteger One] addWithValue:ui[0]] shiftRightWithN:shifts] negate];
        retVal = [[NSMutableArray alloc] initWithObjects:dividend0, dividend1, nil];
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (int)getShiftsForCofactor:(BigInteger*)h {
    if (h != nil && [h bitLength] < 4) {
        int hi = [h intValue];
        if (hi == 2) {
            return 1;
        }
        if (hi == 4) {
            return 2;
        }
    }
    
    @throw [NSException exceptionWithName:@"Argument" reason:@"h (Cofactor) must be 2 or 4" userInfo:nil];
}

/**
 * Partial modular reduction modulo
 * <code>(&#964;<sup>m</sup> - 1)/(&#964; - 1)</code>.
 * @param k The integer to be reduced.
 * @param m The bitlength of the underlying finite field.
 * @param a The parameter <code>a</code> of the elliptic curve.
 * @param s The auxiliary values <code>s<sub>0</sub></code> and
 * <code>s<sub>1</sub></code>.
 * @param mu The parameter &#956; of the elliptic curve.
 * @param c The precision (number of bits of accuracy) of the partial
 * modular reduction.
 * @return <code>&#961; := k partmod (&#964;<sup>m</sup> - 1)/(&#964; - 1)</code>
 */
// NSMutableArray == BigInteger[]
+ (ZTauElement*)partModReduction:(BigInteger*)k withM:(int)m withA:(int8_t)a withS:(NSMutableArray*)s withMu:(int8_t)mu withC:(int8_t)c {
    ZTauElement *rerVal = nil;
    @autoreleasepool {
        // d0 = s[0] + mu*s[1]; mu is either 1 or -1
        BigInteger *d0;
        if (mu == 1) {
            d0 = [s[0] addWithValue:s[1]];
        } else {
            d0 = [s[0] subtractWithN:s[1]];
        }
        
        // NSMutableArray == BigInteger[]
        NSMutableArray *v = [Tnaf getLucas:mu withK:m withDoV:YES];
        
        BigInteger *vm = v[1];
        
        SimpleBigDecimal *lambda0 = [Tnaf approximateDivisionByN:k withS:s[0] withVm:vm withA:a withM:m withC:c];
        
        SimpleBigDecimal *lambda1 = [Tnaf approximateDivisionByN:k withS:s[1] withVm:vm withA:a withM:m withC:c];
        
        ZTauElement *q = [Tnaf round:lambda0 withLambda1:lambda1 withMu:mu];
        
        // r0 = n - d0*q0 - 2*s1*q1
        BigInteger *r0 = [[k subtractWithN:[d0 multiplyWithVal:[q u]]] subtractWithN:[[[BigInteger Two] multiplyWithVal:s[1]] multiplyWithVal:[q v]]];
        
        // r1 = s1*q0 - s0*q1
        BigInteger *r1 = [[s[1] multiplyWithVal:[q u]] subtractWithN:[s[0] multiplyWithVal:[q v]]];
        
        rerVal = [[ZTauElement alloc] initWithU:r0 withV:r1];
    }
    return (rerVal ? [rerVal autorelease] : nil);
}

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by a <code>BigInteger</code> using the reduced <code>&#964;</code>-adic
 * NAF (RTNAF) method.
 * @param p The AbstractF2mPoint to Multiply.
 * @param k The <code>BigInteger</code> by which to Multiply <code>p</code>.
 * @return <code>k * p</code>
 */
+ (AbstractF2mPoint*)multiplyRTnaf:(AbstractF2mPoint*)p withK:(BigInteger*)k {
    AbstractF2mPoint *retVal = nil;
    @autoreleasepool {
        AbstractF2mCurve *curve = (AbstractF2mCurve*)[p curve];
        int m = [curve fieldSize];
        int a = [[[curve a] toBigInteger] intValue];
        int8_t mu = [Tnaf getMuWithInt:a];
        // NSMutableArray == BigInteger[]
        NSMutableArray *s = [curve getSi];
        ZTauElement *rho = [Tnaf partModReduction:k withM:m withA:(int8_t)a withS:s withMu:mu withC:(int8_t)10];
        retVal = [Tnaf multiplyTnaf:p withLambda:rho];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by an element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>
 * using the <code>&#964;</code>-adic NAF (TNAF) method.
 * @param p The AbstractF2mPoint to Multiply.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @return <code>&#955; * p</code>
 */
+ (AbstractF2mPoint*)multiplyTnaf:(AbstractF2mPoint*)p withLambda:(ZTauElement*)lambda {
    AbstractF2mPoint *q = nil;
    @autoreleasepool {
        AbstractF2mCurve *curve = (AbstractF2mCurve*)[p curve];
        int8_t mu = [Tnaf getMuWithField:[curve a]];
        // NSMutableArray == int8_t[]
        NSMutableArray *u = [Tnaf tauAdicNaf:mu withLambda:lambda];
        
        q = [Tnaf multiplyFromTnaf:p withU:u];
        [q retain];
    }
    return (q ? [q autorelease] : nil);
}

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by an element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>
 * using the <code>&#964;</code>-adic NAF (TNAF) method, given the TNAF
 * of <code>&#955;</code>.
 * @param p The AbstractF2mPoint to Multiply.
 * @param u The the TNAF of <code>&#955;</code>..
 * @return <code>&#955; * p</code>
 */
// NSMutableArray == int8_t[]
+ (AbstractF2mPoint*)multiplyFromTnaf:(AbstractF2mPoint*)p withU:(NSMutableArray*)u {
    AbstractF2mPoint *q = nil;
    @autoreleasepool {
        ECCurve *curve = [p curve];
        q = (AbstractF2mPoint*)[curve infinity];
        AbstractF2mPoint *pNeg = (AbstractF2mPoint*)[p negate];
        int tauCount = 0;
        for (int i = (int)(u.count) - 1; i >= 0; i--) {
            ++tauCount;
            int8_t ui = [u[i] charValue];
            if (ui != 0) {
                q = [q tauPow:tauCount];
                tauCount = 0;
                
                ECPoint *x = ui > 0 ? p : pNeg;
                q = (AbstractF2mPoint*)[q add:x];
            }
        }
        if (tauCount > 0) {
            q = [q tauPow:tauCount];
        }
        [q retain];
    }
    return (q ? [q autorelease] : nil);
}

/**
 * Computes the <code>[&#964;]</code>-adic window NAF of an element
 * <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>.
 * @param mu The parameter &#956; of the elliptic curve.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code> of which to compute the
 * <code>[&#964;]</code>-adic NAF.
 * @param width The window width of the resulting WNAF.
 * @param pow2w 2<sup>width</sup>.
 * @param tw The auxiliary value <code>t<sub>w</sub></code>.
 * @param alpha The <code>&#945;<sub>u</sub></code>'s for the window width.
 * @return The <code>[&#964;]</code>-adic window NAF of
 * <code>&#955;</code>.
 */
// return == int8_t[], alpha == ZTauElement[]
+ (NSMutableArray*)tauAdicWNaf:(int8_t)mu withLambda:(ZTauElement*)lambda withWidth:(int8_t)width withPow2w:(BigInteger*)pow2w withTw:(BigInteger*)tw withAlpha:(NSMutableArray*)alpha {
    if (!((mu == 1) || (mu == -1))) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"mu must be 1 or -1" userInfo:nil];
    }
    
    NSMutableArray *u = nil;
    @autoreleasepool {
        BigInteger *norm = [Tnaf norm:mu withLambda:lambda];
        
        // Ceiling of log2 of the norm
        int log2Norm = [norm bitLength];
        
        // If length(TNAF) > 30, then length(TNAF) < log2Norm + 3.52
        int maxLength = log2Norm > 30 ? log2Norm + 4 + width : 34 + width;
        
        // The array holding the TNAF
        // NSMutableArray = int8_t[]
        u = [[NSMutableArray alloc] initWithSize:maxLength];
        
        // 2^(width - 1)
        BigInteger *pow2wMin1 = [pow2w shiftRightWithN:1];
        
        // Split lambda into two BigIntegers to simplify calculations
        BigInteger *r0 = [lambda u];
        BigInteger *r1 = [lambda v];
        int i = 0;
        
        // while lambda <> (0, 0)
        while (!(([r0 isEqual:[BigInteger Zero]]) && ([r1 isEqual:[BigInteger Zero]]))) {
            // if r0 is odd
            if ([r0 testBitWithN:0]) {
                // uUnMod = r0 + r1*tw Mod 2^width
                BigInteger *uUnMod = [r0 addWithValue:[[r1 multiplyWithVal:tw] modWithM:pow2w]];
                
                int8_t uLocal;
                // if uUnMod >= 2^(width - 1)
                if ([uUnMod compareToWithValue:pow2wMin1] >= 0) {
                    uLocal = (int8_t)[[uUnMod subtractWithN:pow2w] intValue];
                } else {
                    uLocal = (int8_t)[uUnMod intValue];
                }
                // uLocal is now in [-2^(width-1), 2^(width-1)-1]
                
                u[i] = @(uLocal);
                BOOL s = YES;
                if (uLocal < 0) {
                    s = NO;
                    uLocal = (int8_t)(-uLocal);
                }
                // uLocal is now >= 0
                
                if (s) {
                    r0 = [r0 subtractWithN:[alpha[uLocal] u]];
                    r1 = [r1 subtractWithN:[alpha[uLocal] v]];
                } else {
                    r0 = [r0 addWithValue:[alpha[uLocal] u]];
                    r1 = [r1 addWithValue:[alpha[uLocal] v]];
                }
            } else {
                u[i] = @((int8_t)0);
            }
            
            BigInteger *t = r0;
            
            if (mu == 1) {
                r0 = [r1 addWithValue:[r0 shiftRightWithN:1]];
            } else {
                // mu == -1
                r0 = [r1 subtractWithN:[r0 shiftRightWithN:1]];
            }
            r1 = [[t shiftRightWithN:1] negate];
            i++;
        }
    }
    return (u ? [u autorelease] : nil);
}

/**
 * Does the precomputation for WTNAF multiplication.
 * @param p The <code>ECPoint</code> for which to do the precomputation.
 * @param a The parameter <code>a</code> of the elliptic curve.
 * @return The precomputation array for <code>p</code>.
 */
// return == AbstractF2mPoint[]
+ (NSMutableArray*)getPreComp:(AbstractF2mPoint*)p withA:(int8_t)a {
    NSMutableArray *pu = nil;
    @autoreleasepool {
        // NSArray == int8_t[][]
        NSArray *alphaTnaf = (a == 0) ? [Tnaf Alpha0Tnaf] : [Tnaf Alpha1Tnaf];
        
        // NSMutableArray == AbstractF2mPoint[]
        pu = [[NSMutableArray alloc] initWithSize:((uint)(alphaTnaf.count + 1) >> 1)];
        pu[0] = p;
        
        uint precompLen = (uint)(alphaTnaf.count);
        for (uint i = 3; i < precompLen; i += 2) {
            pu[i >> 1] = [Tnaf multiplyFromTnaf:p withU:alphaTnaf[i]];
        }
        
        [[p curve] normalizeAll:pu];
    }
    return (pu ? [pu autorelease] : nil);
}

@end
