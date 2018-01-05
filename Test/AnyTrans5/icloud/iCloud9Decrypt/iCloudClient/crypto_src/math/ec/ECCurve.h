//
//  ECCurve.h
//  
//
//  Created by Pallas on 5/5/16.
//
//  Complete

#import <Foundation/Foundation.h>

static int const COORD_AFFINE = 0;
static int const COORD_HOMOGENEOUS = 1;
static int const COORD_JACOBIAN = 2;
static int const COORD_JACOBIAN_CHUDNOVSKY = 3;
static int const COORD_JACOBIAN_MODIFIED = 4;
static int const COORD_LAMBDA_AFFINE = 5;
static int const COORD_LAMBDA_PROJECTIVE = 6;
static int const COORD_SKEWED = 7;

@class Config;
@class ECEndomorphism;
@class ECMultiplier;
@class IFiniteField;
@class ECFieldElement;
@class BigInteger;
@class ECPoint;
@class PreCompInfo;
@class FpPoint;
@class F2mPoint;

@interface ECCurve : NSObject {
@protected
    IFiniteField *                          _m_field;
    ECFieldElement *                        _m_a;
    ECFieldElement *                        _m_b;
    BigInteger *                            _m_order;
    BigInteger *                            _m_cofactor;
    
    int                                     _m_coord;
    ECEndomorphism *                        _m_endomorphism;
    ECMultiplier *                          _m_multiplier;
}

@property (nonatomic, readwrite, retain) IFiniteField *m_field;
@property (nonatomic, readwrite, retain) ECFieldElement *m_a;
@property (nonatomic, readwrite, retain) ECFieldElement *m_b;
@property (nonatomic, readwrite, retain) BigInteger *m_order;
@property (nonatomic, readwrite, retain) BigInteger *m_cofactor;

@property (nonatomic, readwrite, assign) int m_coord;
@property (nonatomic, readwrite, retain) ECEndomorphism *m_endomorphism;
@property (nonatomic, readwrite, retain) ECMultiplier *m_multiplier;


// int[]
+ (NSMutableArray*)GetAllCoordinateSystems;

- (id)initWithField:(IFiniteField*)field;

- (int)fieldSize;
- (ECFieldElement*)fromBigInteger:(BigInteger*)x;
- (BOOL)isValidFieldElement:(BigInteger*)x;

- (Config*)configure;

- (ECPoint*)validatePoint:(BigInteger*)x withY:(BigInteger*)y;
- (ECPoint*)validatePoint:(BigInteger*)x withY:(BigInteger *)y withCompression:(BOOL)withCompression __deprecated;
- (ECPoint*)createPoint:(BigInteger*)x withY:(BigInteger*)y;
- (ECPoint*)createPoint:(BigInteger *)x withY:(BigInteger *)y withCompression:(BOOL)withCompression __deprecated;
- (ECCurve*)cloneCurve;
- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression;
- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement *)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression;
- (ECMultiplier*)createDefaultMultiplier;

- (BOOL)supportsCoordinateSystem:(int)coord;
- (PreCompInfo*)getPreCompInfo:(ECPoint*)point withName:(NSString*)name;
- (void)setPreCompInfo:(ECPoint*)point withName:(NSString*)name withPreCompInfo:(PreCompInfo*)preCompInfo;
- (ECPoint*)importPoint:(ECPoint*)p;
- (void)normalizeAll:(NSMutableArray*)points;
- (void)normalizeAll:(NSMutableArray*)points withOff:(int)off withLen:(int)len withIso:(ECFieldElement*)iso;

- (ECPoint*)infinity;
- (IFiniteField*)field;
- (ECFieldElement*)a;
- (ECFieldElement*)b;
- (BigInteger*)order;
- (BigInteger*)cofactor;
- (int)coordinateSystem;

- (void)checkPoint:(ECPoint*)point;
- (void)checkPoints:(NSMutableArray*)points;
- (void)checkPoints:(NSMutableArray*)points withOff:(int)off withLen:(int)len;

- (BOOL)equalsWithOther:(ECCurve*)other;
- (ECPoint*)decompressPoint:(int)yTilde withX1:(BigInteger*)x1;

- (ECEndomorphism*)getEndomorphism;
- (ECMultiplier*)getMultiplier;

- (ECPoint*)decodePoint:(NSMutableData*)encoded;

@end

@interface Config : NSObject {
@protected
    ECCurve *                               _outer;
    int                                     _coord;
    ECEndomorphism *                        _endomorphism;
    ECMultiplier *                          _multiplier;
}

- (id)initWithOuter:(ECCurve*)outer_ withCoord:(int)coord_ withEndomorphism:(ECEndomorphism*)endomorphism_ withMultiplier:(ECMultiplier*)multiplier_;

- (Config*)setCoordinateSystemWithCoord:(int)coord_;
- (Config*)setEndomorphismWithEndomorphism:(ECEndomorphism*)endomorphism_;
- (Config*)setMultiplierWithMultiplier:(ECMultiplier*)multiplier_;

- (ECCurve*)create;

@end

@interface AbstractFpCurve : ECCurve {
@private
}

- (id)initWithQ:(BigInteger*)q;

@end

@interface FpCurve : AbstractFpCurve {
@protected
    BigInteger *                _m_q;
    BigInteger *                _m_r;
    FpPoint *                   _m_infinity;
}

