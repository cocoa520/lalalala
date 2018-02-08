//
//  ECPoint.m
//  
//
//  Created by Pallas on 5/5/16.
//
//  Complete

#import "ECPoint.h"
#import "ECAlgorithms.h"
#import "ECCurve.h"
#import "BigInteger.h"
#import "ECFieldElement.h"
#import "ECAlgorithms.h"
#import "CategoryExtend.h"
#import "ECMultiplier.h"

@interface ECPoint ()

@property (nonatomic, readwrite, retain) ECCurve *m_curve;
@property (nonatomic, readwrite, retain) ECFieldElement *m_x;
@property (nonatomic, readwrite, retain) ECFieldElement *m_y;
@property (nonatomic, readwrite, retain) NSMutableArray *m_zs;
@property (nonatomic, readwrite, assign) BOOL m_withCompression;
@property (nonatomic, readwrite, retain) NSMutableDictionary *m_preCompTable;

@end

@implementation ECPoint
@synthesize m_curve = _m_curve;
@synthesize m_x = _m_x;
@synthesize m_y = _m_y;
@synthesize m_zs = _m_zs;
@synthesize m_withCompression = _m_withCompression;
@synthesize m_preCompTable = _m_preCompTable;

// NSMutableArray = ECFieldElement[]
+ (NSMutableArray*)EMPTY_ZS {
    static NSMutableArray *_empty_zs = nil;
    @synchronized(self) {
        if (_empty_zs == nil) {
            _empty_zs = [[NSMutableArray alloc] init];
        }
    }
    return _empty_zs;
}

// NSMutableArray = ECFieldElement[]
+ (NSMutableArray*)getInitialZCoords:(ECCurve*)curve {
    int coord = nil == curve ? COORD_AFFINE : [curve coordinateSystem];
    
    NSMutableArray *retArray = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_AFFINE:
            case COORD_LAMBDA_AFFINE: {
                return [ECPoint EMPTY_ZS];
                break;
            }
            default: {
                break;
            }
        }
        
        ECFieldElement *one = [curve fromBigInteger:[BigInteger One]];
        
        switch (coord) {
            case COORD_HOMOGENEOUS:
            case COORD_JACOBIAN:
            case COORD_LAMBDA_PROJECTIVE: {
                retArray = [[NSMutableArray alloc] initWithObjects:one, nil];
                break;
            }
            case COORD_JACOBIAN_CHUDNOVSKY: {
                retArray = [[NSMutableArray alloc] initWithObjects:one, one, one, nil];
                break;
            }
            case COORD_JACOBIAN_MODIFIED: {
                retArray = [[NSMutableArray alloc] initWithObjects:one, [curve a], nil];
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"Argument" reason:@"unknown coordinate system" userInfo:nil];
                break;
            }
        }
    }
    return (retArray ? [retArray autorelease] : nil);
}

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    if (self = [self initWithCurve:curve withX:x withY:y withZS:[ECPoint getInitialZCoords:curve] withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement *)x withY:(ECFieldElement *)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    if (self = [super init]) {
        [self setM_curve:curve];
        [self setM_x:x];
        [self setM_y:y];
        [self setM_zs:zs];
        [self setM_withCompression:withCompression];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_curve:nil];
    [self setM_x:nil];
    [self setM_y:nil];
    [self setM_zs:nil];
    [self setM_preCompTable:nil];
    [super dealloc];
#endif
}

- (BOOL)satisfiesCofactor {
    BigInteger *h = [[self curve] cofactor];
    return h == nil || [h isEqual:[BigInteger One]] || ![[ECAlgorithms referenceMultiply:self withK:h] isInfinity];
}

- (BOOL)satisfiesCurveEquation {
    return NO;
}

- (ECPoint*)getDetachedPoint {
    return [[self normalize] detach];
}

- (ECCurve*)curve {
    return self.m_curve;
}

- (ECPoint*)detach {
    return nil;
}

- (int)curveCoordinateSystem {
    // Cope with null curve, most commonly used by implicitlyCa
    return nil == self.m_curve ? COORD_AFFINE : [self.m_curve coordinateSystem];
}

/**
 * Normalizes this point, and then returns the affine x-coordinate.
 *
 * Note: normalization can be expensive, this method is deprecated in favour
 * of caller-controlled normalization.
 */
- (ECFieldElement*)x {
    return [[self normalize] xCoord];
}

/**
 * Normalizes this point, and then returns the affine y-coordinate.
 *
 * Note: normalization can be expensive, this method is deprecated in favour
 * of caller-controlled normalization.
 */
- (ECFieldElement*)y {
    return [[self normalize] yCoord];
}

/**
 * Returns the affine x-coordinate after checking that this point is normalized.
 *
 * @return The affine x-coordinate of this point
 * @throws IllegalStateException if the point is not normalized
 */
- (ECFieldElement*)affineXCoord {
    [self checkNormalized];
    return [self xCoord];
}

/**
 * Returns the affine y-coordinate after checking that this point is normalized
 *
 * @return The affine y-coordinate of this point
 * @throws IllegalStateException if the point is not normalized
 */
- (ECFieldElement*)affineYCoord {
    [self checkNormalized];
    return [self yCoord];
}

/**
 * Returns the x-coordinate.
 *
 * Caution: depending on the curve's coordinate system, this may not be the same value as in an
 * affine coordinate system; use Normalize() to get a point where the coordinates have their
 * affine values, or use AffineXCoord if you expect the point to already have been normalized.
 *
 * @return the x-coordinate of this point
 */
- (ECFieldElement*)xCoord {
    return self.m_x;
}

/**
 * Returns the y-coordinate.
 *
 * Caution: depending on the curve's coordinate system, this may not be the same value as in an
 * affine coordinate system; use Normalize() to get a point where the coordinates have their
 * affine values, or use AffineYCoord if you expect the point to already have been normalized.
 *
 * @return the y-coordinate of this point
 */
- (ECFieldElement*)yCoord {
    return self.m_y;
}

- (ECFieldElement*)getZCoord:(int)index {
    return (index < 0 || index >= self.m_zs.count) ? nil : (ECFieldElement*)(self.m_zs[index]);
}

// NSMutableArray == ECFieldElement[]
- (NSMutableArray*)getZCoords {
    int zsLen = (int)(self.m_zs.count);
    if (zsLen == 0) {
        return self.m_zs;
    }
    NSMutableArray *copy = [[[NSMutableArray alloc] initWithSize:zsLen] autorelease];
    [copy copyFromIndex:0 withSource:self.m_zs withSourceIndex:0 withLength:zsLen];
    return copy;
}

- (ECFieldElement*)rawXCoord {
    return self.m_x;
}

- (ECFieldElement*)rawYCoord {
    return self.m_y;
}

// NSMutableArray == ECFieldElement[]
- (NSMutableArray*)rawZCoords {
    return self.m_zs;
}

- (void)checkNormalized {
    if (![self isNormalized]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"point not in normal form" userInfo:nil];
    }
}

- (BOOL)isNormalized {
    int coord = [self curveCoordinateSystem];
    
    return coord == COORD_AFFINE || coord == COORD_LAMBDA_AFFINE || [self isInfinity] || [(ECFieldElement*)([self rawZCoords][0]) isOne];
}

/**
 * Normalization ensures that any projective coordinate is 1, and therefore that the x, y
 * coordinates reflect those of the equivalent point in an affine coordinate system.
 *
 * @return a new ECPoint instance representing the same point, but with normalized coordinates
 */
- (ECPoint*)normalize {
    if ([self isInfinity]) {
        return self;
    }
    
    switch ([self curveCoordinateSystem]) {
        case COORD_AFFINE:
        case COORD_LAMBDA_AFFINE: {
            return self;
        }
        default: {
            ECFieldElement *Z1 = (ECFieldElement*)([self rawZCoords][0]);
            if ([Z1 isOne]) {
                return self;
            }
            
            ECPoint *retPoint = nil;
            @autoreleasepool {
                retPoint = [self normalize:[Z1 invert]];
                [retPoint retain];
            }
            return (retPoint ? [retPoint autorelease] : nil);
        }
    }
}

