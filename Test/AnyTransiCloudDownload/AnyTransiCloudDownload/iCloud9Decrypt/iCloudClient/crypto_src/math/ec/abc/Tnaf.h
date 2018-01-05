//
//  Tnaf.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class ZTauElement;
@class SimpleBigDecimal;
@class AbstractF2mPoint;
@class AbstractF2mCurve;
@class ECFieldElement;

@interface Tnaf : NSObject

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
+ (int8_t)Width;

/**
 * 2<sup>4</sup>
 */
+ (int8_t)Pow2Width;

+ (BigInteger*)MinusOne;
+ (BigInteger*)MinusTwo;
+ (BigInteger*)MinusThree;
+ (BigInteger*)Four;

// NSArray =ZTauElement[] contain [NSNull null]
+ (NSArray*)Alpha0;
// NSArray = int8_t[][] contain [NSNull null]
+ (NSArray*)Alpha0Tnaf;
// NSArray == ZTauElement[] contain [NSNull null]
+ (NSArray*)Alpha1;
// NSArray = int8_t[][] contain [NSNull null]
+ (NSArray*)Alpha1Tnaf;

/**
 * Computes the norm of an element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @return The norm of <code>&#955;</code>.
 */

+ (BigInteger*)norm:(int8_t)mu withLambda:(ZTauElement*)lambda;
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
+ (SimpleBigDecimal*)norm:(int8_t)mu withU:(SimpleBigDecimal*)u withV:(SimpleBigDecimal*)v;

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
+ (ZTauElement*)round:(SimpleBigDecimal*)lambda0 withLambda1:(SimpleBigDecimal*)lambda1 withMu:(int8_t)mu;

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
+ (SimpleBigDecimal*)approximateDivisionByN:(BigInteger*)k withS:(BigInteger*)s withVm:(BigInteger*)vm withA:(int8_t)a withM:(int)m withC:(int)c;

/**
 * Computes the <code>&#964;</code>-adic NAF (non-adjacent form) of an
 * element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>.
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @return The <code>&#964;</code>-adic NAF of <code>&#955;</code>.
 */
// NSMutableArray == int8_t[]
+ (NSMutableArray*)tauAdicNaf:(int8_t)mu withLambda:(ZTauElement*)lambda;

/**
 * Applies the operation <code>&#964;()</code> to an
 * <code>AbstractF2mPoint</code>.
 * @param p The AbstractF2mPoint to which <code>&#964;()</code> is applied.
 * @return <code>&#964;(p)</code>
 */
+ (AbstractF2mPoint*)tau:(AbstractF2mPoint*)p;

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
+ (int8_t)getMuWithCurve:(AbstractF2mCurve*)curve;

+ (int8_t)getMuWithField:(ECFieldElement*)curveA;

+ (int8_t)getMuWithInt:(int)curveA;

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
+ (NSMutableArray*)getLucas:(int8_t)mu withK:(int)k withDoV:(BOOL)doV;

/**
 * Computes the auxiliary value <code>t<sub>w</sub></code>. If the width is
 * 4, then for <code>mu = 1</code>, <code>t<sub>w</sub> = 6</code> and for
 * <code>mu = -1</code>, <code>t<sub>w</sub> = 10</code>
 * @param mu The parameter <code>&#956;</code> of the elliptic curve.
 * @param w The window width of the WTNAF.
 * @return the auxiliary value <code>t<sub>w</sub></code>
 */
+ (BigInteger*)getTw:(int8_t)mu withW:(int)w;

/**
 * Computes the auxiliary values <code>s<sub>0</sub></code> and
 * <code>s<sub>1</sub></code> used for partial modular reduction.
 * @param curve The elliptic curve for which to compute
 * <code>s<sub>0</sub></code> and <code>s<sub>1</sub></code>.
 * @throws ArgumentException if <code>curve</code> is not a
 * Koblitz curve (Anomalous Binary Curve, ABC).
 */
// NSMutableArray == BigInteger[]
+ (NSMutableArray*)getSi:(AbstractF2mCurve*)curve;

// NSMutableArray == BigInteger[]
+ (NSMutableArray*)getSi:(int)fieldSize withCurveA:(int)curveA withCofactor:(BigInteger*)cofactor;

+ (int)getShiftsForCofactor:(BigInteger*)h;

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
+ (ZTauElement*)partModReduction:(BigInteger*)k withM:(int)m withA:(int8_t)a withS:(NSMutableArray*)s withMu:(int8_t)mu withC:(int8_t)c;

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by a <code>BigInteger</code> using the reduced <code>&#964;</code>-adic
 * NAF (RTNAF) method.
 * @param p The AbstractF2mPoint to Multiply.
 * @param k The <code>BigInteger</code> by which to Multiply <code>p</code>.
 * @return <code>k * p</code>
 */
+ (AbstractF2mPoint*)multiplyRTnaf:(AbstractF2mPoint*)p withK:(BigInteger*)k;

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by an element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>
 * using the <code>&#964;</code>-adic NAF (TNAF) method.
 * @param p The AbstractF2mPoint to Multiply.
 * @param lambda The element <code>&#955;</code> of
 * <code><b>Z</b>[&#964;]</code>.
 * @return <code>&#955; * p</code>
 */
+ (AbstractF2mPoint*)multiplyTnaf:(AbstractF2mPoint*)p withLambda:(ZTauElement*)lambda;

/**
 * Multiplies a {@link org.bouncycastle.math.ec.AbstractF2mPoint AbstractF2mPoint}
 * by an element <code>&#955;</code> of <code><b>Z</b>[&#964;]</code>
 * using the <code>&#964;</code>-adic NAF (TNAF) method, given the TNAF
 * of <code>&#955;</code>.
 * @param p The AbstractF2mPoint to Multiply.
 * @param u The the TNAF of <code>&#955;</code>..
 * @return <code>&#955; * p</code>
 */
// NSMutableArray == init8_t[]
+ (AbstractF2mPoint*)multiplyFromTnaf:(AbstractF2mPoint*)p withU:(NSMutableArray*)u;

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
+ (NSMutableArray*)tauAdicWNaf:(int8_t)mu withLambda:(ZTauElement*)lambda withWidth:(int8_t)width withPow2w:(BigInteger*)pow2w withTw:(BigInteger*)tw withAlpha:(NSMutableArray*)alpha;

/**
 * Does the precomputation for WTNAF multiplication.
 * @param p The <code>ECPoint</code> for which to do the precomputation.
 * @param a The parameter <code>a</code> of the elliptic curve.
 * @return The precomputation array for <code>p</code>.
 */
// return == AbstractF2mPoint[]
+ (NSMutableArray*)getPreComp:(AbstractF2mPoint*)p withA:(int8_t)a;

@end