- (id)initWithQ:(BigInteger*)q withA:(BigInteger*)a withB:(BigInteger*)b;
- (id)initWithQ:(BigInteger*)q withA:(BigInteger*)a withB:(BigInteger*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor;
- (id)initWithQ:(BigInteger*)q withR:(BigInteger*)r withA:(ECFieldElement*)a withB:(ECFieldElement*)b;
- (id)initWithQ:(BigInteger*)q withR:(BigInteger*)r withA:(ECFieldElement*)a withB:(ECFieldElement*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor;

- (BigInteger*)Q;

@end

@interface AbstractF2mCurve : ECCurve {
@private
    /**
     * The auxiliary values <code>s<sub>0</sub></code> and
     * <code>s<sub>1</sub></code> used for partial modular reduction for
     * Koblitz curves.
     */
    NSMutableArray *                        _si;
}

// ks = int[]
+ (BigInteger*)inverse:(int)m withKs:(NSMutableArray*)ks withX:(BigInteger*)x;

- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3;

/**
 * @return the auxiliary values <code>s<sub>0</sub></code> and
 * <code>s<sub>1</sub></code> used for partial modular reduction for
 * Koblitz curves.
 */
// return == BigInteger[]
- (NSMutableArray*)getSi;
/**
 * Returns true if this is a Koblitz curve (ABC curve).
 * @return true if this is a Koblitz curve (ABC curve), false otherwise
 */
- (BOOL)isKoblitz;

@end

@interface F2mCurve : AbstractF2mCurve {
@private
    /**
     * The exponent <code>m</code> of <code>F<sub>2<sup>m</sup></sub></code>.
     */
    int                             _m;
    
    /**
     * TPB: The integer <code>k</code> where <code>x<sup>m</sup> +
     * x<sup>k</sup> + 1</code> represents the reduction polynomial
     * <code>f(z)</code>.<br/>
     * PPB: The integer <code>k1</code> where <code>x<sup>m</sup> +
     * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
     * represents the reduction polynomial <code>f(z)</code>.<br/>
     */
    int                             _k1;
    /**
     * TPB: Always set to <code>0</code><br/>
     * PPB: The integer <code>k2</code> where <code>x<sup>m</sup> +
     * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
     * represents the reduction polynomial <code>f(z)</code>.<br/>
     */
    int                             _k2;
    /**
     * TPB: Always set to <code>0</code><br/>
     * PPB: The integer <code>k3</code> where <code>x<sup>m</sup> +
     * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
     * represents the reduction polynomial <code>f(z)</code>.<br/>
     */
    int                             _k3;
    /**
     * The point at infinity on this curve.
     */
    F2mPoint *                      _m_infinity;
}

/**
 * Constructor for Trinomial Polynomial Basis (TPB).
 * @param m  The exponent <code>m</code> of
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param k The integer <code>k</code> where <code>x<sup>m</sup> +
 * x<sup>k</sup> + 1</code> represents the reduction
 * polynomial <code>f(z)</code>.
 * @param a The coefficient <code>a</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param b The coefficient <code>b</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 */
- (id)initWithM:(int)m withK:(int)k withA:(BigInteger*)a withB:(BigInteger*)b;

/**
 * Constructor for Trinomial Polynomial Basis (TPB).
 * @param m  The exponent <code>m</code> of
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param k The integer <code>k</code> where <code>x<sup>m</sup> +
 * x<sup>k</sup> + 1</code> represents the reduction
 * polynomial <code>f(z)</code>.
 * @param a The coefficient <code>a</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param b The coefficient <code>b</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param order The order of the main subgroup of the elliptic curve.
 * @param cofactor The cofactor of the elliptic curve, i.e.
 * <code>#E<sub>a</sub>(F<sub>2<sup>m</sup></sub>) = h * n</code>.
 */
- (id)initWithM:(int)m withK:(int)k withA:(BigInteger*)a withB:(BigInteger*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor;

/**
 * Constructor for Pentanomial Polynomial Basis (PPB).
 * @param m  The exponent <code>m</code> of
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param k1 The integer <code>k1</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param k2 The integer <code>k2</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param k3 The integer <code>k3</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param a The coefficient <code>a</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param b The coefficient <code>b</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 */
- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3  withA:(BigInteger*)a withB:(BigInteger*)b;

/**
 * Constructor for Pentanomial Polynomial Basis (PPB).
 * @param m  The exponent <code>m</code> of
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param k1 The integer <code>k1</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param k2 The integer <code>k2</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param k3 The integer <code>k3</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.
 * @param a The coefficient <code>a</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param b The coefficient <code>b</code> in the Weierstrass equation
 * for non-supersingular elliptic curves over
 * <code>F<sub>2<sup>m</sup></sub></code>.
 * @param order The order of the main subgroup of the elliptic curve.
 * @param cofactor The cofactor of the elliptic curve, i.e.
 * <code>#E<sub>a</sub>(F<sub>2<sup>m</sup></sub>) = h * n</code>.
 */
- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 withA:(BigInteger*)a withB:(BigInteger*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor;

- (int)m;
- (int)k1;
- (int)k2;
- (int)k3;

- (BOOL)isTrinomial;
- (BigInteger*)n __deprecated;
- (BigInteger*)h __deprecated;

@end