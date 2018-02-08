//
//  ECCurve.m
//  
//
//  Created by Pallas on 5/5/16.
//
//  Complete

#import "ECCurve.h"
#import "CategoryExtend.h"
#import "ECPoint.h"
#import "BigInteger.h"
#import "IFiniteField.h"
#import "ECFieldElement.h"
#import "ECEndomorphism.h"
#import "ECMultiplier.h"
#import "GlvEndomorphism.h"
#import "GlvMultiplier.h"
#import "WNafL2RMultiplier.h"
#import "FiniteFields.h"
#import "ECAlgorithms.h"
#import "LongArray.h"
#import "Tnaf.h"
#import "WTauNafMultiplier.h"

@implementation ECCurve
@synthesize m_field = _m_field;
@synthesize m_a = _m_a;
@synthesize m_b = _m_b;
@synthesize m_order = _m_order;
@synthesize m_cofactor = _m_cofactor;
@synthesize m_coord = _m_coord;
@synthesize m_endomorphism = _m_endomorphism;
@synthesize m_multiplier = _m_multiplier;

+ (NSMutableArray*)GetAllCoordinateSystems {
    static NSMutableArray *_allCoordinateSystems = nil;
    @synchronized(self) {
        @autoreleasepool {
            if (_allCoordinateSystems == nil) {
                _allCoordinateSystems = [[NSMutableArray alloc] initWithObjects:@(COORD_AFFINE), @(COORD_HOMOGENEOUS), @(COORD_JACOBIAN), @(COORD_JACOBIAN_CHUDNOVSKY),
                                         @(COORD_JACOBIAN_MODIFIED), @(COORD_LAMBDA_AFFINE), @(COORD_LAMBDA_PROJECTIVE), @(COORD_SKEWED), nil];
            }
        }
    }
    return _allCoordinateSystems;
}

- (id)initWithField:(IFiniteField*)field {
    if (self = [super init]) {
        [self setM_coord:COORD_AFFINE];
        [self setM_field:field];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_field:nil];
    [self setM_a:nil];
    [self setM_b:nil];
    [self setM_order:nil];
    [self setM_cofactor:nil];
    [self setM_endomorphism:nil];
    [self setM_multiplier:nil];
    [super dealloc];
#endif
}

- (int)fieldSize {
    return 0;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return nil;
}

- (BOOL)isValidFieldElement:(BigInteger*)x {
    return NO;
}

- (Config*)configure {
    return [[[Config alloc] initWithOuter:self withCoord:self.m_coord withEndomorphism:self.m_endomorphism withMultiplier:self.m_multiplier] autorelease];
}

- (ECPoint*)validatePoint:(BigInteger*)x withY:(BigInteger*)y {
    ECPoint *p = [self createPoint:x withY:y];
    if (![p isValid]) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Invalid point coordinates" userInfo:nil];
    }
    return p;
}

- (ECPoint*)validatePoint:(BigInteger*)x withY:(BigInteger *)y withCompression:(BOOL)withCompression {
    ECPoint *p = [self createPoint:x withY:y withCompression:withCompression];
    if (![p isValid]) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"Invalid point coordinates" userInfo:nil];
    }
    return p;

}

- (ECPoint*)createPoint:(BigInteger*)x withY:(BigInteger*)y {
    return [self createPoint:x withY:y withCompression:NO];
}

- (ECPoint*)createPoint:(BigInteger *)x withY:(BigInteger *)y withCompression:(BOOL)withCompression {
     return [self createRawPoint:[self fromBigInteger:x] withY:[self fromBigInteger:y] withCompression:withCompression];
}

- (ECCurve*)cloneCurve {
    return nil;
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return nil;
}

// NSMutableArray == ECFieldElement[]
- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement *)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return nil;
}

- (ECMultiplier*)createDefaultMultiplier {
    if (self.m_endomorphism != nil && [self.m_endomorphism isKindOfClass:[GlvEndomorphism class]]) {
        return [[[GlvMultiplier alloc] initWithCurve:self withGlvEndomorphism:(GlvEndomorphism*)(self.m_endomorphism)] autorelease];
    } else {
        return [[[WNafL2RMultiplier alloc] init] autorelease];
    }
}