- (ECPoint*)normalize:(ECFieldElement*)zInv {
    switch ([self curveCoordinateSystem]) {
        case COORD_HOMOGENEOUS:
        case COORD_LAMBDA_PROJECTIVE: {
            return [self createScaledPoint:zInv withSy:zInv];
        }
        case COORD_JACOBIAN:
        case COORD_JACOBIAN_CHUDNOVSKY:
        case COORD_JACOBIAN_MODIFIED: {
            ECPoint *retPoint = nil;
            @autoreleasepool {
                ECFieldElement *zInv2 = [zInv square], *zInv3 = [zInv2 multiply:zInv];
                retPoint = [self createScaledPoint:zInv2 withSy:zInv3];
                [retPoint retain];
            }
            return (retPoint ? [retPoint autorelease] : nil);
        }
        default: {
            @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"not a projective coordinate system" userInfo:nil];
        }
    }
}

- (ECPoint*)createScaledPoint:(ECFieldElement*)sx withSy:(ECFieldElement*)sy {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = [[self curve] createRawPoint:[[self rawXCoord] multiply:sx] withY:[[self rawYCoord] multiply:sy] withCompression:[self isCompressed]];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (BOOL)isInfinity {
    return self.m_x == nil && self.m_y == nil;
}

- (BOOL)isCompressed {
    return self.m_withCompression;
}

- (BOOL)isValid {
    if ([self isInfinity]) {
        return true;
    }
    
    // TODO Sanity-check the field elements
    ECCurve *curve = [self curve];
    if (curve != nil) {
        if (![self satisfiesCurveEquation]) {
            return NO;
        }
        
        if (![self satisfiesCofactor]) {
            return NO;
        }
    }
    
    return YES;
}

- (ECPoint*)scaleX:(ECFieldElement*)scale {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = ([self isInfinity] ? self : [[self curve] createRawPoint:[[self rawXCoord] multiply:scale] withY:[self rawYCoord] withZS:[self rawZCoords] withCompression:[self isCompressed]]);
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)scaleY:(ECFieldElement*)scale {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = ([self isInfinity] ? self : [[self curve] createRawPoint:[self rawXCoord] withY:[[self rawYCoord] multiply:scale] withZS:[self rawZCoords] withCompression:[self isCompressed]]);
        [retPoint retain];
    }
    return [retPoint autorelease];
}

- (BOOL)isEqual:(id)object {
    if (object != nil && [object isKindOfClass:[ECPoint class]]) {
        return [self equalsWithOther:(ECPoint*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECPoint*)other {
    @autoreleasepool {
        if (self == other) {
            return YES;
        }
        if (nil == other) {
            return NO;
        }
        
        ECCurve *c1 = [self curve], *c2 = [other curve];
        BOOL n1 = (nil == c1), n2 = (nil == c2);
        BOOL i1 = [self isInfinity], i2 = [other isInfinity];
        
        if (i1 || i2) {
            return (i1 && i2) && (n1 || n2 || [c1 equalsWithOther:c2]);
        }
        
        ECPoint *p1 = self, *p2 = other;
        if (n1 && n2) {
            // Points with null curve are in affine form, so already normalized
        } else if (n1) {
            p2 = [p2 normalize];
        } else if (n2) {
            p1 = [p1 normalize];
        } else if (![c1 equalsWithOther:c2]) {
            return NO;
        } else {
            // TODO Consider just requiring already normalized, to avoid silent performance degradation
            // NSMutableArray == ECPoint[]
            NSMutableArray *points = [[NSMutableArray alloc] initWithObjects:self, [c1 importPoint:p2], nil];
            [points setFixedSize:2];
            
            // TODO This is a little strong, really only requires coZNormalizeAll to get Zs equal
            [c1 normalizeAll:points];
            
            p1 = points[0];
            p2 = points[1];
#if !__has_feature(objc_arc)
            if (points != nil) [points release]; points = nil;
#endif
        }
        
        return [p1.xCoord equalsWithOther:p2.xCoord] && [p1.yCoord equalsWithOther:p2.yCoord];
    }
}

- (NSString*)toString {
    if ([self isInfinity]) {
        return @"INF";
    }
    
    NSMutableString *mStr = [[[NSMutableString alloc] init] autorelease];
    @autoreleasepool {
        [mStr appendString:@"("];
        [mStr appendString:[[self rawXCoord] toString]];
        [mStr appendString:@","];
        [mStr appendString:[[self rawYCoord] toString]];
        for (int i = 0; i < self.m_zs.count; ++i) {
            [mStr appendString:@","];
            [mStr appendString:[(ECFieldElement*)(self.m_zs[i]) toString]];
        }
        [mStr appendString:@")"];
    }
    return mStr;
}

- (NSMutableData*)getEncoded {
    return [self getEncodedWithCompressed:self.m_withCompression];
}

- (NSMutableData*)getEncodedWithCompressed:(BOOL)compressed {
    return nil;
}

- (BOOL)compressionYTilde {
    return NO;
}

- (ECPoint*)add:(ECPoint*)b {
    return nil;
}

- (ECPoint*)subtract:(ECPoint*)b {
    return nil;
}

- (ECPoint*)negate {
    return nil;
}

- (ECPoint*)timesPow2:(int)e {
    if (e < 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"e cannot be negative" userInfo:nil];
    }
    
    ECPoint *p = self;
    while (--e >= 0) {
        p = [p twice];
    }
    return p;
}

- (ECPoint*)twice {
    return nil;
}

- (ECPoint*)multiply:(BigInteger*)b {
    return nil;
}

- (ECPoint*)twicePlus:(ECPoint*)b {
    return [[self twice] add:b];
}

- (ECPoint*)threeTimes {
    return [self twicePlus:self];
}

@end

@implementation ECPointBase

- (id)initWithCurve:(ECCurve *)curve withX:(ECFieldElement *)x withY:(ECFieldElement *)y withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve *)curve withX:(ECFieldElement *)x withY:(ECFieldElement *)y withZS:(NSMutableArray *)zs withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withZS:zs withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * return the field element encoded with point compression. (S 4.3.6)
 */
- (NSMutableData*)getEncodedWithCompressed:(BOOL)compressed {
    NSMutableData *retData = nil;
    @autoreleasepool {
        if ([self isInfinity]) {
            retData = [[NSMutableData alloc] initWithSize:1];
        } else {
            ECPoint *normed = [self normalize];
            
            NSMutableData *X = [normed.xCoord getEncoded];
            
            if (compressed) {
                retData = [[NSMutableData alloc] initWithSize:((int)(X.length) + 1)];
                ((Byte*)(retData.bytes))[0] = (Byte)(normed.compressionYTilde ? 0x03 : 0x02);
                [retData copyFromIndex:1 withSource:X withSourceIndex:0 withLength:(int)(X.length)];
            } else {
                NSMutableData *Y = [normed.yCoord getEncoded];
                
                {
                    retData = [[NSMutableData alloc] initWithSize:((int)(X.length) + (int)(Y.length)  + 1)];
                    ((Byte*)(retData.bytes))[0] = 0x04;
                    [retData copyFromIndex:1 withSource:X withSourceIndex:0 withLength:(int)(X.length)];
                    [retData copyFromIndex:((int)(X.length) + 1) withSource:Y withSourceIndex:0 withLength:(int)(Y.length)];
                }
            }
        }
    }
    return (retData ? [retData autorelease] : nil);
}

/**
 * Multiplies this <code>ECPoint</code> by the given number.
 * @param k The multiplicator.
 * @return <code>k * this</code>.
 */
- (ECPoint*)multiply:(BigInteger*)k {
    ECPoint *ecP = nil;
    @autoreleasepool {
        ecP = [[[self curve] getMultiplier] multiply:self withK:k];
        [ecP retain];
    }
    return (ecP ? [ecP autorelease] : nil);
}

@end

@implementation AbstractFpPoint

- (id)initWithCurve:(ECCurve *)curve withX:(ECFieldElement *)x withY:(ECFieldElement *)y withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve *)curve withX:(ECFieldElement *)x withY:(ECFieldElement *)y withZS:(NSMutableArray *)zs withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withZS:zs withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)compressionYTilde {
    return [[self affineYCoord] testBitZero];
}

