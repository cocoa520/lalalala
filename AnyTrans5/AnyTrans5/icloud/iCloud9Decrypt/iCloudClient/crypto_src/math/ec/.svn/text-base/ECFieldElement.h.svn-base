//
//  ECFieldElement.h
//  
//
//  Created by Pallas on 5/5/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class LongArray;

@interface ECFieldElement : NSObject

- (BigInteger*)toBigInteger;
- (NSString*)fieldName;
- (int)fieldSize;
- (ECFieldElement*)add:(ECFieldElement*)b;
- (ECFieldElement*)addOne;
- (ECFieldElement*)subtract:(ECFieldElement*)b;
- (ECFieldElement*)multiply:(ECFieldElement*)b;
- (ECFieldElement*)divide:(ECFieldElement*)b;
- (ECFieldElement*)negate;
- (ECFieldElement*)square;
- (ECFieldElement*)invert;
- (ECFieldElement*)sqrt;

- (int)bitLength;
- (BOOL)isOne;
- (BOOL)isZero;
- (ECFieldElement*)multiplyMinusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y;
- (ECFieldElement*)multiplyPlusProduct:(ECFieldElement*)b withX:(ECFieldElement*)x withY:(ECFieldElement*)y;
- (ECFieldElement*)squareMinusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y;
- (ECFieldElement*)squarePlusProduct:(ECFieldElement*)x withY:(ECFieldElement*)y;
- (ECFieldElement*)squarePow:(int)pow;

- (BOOL)testBitZero;
- (BOOL)equalsWithOther:(ECFieldElement*)other;
- (NSString*)toString;
- (NSMutableData*)getEncoded;

@end

@interface FpFieldElement : ECFieldElement {
@private
    BigInteger *                            _q;
    BigInteger *                            _r;
    BigInteger *                            _x;
}

+ (BigInteger*)calculateResidue:(BigInteger*)p;

- (id)initWithQ:(BigInteger*)q withX:(BigInteger*)x;
- (id)initWithQ:(BigInteger*)q withR:(BigInteger*)r withX:(BigInteger*)x;

- (BigInteger*)Q;
- (BigInteger*)modAdd:(BigInteger*)x1 withX2:(BigInteger*)x2;
- (BigInteger*)modDouble:(BigInteger*)x;
- (BigInteger*)modHalf:(BigInteger*)x;
- (BigInteger*)modHalfAbs:(BigInteger*)x;
- (BigInteger*)modInverse:(BigInteger*)x;
- (BigInteger*)modMult:(BigInteger*)x1 withX2:(BigInteger*)x2;
- (BigInteger*)modReduce:(BigInteger*)x;
- (BigInteger*)modSubtract:(BigInteger*)x1 withX2:(BigInteger*)x2;
- (BOOL)equalsWithFpOther:(FpFieldElement*)other;

@end

static int const Gnb = 1;  // Indicates gaussian normal basis representation (GNB). Number chosen according to X9.62. GNB is not implemented at present.
static int const Tpb = 2;  // Indicates trinomial basis representation (Tpb). Number chosen according to X9.62.
static int const Ppb = 3;  // Indicates pentanomial basis representation (Ppb). Number chosen according to X9.62.

/**
 * Class representing the Elements of the finite field
 * F2m in polynomial basis (PB)
 * representation. Both trinomial (Tpb) and pentanomial (Ppb) polynomial
 * basis representations are supported. Gaussian normal basis (GNB)
 * representation is not supported.
 */
@interface F2mFieldElement : ECFieldElement {
@private
    int                                 _representation;            // Tpb or Ppb.
    int                                 _m;                         // The exponent m of F2m.
    NSMutableArray *                    _ks;                        // int[]
    LongArray *                         _x;                         // The LongArray holding the bits.
}

- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 withX:(BigInteger*)x;
- (id)initWithM:(int)m withK:(int)k withX:(BigInteger*)x;

+ (void)checkFieldElements:(ECFieldElement*)a withB:(ECFieldElement*)b;
/**
 * @return the representation of the field
 * <code>F<sub>2<sup>m</sup></sub></code>, either of
 * {@link F2mFieldElement.Tpb} (trinomial
 * basis representation) or
 * {@link F2mFieldElement.Ppb} (pentanomial
 * basis representation).
 */
- (int)representation;
/**
 * @return the degree <code>m</code> of the reduction polynomial
 * <code>f(z)</code>.
 */
- (int)m;
/**
 * @return Tpb: The integer <code>k</code> where <code>x<sup>m</sup> +
 * x<sup>k</sup> + 1</code> represents the reduction polynomial
 * <code>f(z)</code>.<br/>
 * Ppb: The integer <code>k1</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.<br/>
 */
- (int)k1;
/**
 * @return Tpb: Always returns <code>0</code><br/>
 * Ppb: The integer <code>k2</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.<br/>
 */
- (int)k2;
/**
 * @return Tpb: Always set to <code>0</code><br/>
 * Ppb: The integer <code>k3</code> where <code>x<sup>m</sup> +
 * x<sup>k3</sup> + x<sup>k2</sup> + x<sup>k1</sup> + 1</code>
 * represents the reduction polynomial <code>f(z)</code>.<br/>
 */
- (int)k3;


@end