- (BOOL)supportsCoordinateSystem:(int)coord {
    return coord == COORD_AFFINE;
}

- (PreCompInfo*)getPreCompInfo:(ECPoint*)point withName:(NSString*)name {
    [self checkPoint:point];
    @synchronized(point) {
        NSMutableDictionary *table= [point m_preCompTable];
        return table == nil ? nil : (PreCompInfo*)[table objectForKey:name];
    }
}

/**
 * Adds <code>PreCompInfo</code> for a point on this curve, under a given name. Used by
 * <code>ECMultiplier</code>s to save the precomputation for this <code>ECPoint</code> for use
 * by subsequent multiplication.
 *
 * @param point
 *            The <code>ECPoint</code> to store precomputations for.
 * @param name
 *            A <code>String</code> used to index precomputations of different types.
 * @param preCompInfo
 *            The values precomputed by the <code>ECMultiplier</code>.
 */
- (void)setPreCompInfo:(ECPoint*)point withName:(NSString*)name withPreCompInfo:(PreCompInfo*)preCompInfo {
    [self checkPoint:point];
    @synchronized(point) {
        NSMutableDictionary *table = [point m_preCompTable];
        if (nil == table) {
            table = [[NSMutableDictionary alloc] init];
            [point setM_preCompTable:table];
#if !__has_feature(objc_arc)
            if (table != nil) [table release]; table = nil;
#endif
            table = [point m_preCompTable];
        }
        [table setObject:preCompInfo forKey:name];
    }
}

- (ECPoint*)importPoint:(ECPoint*)p {
    if (self == [p curve]) {
        return p;
    }
    if ([p isInfinity]) {
        return [self infinity];
    }
    
    // TODO Default behaviour could be improved if the two curves have the same coordinate system by copying any Z coordinates.
    p = [p normalize];
    
    return [self validatePoint:[[p xCoord] toBigInteger] withY:[[p yCoord] toBigInteger] withCompression:[p isCompressed]];
}

/**
 * Normalization ensures that any projective coordinate is 1, and therefore that the x, y
 * coordinates reflect those of the equivalent point in an affine coordinate system. Where more
 * than one point is to be normalized, this method will generally be more efficient than
 * normalizing each point separately.
 *
 * @param points
 *            An array of points that will be updated in place with their normalized versions,
 *            where necessary
 */
- (void)normalizeAll:(NSMutableArray*)points {
    [self normalizeAll:points withOff:0 withLen:(int)(points.count) withIso:nil];
}

/**
 * Normalization ensures that any projective coordinate is 1, and therefore that the x, y
 * coordinates reflect those of the equivalent point in an affine coordinate system. Where more
 * than one point is to be normalized, this method will generally be more efficient than
 * normalizing each point separately. An (optional) z-scaling factor can be applied; effectively
 * each z coordinate is scaled by this value prior to normalization (but only one
 * actual multiplication is needed).
 *
 * @param points
 *            An array of points that will be updated in place with their normalized versions,
 *            where necessary
 * @param off
 *            The start of the range of points to normalize
 * @param len
 *            The length of the range of points to normalize
 * @param iso
 *            The (optional) z-scaling factor - can be null
 */
- (void)normalizeAll:(NSMutableArray*)points withOff:(int)off withLen:(int)len withIso:(ECFieldElement*)iso {
    @autoreleasepool {
        [self checkPoints:points withOff:off withLen:len];
        
        switch ([self coordinateSystem]) {
            case COORD_AFFINE:
            case COORD_LAMBDA_AFFINE: {
                if (iso != nil) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"iso not valid for affine coordinates" userInfo:nil];
                }
                
                return;
            }
        }
        
        /*
         * Figure out which of the points actually need to be normalized
         */
        // zs == ECFieldElement[]
        NSMutableArray *zs = [[NSMutableArray alloc] initWithSize:len];
        // indices = int[]
        NSMutableArray *indices = [[NSMutableArray alloc] initWithSize:len];
        int count = 0;
        for (int i = 0; i < len; ++i) {
            ECPoint *p = points[off + i];
            if (nil != p && (iso != nil || ![p isNormalized])) {
                zs[count] = [p getZCoord:0];
                indices[count++] = @(off + i);
            }
        }
        
        if (count == 0) {
#if !__has_feature(objc_arc)
            if (zs != nil) [zs release]; zs = nil;
            if (indices != nil) [indices release]; indices = nil;
#endif
            return;
        }
        
        [ECAlgorithms montgomeryTrick:zs withOff:0 withLen:count withScale:iso];
        
        for (int j = 0; j < count; ++j) {
            int index = [indices[j] intValue];
            points[index] = [points[index] normalize:zs[j]];
        }