- (BOOL)satisfiesCurveEquation {
    ECFieldElement *X = [self rawXCoord], *Y = [self rawYCoord], *A = [[self curve] a], *B = [[self curve] b];
    BOOL retVal = NO;
    @autoreleasepool {
        ECFieldElement *lhs = [Y square];
        
        switch ([self curveCoordinateSystem]) {
            case COORD_AFFINE: {
                break;
            }
            case COORD_HOMOGENEOUS: {
                ECFieldElement *Z = [self rawZCoords][0];
                if (![Z isOne]) {
                    ECFieldElement *Z2 = [Z square], *Z3 = [Z multiply:Z2];
                    lhs = [lhs multiply:Z];
                    A = [A multiply:Z2];
                    B = [B multiply:Z3];
                }
                break;
            }
            case COORD_JACOBIAN:
            case COORD_JACOBIAN_CHUDNOVSKY:
            case COORD_JACOBIAN_MODIFIED: {
                ECFieldElement *Z = [self rawZCoords][0];
                if (![Z isOne]) {
                    ECFieldElement *Z2 = [Z square], *Z4 = [Z2 square], *Z6 = [Z2 multiply:Z4];
                    A = [A multiply:Z4];
                    B = [B multiply:Z6];
                }
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
            }
        }
        
        ECFieldElement *rhs = [[[[X square] add:A] multiply:X] add:B];
        
        retVal = [lhs equalsWithOther:rhs];
    }
    
    return retVal;
}

- (ECPoint*)subtract:(ECPoint*)b {
    if ([b isInfinity]) {
        return self;
    }
    
    // Add -b
    return [self add:[b negate]];
}

@end

/**
 * Elliptic curve points over Fp
 */
@implementation FpPoint

