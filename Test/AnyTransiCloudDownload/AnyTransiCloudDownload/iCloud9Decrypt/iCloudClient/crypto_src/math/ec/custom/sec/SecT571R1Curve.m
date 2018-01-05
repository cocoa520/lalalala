//
//  SecT571R1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT571R1Curve.h"
#import "SecT571R1Point.h"
#import "SecT571FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT571R1Curve ()

@property (nonatomic, readwrite, retain) SecT571R1Point *m_infinity;

@end

@implementation SecT571R1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT571R1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

+ (SecT571FieldElement*)SecT571R1_B {
    static SecT571FieldElement *_secT571r1_b = nil;
    @synchronized(self) {
        if (_secT571r1_b == nil) {
            @autoreleasepool {
                BigInteger *tmpBI = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"02F40E7E2221F295DE297117B7F3D62F5C6A97FFCB8CEFF1CD6BA8CE4A9A18AD84FFABBD8EFA59332BE7AD6756A66E294AFD185A78FF12AA520E4DE739BACA0C7FFEFF7F2955727A"]];
                _secT571r1_b = [[SecT571FieldElement alloc] initWithBigInteger:tmpBI];
#if !__has_feature(objc_arc)
                if (tmpBI != nil) [tmpBI release]; tmpBI = nil;
#endif
            }
        }
    }
    return _secT571r1_b;
}

+ (SecT571FieldElement*)SecT571R1_B_SQRT {
    static SecT571FieldElement *_sect571r1_b_sqrt = nil;
    @synchronized(self) {
        if (_sect571r1_b_sqrt == nil) {
            _sect571r1_b_sqrt = [((SecT571FieldElement*)[[SecT571R1Curve SecT571R1_B] sqrt]) retain];
        }
    }
    return _sect571r1_b_sqrt;
}

- (id)init {
    if (self = [super initWithM:571 withK1:2 withK2:5 withK3:10]) {
        @autoreleasepool {
            SecT571R1Point *tmpPoint = [[SecT571R1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger One]]];
            [self setM_b:[SecT571R1Curve SecT571R1_B]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE661CE18FF55987308059B186823851EC7DD9CA1161DE93D5174D66E8382E9BB2FE84E47"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Two]];
            [self setM_coord:SecT571R1_DEFAULT_COORDS];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_infinity:nil];
    [super dealloc];
#endif
}

- (ECCurve*)cloneCurve {
    return [[[SecT571R1Curve alloc] init] autorelease];
}

- (BOOL)supportsCoordinateSystem:(int)coord {
    switch (coord) {
        case COORD_LAMBDA_PROJECTIVE: {
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return 571;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT571FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT571R1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT571R1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return NO;
}

- (int)M {
    return 571;
}

- (BOOL)isTrinomial {
    return NO;
}

- (int)K1 {
    return 2;
}

- (int)K2 {
    return 5;
}

- (int)K3 {
    return 10;
}

@end