#if !__has_feature(objc_arc)
        if (zs != nil) [zs release]; zs = nil;
        if (indices != nil) [indices release]; indices = nil;
#endif
    }
}

- (ECPoint*)infinity {
    return nil;
}

- (IFiniteField*)field {
    return self.m_field;
}

- (ECFieldElement*)a {
    return self.m_a;
}

- (ECFieldElement*)b {
    return self.m_b;
}

- (BigInteger*)order {
    return self.m_order;
}

- (BigInteger*)cofactor {
    return self.m_cofactor;
}

- (int)coordinateSystem {
    return self.m_coord;
}

- (void)checkPoint:(ECPoint*)point {
    if (nil == point || (self != [point curve])) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"point must be non-null and on this curve" userInfo:nil];
    }
}

// NSMutableArray == ECPoint[]
- (void)checkPoints:(NSMutableArray*)points {
    [self checkPoints:points withOff:0 withLen:(int)(points.count)];
}

// NSMutableArray == ECPoint[]
- (void)checkPoints:(NSMutableArray*)points withOff:(int)off withLen:(int)len {
    if (points == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"points" userInfo:nil];
    }
    if (off < 0 || len < 0 || (off > (points.count - len))) {
        @throw [NSException exceptionWithName:@"Argumen" reason:@"points invalid range specified" userInfo:nil];
    }
    
    for (int i = 0; i < len; ++i) {
        ECPoint *point = points[off + i];
        if (nil != point && self != [point curve]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"points entries must be null or on this curve" userInfo:nil];
        }
    }
}

- (BOOL)equalsWithOther:(ECCurve*)other {
    if (self == other) {
        return YES;
    }
    if (nil == other) {
        return NO;
    }
    return [[self field] isEqualTo:[other field]] && [[[self a] toBigInteger] isEqual:[[other a] toBigInteger]] && [[[self b] toBigInteger] isEqual:[[other b] toBigInteger]];
}

- (BOOL)isEqual:(id)object {
    ECCurve *tmpCurve = (ECCurve*)object;
    if (object == nil) {
        return NO;
    }
    return [self equalsWithOther:tmpCurve];
}

- (ECPoint*)decompressPoint:(int)yTilde withX1:(BigInteger*)x1 {
    return nil;
}

- (ECEndomorphism*)getEndomorphism {
    return self.m_endomorphism;
}

/**
 * Sets the default <code>ECMultiplier</code>, unless already set.
 */
- (ECMultiplier*)getMultiplier {
    @synchronized(self) {
        if (self.m_multiplier == nil) {
            [self setM_multiplier:[self createDefaultMultiplier]];
        }
        return [self m_multiplier];
    }
}

/**
 * Decode a point on this curve from its ASN.1 encoding. The different
 * encodings are taken account of, including point compression for
 * <code>F<sub>p</sub></code> (X9.62 s 4.2.1 pg 17).
 * @return The decoded point.
 */
- (ECPoint*)decodePoint:(NSMutableData*)encoded {
    ECPoint *p = nil;
    @autoreleasepool {
        int expectedLength = ([self fieldSize] + 7) / 8;
        
        Byte type = ((Byte*)(encoded.bytes))[0];
        switch (type) {
            case 0x00: { // infinity
                if ([encoded length] != 1) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"incorrect length for infinity encoding" userInfo:nil];
                }
                
                p = [self infinity];
                break;
            }
            case 0x02: // compressed
            case 0x03: { // compressed
                if (encoded.length != (expectedLength + 1)) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"Incorrect length for compressed encoding" userInfo:nil];
                }
                
                int yTilde = type & 1;
                BigInteger *X = [[BigInteger alloc] initWithSign:1 withBytes:encoded withOffset:1 withLength:expectedLength];
                
                p = [self decompressPoint:yTilde withX1:X];
#if !__has_feature(objc_arc)
                if (X != nil) [X release]; X = nil;