/**
 * Create a point which encodes without point compression.
 *
 * @param curve the curve to use
 * @param x affine x co-ordinate
 * @param y affine y co-ordinate
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    if (self == [self initWithCurve:curve withX:x withY:y withCompression:NO]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Create a point that encodes with or without point compression.
 *
 * @param curve the curve to use
 * @param x affine x co-ordinate
 * @param y affine y co-ordinate
 * @param withCompression if true encode with point compression
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:withCompression]) {
        if ((x == nil) != (y == nil)) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Exactly one of the field elements is null" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withZS:zs withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (ECPoint*)detach {
    return [[[FpPoint alloc] initWithCurve:nil withX:[self affineXCoord] withY:[self affineYCoord]] autorelease];
}

- (ECFieldElement*)getZCoord:(int)index {
    if (index == 1 && COORD_JACOBIAN_MODIFIED == [self curveCoordinateSystem]) {
        return [self getJacobianModifiedW];
    }
    return [super getZCoord:index];
}

// B.3 pg 62
- (ECPoint*)add:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return self;
    }
    if (self == b) {
        return [self twice];
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    ECFieldElement *X1 = [self rawXCoord], *Y1 = [self rawYCoord];
    ECFieldElement *X2 = [b rawXCoord], *Y2 = [b rawYCoord];
    
    switch (coord) {
        case COORD_AFFINE: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *dx = [X2 subtract:X1], *dy = [Y2 subtract:Y1];
                
                if ([dx isZero]) {
                    if ([dy isZero]) {
                        // this == b, i.e. this must be doubled
                        retVal = [self twice];
                    } else {
                        // this == -b, i.e. the result is the point at infinity
                        retVal = [[self curve] infinity];
                    }
                    [retVal retain];
                } else {
                    ECFieldElement *gamma = [dy divide:dx];
                    ECFieldElement *X3 = [[[gamma square] subtract:X1] subtract:X2];
                    ECFieldElement *Y3 = [[gamma multiply:[X1 subtract:X3]] subtract:Y1];
                    
                    retVal = [[FpPoint alloc] initWithCurve:[self curve] withX:X3 withY:Y3 withCompression:[self isCompressed]];
                }
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        case COORD_HOMOGENEOUS: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *Z1 = [self rawZCoords][0];
                ECFieldElement *Z2 = [b rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                bool Z2IsOne = [Z2 isOne];
                
                ECFieldElement *u1 = Z1IsOne ? Y2 : [Y2 multiply:Z1];
                ECFieldElement *u2 = Z2IsOne ? Y1 : [Y1 multiply:Z2];
                ECFieldElement *u = [u1 subtract:u2];
                ECFieldElement *v1 = Z1IsOne ? X2 : [X2 multiply:Z1];
                ECFieldElement *v2 = Z2IsOne ? X1 : [X1 multiply:Z2];
                ECFieldElement *v = [v1 subtract:v2];
                
                // Check if b == this or b == -this
                if ([v isZero]) {
                    if ([u isZero]) {
                        // this == b, i.e. this must be doubled
                        retVal = [self twice];
                    } else {
                        // this == -b, i.e. the result is the point at infinity
                        retVal = [curve infinity];
                    }
                    [retVal retain];
                } else {
                    // TODO Optimize for when w == 1
                    ECFieldElement *w = Z1IsOne ? Z2 : Z2IsOne ? Z1 : [Z1 multiply:Z2];
                    ECFieldElement *vSquared = [v square];
                    ECFieldElement *vCubed = [vSquared multiply:v];
                    ECFieldElement *vSquaredV2 = [vSquared multiply:v2];
                    ECFieldElement *A = [[[[u square] multiply:w] subtract:vCubed] subtract:[self two:vSquaredV2]];
                    
                    ECFieldElement *X3 = [v multiply:A];
                    ECFieldElement *Y3 = [[vSquaredV2 subtract:A] multiplyMinusProduct:u withX:u2 withY:vCubed];
                    ECFieldElement *Z3 = [vCubed multiply:w];
                    
                    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                    [tmpArray setFixedSize:1];
                    retVal = [[FpPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                    if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                }
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        case COORD_JACOBIAN:
        case COORD_JACOBIAN_MODIFIED: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *Z1 = [self rawZCoords][0];
                ECFieldElement *Z2 = [b rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                
                ECFieldElement *X3, *Y3, *Z3, *Z3Squared = nil;
                
                if (!Z1IsOne && [Z1 equalsWithOther:Z2]) {
                    // TODO Make this available as public method coZAdd?
                    ECFieldElement *dx = [X1 subtract:X2], *dy = [Y1 subtract:Y2];
                    if ([dx isZero]) {
                        if ([dy isZero]) {
                            retVal = [self twice];
                        } else {
                            retVal = [curve infinity];
                        }
                        [retVal retain];
                        goto jumpTo;
                    }
                    
                    ECFieldElement *C = [dx square];
                    ECFieldElement *W1 = [X1 multiply:C], *W2 = [X2 multiply:C];
                    ECFieldElement *A1 = [[W1 subtract:W2] multiply:Y1];
                    
                    X3 = [[[dy square] subtract:W1] subtract:W2];
                    Y3 = [[[W1 subtract:X3] multiply:dy] subtract:A1];
                    Z3 = dx;
                    
                    if (Z1IsOne) {
                        Z3Squared = C;
                    } else {
                        Z3 = [Z3 multiply:Z1];
                    }
                } else {
                    ECFieldElement *Z1Squared, *U2, *S2;
                    if (Z1IsOne) {
                        Z1Squared = Z1; U2 = X2; S2 = Y2;
                    } else {
                        Z1Squared = [Z1 square];
                        U2 = [Z1Squared multiply:X2];
                        ECFieldElement *Z1Cubed = [Z1Squared multiply:Z1];
                        S2 = [Z1Cubed multiply:Y2];
                    }
                    
                    BOOL Z2IsOne = [Z2 isOne];
                    ECFieldElement *Z2Squared, *U1, *S1;
                    if (Z2IsOne) {
                        Z2Squared = Z2; U1 = X1; S1 = Y1;
                    } else {
                        Z2Squared = [Z2 square];
                        U1 = [Z2Squared multiply:X1];
                        ECFieldElement *Z2Cubed = [Z2Squared multiply:Z2];
                        S1 = [Z2Cubed multiply:Y1];
                    }
                    
                    ECFieldElement *H = [U1 subtract:U2];
                    ECFieldElement *R = [S1 subtract:S2];
                    
                    // Check if b == this or b == -this
                    if ([H isZero]) {
                        if ([R isZero]) {
                            // this == b, i.e. this must be doubled
                            retVal = [self twice];
                        } else {
                            // this == -b, i.e. the result is the point at infinity
                            retVal = [curve infinity];
                        }
                        [retVal retain];
                        goto jumpTo;
                    }
                    
                    ECFieldElement *HSquared = [H square];
                    ECFieldElement *G = [HSquared multiply:H];
                    ECFieldElement *V = [HSquared multiply:U1];
                    
                    X3 = [[[R square] add:G] subtract:[self two:V]];
                    Y3 = [[V subtract:X3] multiplyMinusProduct:R withX:G withY:S1];
                    
                    Z3 = H;
                    if (!Z1IsOne) {
                        Z3 = [Z3 multiply:Z1];
                    }
                    if (!Z2IsOne) {
                        Z3 = [Z3 multiply:Z2];
                    }
                    
                    if (Z3 == H) {
                        Z3Squared = HSquared;
                    }
                }
                
                // zs == ECFieldElement[]
                NSMutableArray *zs;
                if (coord == COORD_JACOBIAN_MODIFIED) {
                    // TODO If the result will only be used in a subsequent addition, we don't need W3
                    ECFieldElement *W3 = [self calculateJacobianModifiedW:Z3 withZsquared:Z3Squared];
                    zs = [[NSMutableArray alloc] initWithObjects:Z3, W3, nil];
                } else {
                    zs = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                }
                
                retVal = [[FpPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:zs withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (zs != nil) [zs release]; zs = nil;
#endif
            jumpTo:;
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        default: {
            @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
        }
    }
}

// B.3 pg 62
- (ECPoint*)twice {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *Y1 = [self rawYCoord];
    if ([Y1 isZero]) {
        return [curve infinity];
    }
    
    int coord = [curve coordinateSystem];
    
    ECFieldElement *X1 = [self rawXCoord];
    
    switch (coord) {
        case COORD_AFFINE: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *X1Squared = [X1 square];
                ECFieldElement *gamma = [[[self three:X1Squared] add:[[self curve] a]] divide:[self two:Y1]];
                ECFieldElement *X3 = [[gamma square] subtract:[self two:X1]];
                ECFieldElement *Y3 = [[gamma multiply:[X1 subtract:X3]] subtract:Y1];
                retVal = [[FpPoint alloc] initWithCurve:[self curve] withX:X3 withY:Y3 withCompression:[self isCompressed]];
            }
            
            return (retVal ? [retVal autorelease] : nil);
        }
        case COORD_HOMOGENEOUS: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *Z1 = [self rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                
                // TODO Optimize for small negative a4 and -3
                ECFieldElement *w = [curve a];
                if (![w isZero] && !Z1IsOne) {
                    w = [w multiply:[Z1 square]];
                }
                w = [w add:[self three:[X1 square]]];
                
                ECFieldElement *s = Z1IsOne ? Y1 : [Y1 multiply:Z1];
                ECFieldElement *t = Z1IsOne ? [Y1 square] : [s multiply:Y1];
                ECFieldElement *B = [X1 multiply:t];
                ECFieldElement *_4B = [self four:B];
                ECFieldElement *h = [[w square] subtract:[self two:_4B]];
                
                ECFieldElement *_2s = [self two:s];
                ECFieldElement *X3 = [h multiply:_2s];
                ECFieldElement *_2t = [self two:t];
                ECFieldElement *Y3 = [[[_4B subtract:h] multiply:w] subtract:[self two:[_2t square]]];
                ECFieldElement *_4sSquared = Z1IsOne ? [self two:_2t] : [_2s square];
                ECFieldElement *Z3 = [[self two:_4sSquared] multiply:s];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                retVal = [[FpPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        case COORD_JACOBIAN: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *Z1 = [self rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                
                ECFieldElement *Y1Squared = [Y1 square];
                ECFieldElement *T = [Y1Squared square];
                
                ECFieldElement *a4 = [curve a];
                ECFieldElement *a4Neg = [a4 negate];
                
                ECFieldElement *M, *S;
                if ([[a4Neg toBigInteger] isEqual:[BigInteger Three]]) {
                    ECFieldElement *Z1Squared = Z1IsOne ? Z1 : [Z1 square];
                    M = [self three:[[X1 add:Z1Squared] multiply:[X1 subtract:Z1Squared]]];
                    S = [self four:[Y1Squared multiply:X1]];
                } else {
                    ECFieldElement *X1Squared = [X1 square];
                    M = [self three:X1Squared];
                    if (Z1IsOne) {
                        M = [M add:a4];
                    } else if (![a4 isZero]) {
                        ECFieldElement *Z1Squared = Z1IsOne ? Z1 : [Z1 square];
                        ECFieldElement *Z1Pow4 = [Z1Squared square];
                        if ([a4Neg bitLength] < [a4 bitLength]) {
                            M = [M subtract:[Z1Pow4 multiply:a4Neg]];
                        } else {
                            M = [M add:[Z1Pow4 multiply:a4]];
                        }
                    }
                    //S = two(doubleProductFromSquares(X1, Y1Squared, X1Squared, T));
                    S = [self four:[X1 multiply:Y1Squared]];
                }
                
                ECFieldElement *X3 = [[M square] subtract:[self two:S]];
                ECFieldElement *Y3 = [[[S subtract:X3] multiply:M] subtract:[self eight:T]];
                
                ECFieldElement *Z3 = [self two:Y1];
                if (!Z1IsOne) {
                    Z3 = [Z3 multiply:Z1];
                }
                
                // Alternative calculation of Z3 using fast square
                //ECFieldElement Z3 = doubleProductFromSquares(Y1, Z1, Y1Squared, Z1Squared);
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                retVal = [[FpPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        case COORD_JACOBIAN_MODIFIED: {
            return [self twiceJacobianModified:YES];
        }
        default: {
            @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
        }
    }
}

- (ECPoint*)twicePlus:(ECPoint*)b {
    if (self == b) {
        return [self threeTimes];
    }
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return [self twice];
    }
    
    ECFieldElement *Y1 = [self rawYCoord];
    if ([Y1 isZero]) {
        return b;
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    switch (coord) {
        case COORD_AFFINE: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                ECFieldElement *X1 = [self rawXCoord];
                ECFieldElement *X2 = [b rawXCoord], *Y2 = [b rawYCoord];
                
                ECFieldElement *dx = [X2 subtract:X1], *dy = [Y2 subtract:Y1];
                
                if ([dx isZero]) {
                    if ([dy isZero]) {
                        // this == b i.e. the result is 3P
                        retVal = [self threeTimes];
                    } else {
                        // this == -b, i.e. the result is P
                        retVal = self;
                    }
                    [retVal retain];
                } else {
                    /*
                     * Optimized calculation of 2P + Q, as described in "Trading Inversions for
                     * Multiplications in Elliptic Curve Cryptography", by Ciet, Joye, Lauter, Montgomery.
                     */
                    ECFieldElement *X = [dx square], *Y = [dy square];
                    ECFieldElement *d = [[X multiply:[[self two:X1] add:X2]] subtract:Y];
                    if ([d isZero]) {
                        retVal = [[self curve] infinity];
                        [retVal retain];
                    } else {
                        ECFieldElement *D = [d multiply:dx];
                        ECFieldElement *I = [D invert];
                        ECFieldElement *L1 = [[d multiply:I] multiply:dy];
                        ECFieldElement *L2 = [[[[[self two:Y1] multiply:X] multiply:dx] multiply:I] subtract:L1];
                        ECFieldElement *X4 = [[[L2 subtract:L1] multiply:[L1 add:L2]] add:X2];
                        ECFieldElement *Y4 = [[[X1 subtract:X4] multiply:L2] subtract:Y1];
                        
                        retVal = [[FpPoint alloc] initWithCurve:[self curve] withX:X4 withY:Y4 withCompression:[self isCompressed]];
                    }
                }
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        case COORD_JACOBIAN_MODIFIED: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                retVal = [[self twiceJacobianModified:NO] add:b];
                [retVal retain];
            }
            return (retVal ? [retVal autorelease] : nil);
        }
        default: {
            ECPoint *retVal = nil;
            @autoreleasepool {
                retVal = [[self twice] add:b];
                [retVal retain];
            }
            return (retVal ? [retVal autorelease] : nil);
        }
    }
}