#endif
                
                if (![p satisfiesCofactor]) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"Invalid point" userInfo:nil];
                }
                
                break;
            }
            case 0x04: { // uncompressed
                if (encoded.length != (2 * expectedLength + 1)) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"Incorrect length for uncompressed encoding" userInfo:nil];
                }
                
                BigInteger *X = [[BigInteger alloc] initWithSign:1 withBytes:encoded withOffset:1 withLength:expectedLength];
                BigInteger *Y = [[BigInteger alloc] initWithSign:1 withBytes:encoded withOffset:(1 + expectedLength) withLength:expectedLength];
                
                p = [self validatePoint:X withY:Y];
                
#if !__has_feature(objc_arc)
                if (X != nil) [X release]; X = nil;
                if (Y != nil) [Y release]; Y = nil;
#endif
                break;
            }
            case 0x06: // hybrid
            case 0x07: { // hybrid
                if (encoded.length != (2 * expectedLength + 1)) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"Incorrect length for hybrid encoding" userInfo:nil];
                }
                
                BigInteger *X = [[BigInteger alloc] initWithSign:1 withBytes:encoded withOffset:1 withLength:expectedLength];
                BigInteger *Y = [[BigInteger alloc] initWithSign:1 withBytes:encoded withOffset:(1 + expectedLength) withLength:expectedLength];
                
                if ([Y testBitWithN:0] != (type == 0x07)) {
                    @throw [NSException exceptionWithName:@"Argument" reason:@"Inconsistent Y coordinate in hybrid encoding" userInfo:nil];
                }
                
                p = [self validatePoint:X withY:Y];
#if !__has_feature(objc_arc)
                if (X != nil) [X release]; X = nil;
                if (Y != nil) [Y release]; Y = nil;
#endif
                break;
            }
            default: {
                @throw [NSException exceptionWithName:@"Format" reason:@"Invalid point encoding" userInfo:nil];
            }
        }
        
        if (type != 0x00 && [p isInfinity]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Invalid infinity encoding" userInfo:nil];
        }
        [p retain];
    }
    return (p ? [p autorelease] : nil);
}

@end

@interface Config ()

@property (nonatomic, readwrite, retain) ECCurve *outer;
@property (nonatomic, readwrite, assign) int coord;
@property (nonatomic, readwrite, retain) ECEndomorphism *endomorphism;
@property (nonatomic, readwrite, retain) ECMultiplier *multiplier;

@end

@implementation Config
@synthesize outer = _outer;
@synthesize coord = _coord;
@synthesize endomorphism = _endomorphism;
@synthesize multiplier = _multiplier;

- (id)initWithOuter:(ECCurve*)outer_ withCoord:(int)coord_ withEndomorphism:(ECEndomorphism*)endomorphism_ withMultiplier:(ECMultiplier*)multiplier_ {
    if (self = [super init]) {
        [self setOuter:outer_];
        [self setCoord:coord_];
        [self setEndomorphism:endomorphism_];
        [self setMultiplier:multiplier_];
        return self;
    } else {
        return nil;
    }
}


- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setOuter:nil];
    [self setEndomorphism:nil];
    [self setMultiplier:nil];
    [super dealloc];
#endif
}

- (Config*)setCoordinateSystemWithCoord:(int)coord_ {
    [self setCoord:coord_];
    return self;
}

- (Config*)setEndomorphismWithEndomorphism:(ECEndomorphism*)endomorphism_ {
    [self setEndomorphism:endomorphism_];
    return self;
}

- (Config*)setMultiplierWithMultiplier:(ECMultiplier*)multiplier_ {
    [self setMultiplier:multiplier_];
    return self;
}

- (ECCurve*)create {
    if (![[self outer] supportsCoordinateSystem:[self coord]]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"unsupported coordinate system" userInfo:nil];
    }
    
    ECCurve *c = [[self outer] cloneCurve];
    if (c == [self outer]) {
        @throw [NSException exceptionWithName:@"InvalidOperation" reason:@"implementation returned current curve" userInfo:nil];
    }
    
    [c setM_coord:self.coord];
    [c setM_endomorphism:self.endomorphism];
    [c setM_multiplier:self.multiplier];
    
    return c;
}

@end

@implementation AbstractFpCurve

- (id)initWithQ:(BigInteger*)q {
    if (self = [super initWithField:[FiniteFields getPrimeField:q]]) {
        return self;
    } else {
        return nil;
    }
}

- (BOOL)isValidFieldElement:(BigInteger*)x {
    return x != nil && [x signValue] >= 0 && [x compareToWithValue:[[self field] characteristic]] < 0;
}

- (ECPoint *)decompressPoint:(int)yTilde withX1:(BigInteger *)x1 {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECFieldElement *x = [self fromBigInteger:x1];
        ECFieldElement *rhs = [[[[x square] add:[self a]] multiply:x] add:[self b]];
        ECFieldElement *y = [rhs sqrt];
        
        /*
         * If y is not a square, then we haven't got a point on the curve
         */
        if (y == nil) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Invalid point compression" userInfo:nil];
        }
        
        if ([y testBitZero] != (yTilde == 1)) {
            // Use the other root
            y = [y negate];
        }
        
        retPoint = [self createRawPoint:x withY:y withCompression:YES];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end

int const FP_DEFAULT_COORDS = COORD_JACOBIAN_MODIFIED;

@interface FpCurve ()

@property (nonatomic, readwrite, retain) BigInteger *m_q;
@property (nonatomic, readwrite, retain) BigInteger *m_r;
@property (nonatomic, readwrite, retain) FpPoint *m_infinity;

@end

@implementation FpCurve
@synthesize m_q = _m_q;
@synthesize m_r = _m_r;
@synthesize m_infinity = _m_infinity;