- (ECPoint*)threeTimes {
    if ([self isInfinity]) {
        return self;
    }
    
    ECFieldElement *Y1 = [self rawYCoord];
    if ([Y1 isZero]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_AFFINE: {
                ECFieldElement *X1 = [self rawXCoord];
                
                ECFieldElement *_2Y1 = [self two:Y1];
                ECFieldElement *X = [_2Y1 square];
                ECFieldElement *Z = [[self three:[X1 square]] add:[[self curve] a]];
                ECFieldElement *Y = [Z square];
                
                ECFieldElement *d = [[[self three:X1] multiply:X] subtract:Y];
                if ([d isZero]) {
                    retPoint = [[self curve] infinity];
                    [retPoint retain];
                } else {
                    ECFieldElement *D = [d multiply:_2Y1];
                    ECFieldElement *I = [D invert];
                    ECFieldElement *L1 = [[d multiply:I] multiply:Z];
                    ECFieldElement *L2 = [[[X square] multiply:I] subtract:L1];
                    
                    ECFieldElement *X4 = [[[L2 subtract:L1] multiply:[L1 add:L2]] add:X1];
                    ECFieldElement *Y4 = [[[X1 subtract:X4] multiply:L2] subtract:Y1];
                    retPoint = [[FpPoint alloc] initWithCurve:[self curve] withX:X4 withY:Y4 withCompression:[self isCompressed]];
                }
                break;
            }
            case COORD_JACOBIAN_MODIFIED: {
                retPoint = [[self twiceJacobianModified:NO] add:self];
                [retPoint retain];
                break;
            }
            default: {
                // NOTE: Be careful about recursions between TwicePlus and ThreeTimes
                retPoint = [[self twice] add:self];
                [retPoint retain];
                break;
            }
        }
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)timesPow2:(int)e {
    if (e < 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"e cannot be negative" userInfo:nil];
    }
    if (e == 0 || [self isInfinity]) {
        return self;
    }
    if (e == 1) {
        return [self twice];
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *Y1 = [self rawYCoord];
    if ([Y1 isZero]) {
        return [curve infinity];
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        int coord = [curve coordinateSystem];
        
        ECFieldElement *W1 = [curve a];
        ECFieldElement *X1 = [self rawXCoord];
        ECFieldElement *Z1 = [self rawZCoords].count < 1 ? [curve fromBigInteger:[BigInteger One]] : [self rawZCoords][0];
        
        if (![Z1 isOne]) {
            switch (coord) {
                case COORD_HOMOGENEOUS: {
                    ECFieldElement *Z1Sq = [Z1 square];
                    X1 = [X1 multiply:Z1];
                    Y1 = [Y1 multiply:Z1Sq];
                    W1 = [self calculateJacobianModifiedW:Z1 withZsquared:Z1Sq];
                    break;
                }
                case COORD_JACOBIAN: {
                    W1 = [self calculateJacobianModifiedW:Z1 withZsquared:nil];
                    break;
                }
                case COORD_JACOBIAN_MODIFIED: {
                    W1 = [self getJacobianModifiedW];
                    break;
                }
            }
        }
        
        for (int i = 0; i < e; ++i) {
            if ([Y1 isZero]) {
                retPoint = [curve infinity];
                [retPoint retain];
                goto jumpTo;
            }
            
            ECFieldElement *X1Squared = [X1 square];
            ECFieldElement *M = [self three:X1Squared];
            ECFieldElement *_2Y1 = [self two:Y1];
            ECFieldElement *_2Y1Squared = [_2Y1 multiply:Y1];
            ECFieldElement *S = [self two:[X1 multiply:_2Y1Squared]];
            ECFieldElement *_4T = [_2Y1Squared square];
            ECFieldElement *_8T = [self two:_4T];
            
            if (![W1 isZero]) {
                M = [M add:W1];
                W1 = [self two:[_8T multiply:W1]];
            }
            
            X1 = [[M square] subtract:[self two:S]];
            Y1 = [[M multiply:[S subtract:X1]] subtract:_8T];
            Z1 = [Z1 isOne] ? _2Y1 : [_2Y1 multiply:Z1];
        }
        
        switch (coord) {
            case COORD_AFFINE: {
                ECFieldElement *zInv = [Z1 invert], *zInv2 = [zInv square], *zInv3 = [zInv2 multiply:zInv];
                retPoint = [[FpPoint alloc] initWithCurve:curve withX:[X1 multiply:zInv2] withY:[Y1 multiply:zInv3] withCompression:[self isCompressed]];
                break;
            }
            case COORD_HOMOGENEOUS: {
                X1 = [X1 multiply:Z1];
                Z1 = [Z1 multiply:[Z1 square]];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z1, nil];
                retPoint = [[FpPoint alloc] initWithCurve:curve withX:X1 withY:Y1 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            case COORD_JACOBIAN: {
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z1, nil];
                retPoint = [[FpPoint alloc] initWithCurve:curve withX:X1 withY:Y1 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            case COORD_JACOBIAN_MODIFIED: {
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z1, W1, nil];
                retPoint = [[FpPoint alloc] initWithCurve:curve withX:X1 withY:Y1 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
            }
        }
    jumpTo:;
    }
    
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECFieldElement*)two:(ECFieldElement*)x {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [x add:x];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)three:(ECFieldElement*)x {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [[self two:x] add:x];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)four:(ECFieldElement*)x {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [self two:[self two:x]];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)eight:(ECFieldElement*)x {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [self four:[self two:x]];
        [retVal retain];
    }
    return retVal;
}

- (ECFieldElement*)doubleProductFromSquares:(ECFieldElement*)a withB:(ECFieldElement*)b withAsquared:(ECFieldElement*)aSquared withBsquared:(ECFieldElement*)bSquared {
    /*
     * NOTE: If squaring in the field is faster than multiplication, then this is a quicker
     * way to calculate 2.A.B, if A^2 and B^2 are already known.
     */
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        retVal = [[[[a add:b] square] subtract:aSquared] subtract:bSquared];
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)negate {
    if ([self isInfinity]) {
        return self;
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *curve = [self curve];
        int coord = [curve coordinateSystem];
        
        if (COORD_AFFINE != coord) {
            retPoint = [[FpPoint alloc] initWithCurve:curve withX:[self rawXCoord] withY:[[self rawYCoord] negate] withZS:[self rawZCoords] withCompression:[self isCompressed]];
        } else {
            retPoint = [[FpPoint alloc] initWithCurve:curve withX:[self rawXCoord] withY:[[self rawYCoord] negate] withCompression:[self isCompressed]];
        }
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECFieldElement*)calculateJacobianModifiedW:(ECFieldElement*)Z withZsquared:(ECFieldElement*)ZSquared {
    ECFieldElement *a4 = [[self curve] a];
    if ([a4 isZero] || [Z isOne]) {
        return a4;
    }
    
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        if (ZSquared == nil) {
            ZSquared = [Z square];
        }
        
        ECFieldElement *W = [ZSquared square];
        ECFieldElement *a4Neg = [a4 negate];
        if ([a4Neg bitLength] < [a4 bitLength]) {
            W = [[W multiply:a4Neg] negate];
        } else {
            W = [W multiply:a4];
        }
        retVal = W;
        [retVal retain];
    }
    
    return (retVal ? [retVal autorelease] : nil);
}

- (ECFieldElement*)getJacobianModifiedW {
    // ZZ == ECFieldElement[]
    NSMutableArray *ZZ = [self rawZCoords];
    ECFieldElement *W = ZZ[1];
    if (W == nil) {
        // NOTE: Rarely, TwicePlus will result in the need for a lazy W1 calculation here
        ZZ[1] = W = [self calculateJacobianModifiedW:ZZ[0] withZsquared:nil];
    }
    return W;
}

- (FpPoint*)twiceJacobianModified:(BOOL)calculateW {
    FpPoint *retVal = nil;
    @autoreleasepool {
        ECFieldElement *X1 = [self rawXCoord], *Y1 = [self rawYCoord], *Z1 = [self rawZCoords][0], *W1 = [self getJacobianModifiedW];
        
        ECFieldElement *X1Squared = [X1 square];
        ECFieldElement *M = [[self three:X1Squared] add:W1];
        ECFieldElement *_2Y1 = [self two:Y1];
        ECFieldElement *_2Y1Squared = [_2Y1 multiply:Y1];
        ECFieldElement *S = [self two:[X1 multiply:_2Y1Squared]];
        ECFieldElement *X3 = [[M square] subtract:[self two:S]];
        ECFieldElement *_4T = [_2Y1Squared square];
        ECFieldElement *_8T = [self two:_4T];
        ECFieldElement *Y3 = [[M multiply:[S subtract:X3]] subtract:_8T];
        ECFieldElement *W3 = calculateW ? [self two:[_8T multiply:W1]] : nil;
        ECFieldElement *Z3 = [Z1 isOne] ? _2Y1 : [_2Y1 multiply:Z1];
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, W3, nil];
        retVal = [[FpPoint alloc] initWithCurve:[self curve] withX:X3 withY:Y3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end

@implementation AbstractF2mPoint

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withZS:zs withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)satisfiesCurveEquation {
    BOOL retVal = NO;
    @autoreleasepool {
        ECCurve *curve = [self curve];
        ECFieldElement *X = [self rawXCoord], *Y = [self rawYCoord], *A = [curve a], *B = [curve b];
        ECFieldElement *lhs, *rhs;
        
        int coord = [curve coordinateSystem];
        if (coord == COORD_LAMBDA_PROJECTIVE) {
            ECFieldElement *Z = [self rawZCoords][0];
            BOOL ZIsOne = [Z isOne];
            
            if ([X isZero]) {
                // NOTE: For x == 0, we expect the affine-y instead of the lambda-y
                lhs = [Y square];
                rhs = B;
                if (!ZIsOne) {
                    ECFieldElement *Z2 = [Z square];
                    rhs = [rhs multiply:Z2];
                }
            } else {
                ECFieldElement *L = Y, *X2 = [X square];
                if (ZIsOne) {
                    lhs = [[[L square] add:L] add:A];
                    rhs = [[X2 square] add:B];
                } else {
                    ECFieldElement *Z2 = [Z square], *Z4 = [Z2 square];
                    lhs = [[L add:Z] multiplyPlusProduct:L withX:A withY:Z2];
                    // TODO If sqrt(b) is precomputed this can be simplified to a single square
                    rhs = [X2 squarePlusProduct:B withY:Z4];
                }
                lhs = [lhs multiply:X2];
            }
        } else {
            lhs = [[Y add:X] multiply:Y];
            
            switch (coord) {
                case COORD_AFFINE: {
                    break;
                }
                case COORD_HOMOGENEOUS: {
                    ECFieldElement *Z = [self rawZCoords][0];
                    if (![Z isOne]) {
                        ECFieldElement *Z2 = [Z square], *Z3 = [Z multiply:Z2];
                        lhs = [lhs multiply:Z];
                        A = [A multiply:Z];
                        B = [B multiply:Z3];
                    }
                    break;
                }
                default: {
                    @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
                }
            }
            
            rhs = [[[X add:A] multiply:[X square]] add:B];
        }
        retVal = [lhs equalsWithOther:rhs];
    }
    return retVal;
}

- (ECPoint*)scaleX:(ECFieldElement*)scale {
    if ([self isInfinity]) {
        return self;
    }
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        switch ([self curveCoordinateSystem]) {
            case COORD_LAMBDA_AFFINE: {
                // Y is actually Lambda (X + Y/X) here
                ECFieldElement *X = [self rawXCoord], *L = [self rawYCoord];
                
                ECFieldElement *X2 = [X multiply:scale];
                ECFieldElement *L2 = [[[L add:X] divide:scale] add:X2];
                
                retPoint = [[self curve] createRawPoint:X withY:L2 withZS:[self rawZCoords] withCompression:[self isCompressed]];
                break;
            }
            case COORD_LAMBDA_PROJECTIVE: {
                // Y is actually Lambda (X + Y/X) here
                ECFieldElement *X = [self rawXCoord], *L = [self rawYCoord], *Z = [self rawZCoords][0];
                
                // We scale the Z coordinate also, to avoid an inversion
                ECFieldElement *X2 = [X multiply:[scale square]];
                ECFieldElement *L2 = [[L add:X] add:X2];
                ECFieldElement *Z2 = [Z multiply:scale];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z2, nil];
                retPoint = [[self curve] createRawPoint:X withY:L2 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            default: {
                retPoint = [super scaleX:scale];
                break;
            }
        }
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)scaleY:(ECFieldElement*)scale {
    if ([self isInfinity]) {
        return self;
    }
    
    ECPoint *retVal = nil;
    @autoreleasepool {
        switch ([self curveCoordinateSystem]) {
            case COORD_LAMBDA_AFFINE:
            case COORD_LAMBDA_PROJECTIVE: {
                ECFieldElement *X = [self rawXCoord], *L = [self rawYCoord];
                
                // Y is actually Lambda (X + Y/X) here
                ECFieldElement *L2 = [[[L add:X] multiply:scale] add:X];
                
                retVal = [[self curve] createRawPoint:X withY:L2 withZS:[self rawZCoords] withCompression:[self isCompressed]];
                break;
            }
            default: {
                retVal = [super scaleY:scale];
                break;
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPoint*)subtract:(ECPoint*)b {
    if ([b isInfinity]) {
        return self;
    }
    
    // Add -b
    ECPoint *retPoint = nil;
    @autoreleasepool {
        retPoint = [self add:[b negate]];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (AbstractF2mPoint*)tau {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    ECFieldElement *X1 = [self rawXCoord];
    
    AbstractF2mPoint *retVal = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_AFFINE:
            case COORD_LAMBDA_AFFINE: {
                ECFieldElement *Y1 = [self rawYCoord];
                retVal = (AbstractF2mPoint*)[curve createRawPoint:[X1 square] withY:[Y1 square] withCompression:[self isCompressed]];
                break;
            }
            case COORD_HOMOGENEOUS:
            case COORD_LAMBDA_PROJECTIVE: {
                ECFieldElement *Y1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:[Z1 square], nil];
                retVal = (AbstractF2mPoint*)[curve createRawPoint:[X1 square] withY:[Y1 square] withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (AbstractF2mPoint*)tauPow:(int)pow {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    ECFieldElement *X1 = [self rawXCoord];
    
    AbstractF2mPoint *retVal = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_AFFINE:
            case COORD_LAMBDA_AFFINE: {
                ECFieldElement *Y1 = [self rawYCoord];
                retVal = (AbstractF2mPoint*)[curve createRawPoint:[X1 squarePow:pow] withY:[Y1 squarePow:pow] withCompression:[self isCompressed]];
                break;
            }
            case COORD_HOMOGENEOUS:
            case COORD_LAMBDA_PROJECTIVE: {
                ECFieldElement *Y1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:[Z1 squarePow:pow], nil];
                retVal = (AbstractF2mPoint*)[curve createRawPoint:[X1 squarePow:pow] withY:[Y1 squarePow:pow] withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end

/**
 * Elliptic curve points over F2m
 */
@implementation F2mPoint

/**
 * @param curve base curve
 * @param x x point
 * @param y y point
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:NO]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * @param curve base curve
 * @param x x point
 * @param y y point
 * @param withCompression true if encode with point compression.
 */
- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withCompression:withCompression]) {
        if ((x == nil) != (y == nil)) {
            @throw [NSException exceptionWithName:@"new Argument" reason:@"Exactly one of the field elements is nil" userInfo:nil];
        }
        
        if (x != nil) {
            // Check if x and y are elements of the same field
            [F2mFieldElement checkFieldElements:x withB:y];
            
            // Check if x and a are elements of the same field
            if (curve != nil) {
                [F2mFieldElement checkFieldElements:x withB:[curve a]];
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withX:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    if (self = [super initWithCurve:curve withX:x withY:y withZS:zs withCompression:withCompression]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Constructor for point at infinity
 */
- (id)initWithCurve:(ECCurve*)curve {
    if (self = [self initWithCurve:curve withX:nil withY:nil]) {
        return self;
    } else {
        return nil;
    }
}

- (ECPoint*)detach {
    return [[[F2mPoint alloc] initWithCurve:nil withX:[self affineXCoord] withY:[self affineYCoord]] autorelease];
}

- (ECFieldElement*)yCoord {
    int coord = [self curveCoordinateSystem];
    
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_LAMBDA_AFFINE:
            case COORD_LAMBDA_PROJECTIVE: {
                ECFieldElement *X = [self rawXCoord], *L = [self rawYCoord];
                if ([self isInfinity] || [X isZero]) {
                    retVal = L;
                } else {
                    // Y is actually Lambda (X + Y/X) here; convert to affine value on the fly
                    ECFieldElement *Y = [[L add:X] multiply:X];
                    if (COORD_LAMBDA_PROJECTIVE == coord) {
                        ECFieldElement *Z = [self rawZCoords][0];
                        if (![Z isOne]) {
                            Y = [Y divide:Z];
                        }
                    }
                    retVal = Y;
                }
                break;
            }
            default: {
                retVal = [self rawYCoord];
                break;
            }
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (BOOL)compressionYTilde {
    BOOL retVal = NO;
    @autoreleasepool {
        ECFieldElement *X = [self rawXCoord];
        if ([X isZero]) {
            return NO;
        }
        
        ECFieldElement *Y = [self rawYCoord];
        
        switch ([self curveCoordinateSystem]) {
            case COORD_LAMBDA_AFFINE:
            case COORD_LAMBDA_PROJECTIVE: {
                // Y is actually Lambda (X + Y/X) here
                retVal = ([Y testBitZero] != [X testBitZero]);
                break;
            }
            default: {
                retVal = [[Y divide:X] testBitZero];
                break;
            }
        }
    }
    return retVal;
}

- (ECPoint*)add:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    ECFieldElement *X1 = [self rawXCoord];
    ECFieldElement *X2 = [b rawXCoord];
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_AFFINE: {
                ECFieldElement *Y1 = [self rawYCoord];
                ECFieldElement *Y2 = [b rawYCoord];
                
                ECFieldElement *dx = [X1 add:X2], *dy = [Y1 add:Y2];
                if ([dx isZero]) {
                    if ([dy isZero]) {
                        retPoint = [self twice];
                    } else {
                        retPoint = [curve infinity];
                    }
                    [retPoint retain];
                } else {
                    ECFieldElement *L = [dy divide:dx];
                    
                    ECFieldElement *X3 = [[[[L square] add:L] add:dx] add:[curve a]];
                    ECFieldElement *Y3 = [[[L multiply:[X1 add:X3]] add:X3] add:Y1];
                    
                    retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withCompression:[self isCompressed]];
                }
                break;
            }
            case COORD_HOMOGENEOUS: {
                ECFieldElement *Y1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                ECFieldElement *Y2 = [b rawYCoord], *Z2 = [b rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                ECFieldElement *U1 = Y2, *V1 = X2;
                if (!Z1IsOne) {
                    U1 = [U1 multiply:Z1];
                    V1 = [V1 multiply:Z1];
                }
                
                BOOL Z2IsOne = [Z2 isOne];
                ECFieldElement *U2 = Y1, *V2 = X1;
                if (!Z2IsOne) {
                    U2 = [U2 multiply:Z2];
                    V2 = [V2 multiply:Z2];
                }
                
                ECFieldElement *U = [U1 add:U2];
                ECFieldElement *V = [V1 add:V2];
                
                if ([V isZero]) {
                    if ([U isZero]) {
                        retPoint = [self twice];
                    } else {
                        retPoint = [curve infinity];
                    }
                    [retPoint retain];
                } else {
                    ECFieldElement *VSq = [V square];
                    ECFieldElement *VCu = [VSq multiply:V];
                    ECFieldElement *W = Z1IsOne ? Z2 : Z2IsOne ? Z1 : [Z1 multiply:Z2];
                    ECFieldElement *uv = [U add:V];
                    ECFieldElement *A = [[[uv multiplyPlusProduct:U withX:VSq withY:[curve a]] multiply:W] add:VCu];
                    
                    ECFieldElement *X3 = [V multiply:A];
                    ECFieldElement *VSqZ2 = Z2IsOne ? VSq : [VSq multiply:Z2];
                    ECFieldElement *Y3 = [[U multiplyPlusProduct:X1 withX:V withY:Y1] multiplyPlusProduct:VSqZ2 withX:uv withY:A];
                    ECFieldElement *Z3 = [VCu multiply:W];
                    
                    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                    retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                    if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                }
                break;
            }
            case COORD_LAMBDA_PROJECTIVE: {
                if ([X1 isZero]) {
                    if ([X2 isZero]) {
                        retPoint = [curve infinity];
                    } else {
                        retPoint = [b add:self];
                    }
                    [retPoint retain];
                } else {
                    ECFieldElement *L1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                    ECFieldElement *L2 = [b rawYCoord], *Z2 = [b rawZCoords][0];
                    
                    BOOL Z1IsOne = [Z1 isOne];
                    ECFieldElement *U2 = X2, *S2 = L2;
                    if (!Z1IsOne) {
                        U2 = [U2 multiply:Z1];
                        S2 = [S2 multiply:Z1];
                    }
                    
                    BOOL Z2IsOne = [Z2 isOne];
                    ECFieldElement *U1 = X1, *S1 = L1;
                    if (!Z2IsOne) {
                        U1 = [U1 multiply:Z2];
                        S1 = [S1 multiply:Z2];
                    }
                    
                    ECFieldElement *A = [S1 add:S2];
                    ECFieldElement *B = [U1 add:U2];
                    
                    if ([B isZero]) {
                        if ([A isZero]) {
                            retPoint = [self twice];
                        } else {
                            retPoint = [curve infinity];
                        }
                        [retPoint retain];
                    } else {
                        ECFieldElement *X3, *L3, *Z3;
                        if ([X2 isZero]) {
                            // TODO This can probably be optimized quite a bit
                            ECPoint *p = [self normalize];
                            X1 = [p rawXCoord];
                            ECFieldElement *Y1 = [p yCoord];
                            
                            ECFieldElement *Y2 = L2;
                            ECFieldElement *L = [[Y1 add:Y2] divide:X1];
                            
                            X3 = [[[[L square] add:L] add:X1] add:[curve a]];
                            if ([X3 isZero]) {
                                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:[[curve b] sqrt] withCompression:[self isCompressed]];
                                break;
                            }
                            
                            ECFieldElement *Y3 = [[[L multiply:[X1 add:X3]] add:X3] add:Y1];
                            L3 = [[Y3 divide:X3] add:X3];
                            Z3 = [curve fromBigInteger:[BigInteger One]];
                        } else {
                            B = [B square];
                            
                            ECFieldElement *AU1 = [A multiply:U1];
                            ECFieldElement *AU2 = [A multiply:U2];
                            
                            X3 = [AU1 multiply:AU2];
                            if ([X3 isZero]) {
                                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:[[curve b] sqrt] withCompression:[self isCompressed]];
                                break;
                            }
                            
                            ECFieldElement *ABZ2 = [A multiply:B];;
                            if (!Z2IsOne) {
                                ABZ2 = [ABZ2 multiply:Z2];
                            }
                            
                            L3 = [[AU2 add:B] squarePlusProduct:ABZ2 withY:[L1 add:Z1]];
                            
                            Z3 = ABZ2;
                            if (!Z1IsOne) {
                                Z3 = [Z3 multiply:Z1];
                            }
                        }
                        
                        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                        retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:L3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                    }
                }
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
            }
        }
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

/* (non-Javadoc)
 * @see Org.BouncyCastle.Math.EC.ECPoint#twice()
 */
- (ECPoint*)twice {
    if ([self isInfinity]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *X1 = [self rawXCoord];
    if ([X1 isZero]) {
        // A point with X == 0 is it's own additive inverse
        return [curve infinity];
    }
    
    int coord = [curve coordinateSystem];
    
    switch (coord) {
        case COORD_AFFINE: {
            ECPoint *retPoint = nil;
            @autoreleasepool {
                ECFieldElement *Y1 = [self rawYCoord];
                
                ECFieldElement *L1 = [[Y1 divide:X1] add:X1];
                
                ECFieldElement *X3 = [[[L1 square] add:L1] add:[curve a]];
                ECFieldElement *Y3 = [X1 squarePlusProduct:X3 withY:[L1 addOne]];
                
                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withCompression:[self isCompressed]];
            }
            return (retPoint ? [retPoint autorelease] : nil);
        }
        case COORD_HOMOGENEOUS: {
            ECPoint *retPoint = nil;
            @autoreleasepool {
                ECFieldElement *Y1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                ECFieldElement *X1Z1 = Z1IsOne ? X1 : [X1 multiply:Z1];
                ECFieldElement *Y1Z1 = Z1IsOne ? Y1 : [Y1 multiply:Z1];
                
                ECFieldElement *X1Sq = [X1 square];
                ECFieldElement *S = [X1Sq add:Y1Z1];
                ECFieldElement *V = X1Z1;
                ECFieldElement *vSquared = [V square];
                ECFieldElement *sv = [S add:V];
                ECFieldElement *h = [sv multiplyPlusProduct:S withX:vSquared withY:[curve a]];
                
                ECFieldElement *X3 = [V multiply:h];
                ECFieldElement *Y3 = [[X1Sq square] multiplyPlusProduct:V withX:h withY:sv];
                ECFieldElement *Z3 = [V multiply:vSquared];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:Y3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            }
            return (retPoint ? [retPoint autorelease] : nil);
        }
        case COORD_LAMBDA_PROJECTIVE: {
            ECPoint *retPoint = nil;
            @autoreleasepool {
                ECFieldElement *L1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                
                BOOL Z1IsOne = [Z1 isOne];
                ECFieldElement *L1Z1 = Z1IsOne ? L1 : [L1 multiply:Z1];
                ECFieldElement *Z1Sq = Z1IsOne ? Z1 : [Z1 square];
                ECFieldElement *a = [curve a];
                ECFieldElement *aZ1Sq = Z1IsOne ? a : [a multiply:Z1Sq];
                ECFieldElement *T = [[[L1 square] add:L1Z1] add:aZ1Sq];
                if ([T isZero]) {
                    retPoint = [[F2mPoint alloc] initWithCurve:curve withX:T withY:[[curve b] sqrt] withCompression:[self isCompressed]];
                } else {
                    ECFieldElement *X3 = [T square];
                    ECFieldElement *Z3 = Z1IsOne ? T : [T multiply:Z1Sq];
                    
                    ECFieldElement *b = [curve b];
                    ECFieldElement *L3;
                    if ([b bitLength] < ([curve fieldSize] >> 1)) {
                        ECFieldElement *t1 = [[L1 add:X1] square];
                        ECFieldElement *t2;
                        if ([b isOne]) {
                            t2 = [[aZ1Sq add:Z1Sq] square];
                        } else {
                            // TODO Can be calculated with one square if we pre-compute sqrt(b)
                            t2 = [aZ1Sq squarePlusProduct:b withY:[Z1Sq square]];
                        }
                        L3 = [[[[[t1 add:T] add:Z1Sq] multiply:t1] add:t2] add:X3];
                        if ([a isZero]) {
                            L3 = [L3 add:Z3];
                        } else if (![a isOne]) {
                            L3 = [L3 add:[[a addOne] multiply:Z3]];
                        }
                    } else {
                        ECFieldElement *X1Z1 = Z1IsOne ? X1 : [X1 multiply:Z1];
                        L3 = [[[X1Z1 squarePlusProduct:T withY:L1Z1] add:X3] add:Z3];
                    }
                    
                    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                    retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X3 withY:L3 withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                    if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                }
            }
            return (retPoint ? [retPoint autorelease] : nil);
        }
        default: {
            @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
        }
    }
}

- (ECPoint*)twicePlus:(ECPoint*)b {
    if ([self isInfinity]) {
        return b;
    }
    if ([b isInfinity]) {
        return [self twice];
    }
    
    ECCurve *curve = [self curve];
    
    ECFieldElement *X1 = [self rawXCoord];
    if ([X1 isZero]) {
        // A point with X == 0 is it's own additive inverse
        return b;
    }
    
    int coord = [curve coordinateSystem];
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_LAMBDA_PROJECTIVE: {
                // NOTE: twicePlus() only optimized for lambda-affine argument
                ECFieldElement *X2 = [b rawXCoord], *Z2 = [b rawZCoords][0];
                if ([X2 isZero] || ![Z2 isOne]) {
                    retPoint = [[self twice] add:b];
                    break;
                }
                
                ECFieldElement *L1 = [self rawYCoord], *Z1 = [self rawZCoords][0];
                ECFieldElement *L2 = [b rawYCoord];
                
                ECFieldElement *X1Sq = [X1 square];
                ECFieldElement *L1Sq = [L1 square];
                ECFieldElement *Z1Sq = [Z1 square];
                ECFieldElement *L1Z1 = [L1 multiply:Z1];
                
                ECFieldElement *T = [[[[curve a] multiply:Z1Sq] add:L1Sq] add:L1Z1];
                ECFieldElement *L2plus1 = [L2 addOne];
                ECFieldElement *A = [[[[[curve a] add:L2plus1] multiply:Z1Sq] add:L1Sq] multiplyPlusProduct:T withX:X1Sq withY:Z1Sq];
                ECFieldElement *X2Z1Sq = [X2 multiply:Z1Sq];
                ECFieldElement *B = [[X2Z1Sq add:T] square];
                
                if ([B isZero]) {
                    if ([A isZero]) {
                        retPoint = [b twice];
                        break;
                    } else {
                        retPoint = [curve infinity];
                        break;
                    }
                }
                
                if ([A isZero]) {
                    retPoint = [[[F2mPoint alloc] initWithCurve:curve withX:A withY:[[curve b] sqrt] withCompression:[self isCompressed]] autorelease];
                    break;
                }
                
                ECFieldElement *X3 = [[A square] multiply:X2Z1Sq];
                ECFieldElement *Z3 = [[A multiply:B] multiply:Z1Sq];
                ECFieldElement *L3 = [[[A add:B] square] multiplyPlusProduct:T withX:L2plus1 withY:Z3];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z3, nil];
                retPoint = [[[F2mPoint alloc] initWithCurve:curve withX:X3 withY:L3 withZS:tmpArray withCompression:[self isCompressed]] autorelease];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            default: {
                retPoint = [[self twice] add:b];
                break;
            }
        }
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)negate {
    if ([self isInfinity]) {
        return self;
    }
    
    ECFieldElement *X = [self rawXCoord];
    if ([X isZero]) {
        return self;
    }
    
    ECCurve *curve = [self curve];
    int coord = [curve coordinateSystem];
    
    ECPoint *retPoint = nil;
    @autoreleasepool {
        switch (coord) {
            case COORD_AFFINE: {
                ECFieldElement *Y = [self rawYCoord];
                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X withY:[Y add:X] withCompression:[self isCompressed]];
                break;
            }
            case COORD_HOMOGENEOUS: {
                ECFieldElement *Y = [self rawYCoord], *Z = [self rawZCoords][0];
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z, nil];
                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X withY:[Y add:X] withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            case COORD_LAMBDA_AFFINE: {
                ECFieldElement *L = [self rawYCoord];
                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X withY:[L addOne] withCompression:[self isCompressed]];
                break;
            }
            case COORD_LAMBDA_PROJECTIVE: {
                // L is actually Lambda (X + Y/X) here
                ECFieldElement *L = [self rawYCoord], *Z = [self rawZCoords][0];
                NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:Z, nil];
                retPoint = [[F2mPoint alloc] initWithCurve:curve withX:X withY:[L add:Z] withZS:tmpArray withCompression:[self isCompressed]];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
            }
        }
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