- (id)initWithQ:(BigInteger*)q withA:(BigInteger*)a withB:(BigInteger*)b {
    if (self = [self initWithQ:q withA:a withB:b withOrder:nil withCofactor:nil]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithQ:(BigInteger*)q withA:(BigInteger*)a withB:(BigInteger*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor {
    if (self = [super initWithQ:q]) {
        @autoreleasepool {
            [self setM_q:q];
            [self setM_r:[FpFieldElement calculateResidue:q]];
            FpPoint *p = [[FpPoint alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:p];
#if !__has_feature(objc_arc)
            if (p) [p release]; p = nil;
#endif
            [self setM_a:[self fromBigInteger:a]];
            [self setM_b:[self fromBigInteger:b]];
            [self setM_order:order];
            [self setM_cofactor:cofactor];
            [self setM_coord:FP_DEFAULT_COORDS];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithQ:(BigInteger*)q withR:(BigInteger*)r withA:(ECFieldElement*)a withB:(ECFieldElement*)b {
    if (self = [self initWithQ:q withR:r withA:a withB:b withOrder:nil withCofactor:nil]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithQ:(BigInteger*)q withR:(BigInteger*)r withA:(ECFieldElement*)a withB:(ECFieldElement*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor {
    if (self = [super initWithQ:q]) {
        [self setM_q:q];
        [self setM_r:r];
        FpPoint *p = [[FpPoint alloc] initWithCurve:self withX:nil withY:nil];
        [self setM_infinity:p];
#if !__has_feature(objc_arc)
        if (p) [p release]; p = nil;
#endif
        
        [self setM_a:a];
        [self setM_b:b];
        [self setM_order:order];
        [self setM_cofactor:cofactor];
        [self setM_coord:FP_DEFAULT_COORDS];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_q:nil];
    [self setM_r:nil];
    [self setM_infinity:nil];
    [super dealloc];
#endif
}

- (ECCurve*)cloneCurve {
    return [[[FpCurve alloc] initWithQ:self.m_q withR:self.m_r withA:self.m_a withB:self.m_b withOrder:self.m_order withCofactor:self.m_cofactor] autorelease];
}

- (BOOL)supportsCoordinateSystem:(int)coord {
    switch (coord) {
        case COORD_AFFINE:
        case COORD_HOMOGENEOUS:
        case COORD_JACOBIAN:
        case COORD_JACOBIAN_MODIFIED: {
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (BigInteger*)Q {
    return self.m_q;
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return [self.m_q bitLength];
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[FpFieldElement alloc] initWithQ:self.m_q withR:self.m_r withX:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[FpPoint alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[FpPoint alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (ECPoint*)importPoint:(ECPoint*)p {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        if (self != [p curve] && [self coordinateSystem] == COORD_JACOBIAN && ![p isInfinity]) {
            switch ([[p curve] coordinateSystem]) {
                case COORD_JACOBIAN:
                case COORD_JACOBIAN_CHUDNOVSKY:
                case COORD_JACOBIAN_MODIFIED: {
                    NSMutableArray *tmpzs = [[NSMutableArray alloc] initWithObjects:[self fromBigInteger:[[p getZCoord:0] toBigInteger]], nil];
                    retPoint = [[FpPoint alloc] initWithCurve:self withX:[self fromBigInteger:[[p rawXCoord] toBigInteger]] withY:[self fromBigInteger:[[p rawYCoord] toBigInteger]] withZS:tmpzs withCompression:[p isCompressed]];
#if !__has_feature(objc_arc)
                    if (tmpzs != nil) [tmpzs release]; tmpzs = nil;
#endif
                    break;
                }
                default: {
                    retPoint = [super importPoint:p];
                    [retPoint retain];
                    break;
                }
            }
        } else {
            retPoint = [super importPoint:p];
            [retPoint retain];
        }
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end

@interface AbstractF2mCurve ()

@property (nonatomic, readwrite, retain) NSMutableArray *si;

@end

@implementation AbstractF2mCurve
@synthesize si = _si;

// ks = int[]
+ (BigInteger*)inverse:(int)m withKs:(NSMutableArray*)ks withX:(BigInteger*)x {
    BigInteger *retVal = nil;
    @autoreleasepool {
        LongArray *la =  [[LongArray alloc] initWithBigInt:x];
        if (la != nil) {
            retVal = [[la modInverse:m withKs:ks] toBigInteger];
            [retVal retain];
#if !__has_feature(objc_arc)
            [la release]; la = nil;
#endif
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

+ (IFiniteField*)buildField:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 {
    if (k1 == 0) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"k1 must be > 0" userInfo:nil];
    }
    
    IFiniteField *retVal = nil;
    @autoreleasepool {
        if (k2 == 0) {
            if (k3 != 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"k3 must be 0 if k2 == 0" userInfo:nil];
            }
            
            NSMutableArray *exponents = [[NSMutableArray alloc] initWithObjects:@((int)0), @(k1), @(m), nil];
            retVal = (IFiniteField*)[FiniteFields getBinaryExtensionField:exponents];
#if !__has_feature(objc_arc)
            if (exponents != nil) [exponents release]; exponents = nil;
#endif
        } else {
            if (k2 <= k1) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"k2 must be > k1" userInfo:nil];
            }
            
            if (k3 <= k2) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"k3 must be > k2" userInfo:nil];
            }
            
            NSMutableArray *exponents = [[NSMutableArray alloc] initWithObjects:@((int)0), @(k1), @(k2), @(k3), @(m), nil];
            retVal = (IFiniteField*)[FiniteFields getBinaryExtensionField:exponents];
#if !__has_feature(objc_arc)
            if (exponents != nil) [exponents release]; exponents = nil;
#endif
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 {
    if (self = [super initWithField:[AbstractF2mCurve buildField:m withK1:k1 withK2:k2 withK3:k3]]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setSi:nil];
    [super dealloc];
#endif
}

- (BOOL)isValidFieldElement:(BigInteger*)x {
    return x != nil && [x signValue] >= 0 && [x bitLength] <= [self fieldSize];
}

- (ECPoint*)createPoint:(BigInteger*)x withY:(BigInteger*)y withCompression:(BOOL)withCompression {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECFieldElement *X = [self fromBigInteger:x], *Y = [self fromBigInteger:y];
        
        switch ([self coordinateSystem]) {
            case COORD_LAMBDA_AFFINE:
            case COORD_LAMBDA_PROJECTIVE: {
                if ([X isZero]) {
                    if (![[Y square] equalsWithOther:[self b]]) {
                        @throw [NSException exceptionWithName:@"Argument" reason:nil userInfo:nil];
                    }
                } else {
                    // Y becomes Lambda (X + Y/X) here
                    Y = [[Y divide:X] add:X];
                }
                break;
            }
            default: {
                break;
            }
        }
        
        retPoint = [self createRawPoint:X withY:Y withCompression:withCompression];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECPoint*)decompressPoint:(int)yTilde withX1:(BigInteger*)x1 {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECFieldElement *xp = [self fromBigInteger:x1], *yp = nil;
        if ([xp isZero]) {
            yp = [[self b] sqrt];
        } else {
            ECFieldElement *beta = [[[[[xp square] invert] multiply:[self b]] add:[self a]] add:xp];
            ECFieldElement *z = [self solveQuadradicEquation:beta];
            
            if (z != nil) {
                if ([z testBitZero] != (yTilde == 1)) {
                    z = [z addOne];
                }
                
                switch ([self coordinateSystem]) {
                    case COORD_LAMBDA_AFFINE:
                    case COORD_LAMBDA_PROJECTIVE: {
                        yp = [z add:xp];
                        break;
                    }
                    default: {
                        yp = [z multiply:xp];
                        break;
                    }
                }
            }
        }
        
        if (yp == nil) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Invalid point compression" userInfo:nil];
        }
        
        retPoint = [self createRawPoint:xp withY:yp withCompression:YES];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

/**
 * Solves a quadratic equation <code>z<sup>2</sup> + z = beta</code>(X9.62
 * D.1.6) The other solution is <code>z + 1</code>.
 *
 * @param beta
 *            The value to solve the qradratic equation for.
 * @return the solution for <code>z<sup>2</sup> + z = beta</code> or
 *         <code>null</code> if no solution exists.
 */
- (ECFieldElement*)solveQuadradicEquation:(ECFieldElement*)beta {
    ECFieldElement *retVal = nil;
    @autoreleasepool {
        if ([beta isZero]) {
            retVal = beta;
        } else {
            ECFieldElement *gamma, *z, *zeroElement = [self fromBigInteger:[BigInteger Zero]];
            
            int m = [self fieldSize];
            do {
                ECFieldElement *t = [self fromBigInteger:[BigInteger arbitrary:m]];
                z = zeroElement;
                ECFieldElement *w = beta;
                for (int i = 1; i < m; i++) {
                    ECFieldElement *w2 = [w square];
                    z = [[z square] add:[w2 multiply:t]];
                    w = [w2 add:beta];
                }
                if (![w isZero]) {
                    return nil;
                }
                gamma = [[z square] add:z];
            } while ([gamma isZero]);
            
            retVal = z;
        }
        [retVal retain];
    }
    return (retVal ? [retVal autorelease] : nil);
}

/**
 * @return the auxiliary values <code>s<sub>0</sub></code> and
 * <code>s<sub>1</sub></code> used for partial modular reduction for
 * Koblitz curves.
 */
// return == BigInteger[]
- (NSMutableArray*)getSi {
    if (self.si == nil) {
        @synchronized (self) {
            if (self.si == nil) {
                [self setSi:[Tnaf getSi:self]];
            }
        }
    }
    return self.si;
}

/**
 * Returns true if this is a Koblitz curve (ABC curve).
 * @return true if this is a Koblitz curve (ABC curve), false otherwise
 */
- (BOOL)isKoblitz {
    return self.m_order != nil && self.m_cofactor != nil && [self.m_b isOne] && ([self.m_a isZero] || [self.m_a isOne]);
}

@end

int const F2M_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

@interface F2mCurve ()

@property (nonatomic, readwrite, assign) int m;
@property (nonatomic, readwrite, assign) int k1;
@property (nonatomic, readwrite, assign) int k2;
@property (nonatomic, readwrite, assign) int k3;
@property (nonatomic, readwrite, retain) F2mPoint *m_infinity;

@end

@implementation F2mCurve
@synthesize m = _m;
@synthesize k1 = _k1;
@synthesize k2 = _k2;
@synthesize k3 = _k3;
@synthesize m_infinity = _m_infinity;

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
- (id)initWithM:(int)m withK:(int)k withA:(BigInteger*)a withB:(BigInteger*)b {
    if (self = [self initWithM:m withK1:k withK2:0 withK3:0 withA:a withB:b withOrder:nil withCofactor:nil]) {
        return self;
    } else {
        return nil;
    }
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
 * @param order The order of the main subgroup of the elliptic curve.
 * @param cofactor The cofactor of the elliptic curve, i.e.
 * <code>#E<sub>a</sub>(F<sub>2<sup>m</sup></sub>) = h * n</code>.
 */
- (id)initWithM:(int)m withK:(int)k withA:(BigInteger*)a withB:(BigInteger*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor {
    if (self = [self initWithM:m withK1:k withK2:0 withK3:0 withA:a withB:b withOrder:order withCofactor:cofactor]) {
        return self;
    } else {
        return nil;
    }
}

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
- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3  withA:(BigInteger*)a withB:(BigInteger*)b {
    if (self = [self initWithM:m withK1:k1 withK2:k2 withK3:k3 withA:a withB:b withOrder:nil withCofactor:nil]) {
        return self;
    } else {
        return self;
    }
}

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
- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 withA:(BigInteger*)a withB:(BigInteger*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor {
    if (self = [super initWithM:m withK1:k1 withK2:k2 withK3:k3]) {
        [self setM:m];
        [self setK1:k1];
        [self setK2:k2];
        [self setK3:k3];
        [self setM_order:order];
        [self setM_cofactor:cofactor];
        F2mPoint *p = [[F2mPoint alloc] initWithCurve:self withX:nil withY:nil];
        [self setM_infinity:p];
#if !__has_feature(objc_arc)
        if (p != nil) [p release]; p = nil;
#endif
        if (k1 == 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"k1 must be > 0" userInfo:nil];
        }
        
        if (k2 == 0) {
            if (k3 != 0) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"k3 must be 0 if k2 == 0" userInfo:nil];
            }
        } else {
            if (k2 <= k1) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"k2 must be > k1" userInfo:nil];
            }
            if (k3 <= k2) {
                @throw [NSException exceptionWithName:@"Argument" reason:@"k3 must be > k2" userInfo:nil];
            }
        }
        @autoreleasepool {
            [self setM_a:[self fromBigInteger:a]];
            [self setM_b:[self fromBigInteger:b]];
        }
        [self setM_coord:F2M_DEFAULT_COORDS];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithM:(int)m withK1:(int)k1 withK2:(int)k2 withK3:(int)k3 withECFEA:(ECFieldElement*)a withECFEB:(ECFieldElement*)b withOrder:(BigInteger*)order withCofactor:(BigInteger*)cofactor {
    if (self = [self initWithM:m withK1:k1 withK2:k2 withK3:k3]) {
        [self setM:m];
        [self setK1:k1];
        [self setK2:k2];
        [self setK3:k3];
        [self setM_order:order];
        [self setM_cofactor:cofactor];
        
        F2mPoint *p = [[F2mPoint alloc] initWithCurve:self withX:nil withY:nil];
        [self setM_infinity:p];
#if !__has_feature(objc_arc)
        if (p != nil) [p release]; p = nil;
#endif
        [self setM_a:a];
        [self setM_b:b];
        [self setM_coord:F2M_DEFAULT_COORDS];
        return self;
    } else {
        return nil;
    }
}

- (ECCurve*)cloneCurve {
    return [[[F2mCurve alloc] initWithM:self.m withK1:self.k1 withK2:self.k2 withK3:self.k3 withECFEA:self.m_a withECFEB:self.m_b withOrder:self.m_order withCofactor:self.cofactor] autorelease];
}

- (BOOL)supportsCoordinateSystem:(int)coord {
    switch (coord) {
        case COORD_AFFINE:
        case COORD_HOMOGENEOUS:
        case COORD_LAMBDA_PROJECTIVE: {
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (ECMultiplier*)createDefaultMultiplier {
    if ([self isKoblitz]) {
        return [[[WTauNafMultiplier alloc] init] autorelease];
    }
    
    return [super createDefaultMultiplier];
}

- (int)fieldSize {
    return self.m;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[F2mFieldElement alloc] initWithM:self.m withK1:self.k1 withK2:self.k2 withK3:self.k3 withX:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[F2mPoint alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint *)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[F2mPoint alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

/**
 * Return true if curve uses a Trinomial basis.
 *
 * @return true if curve Trinomial, false otherwise.
 */
- (BOOL)isTrinomial {
    return self.k2 == 0 && self.k3 == 0;
}

- (BigInteger*)n {
    return self.m_order;
}

- (BigInteger*)h {
    return self.m_cofactor;
}

@end
