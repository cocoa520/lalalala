//
//  SecT163R1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT163R1Curve.h"
#import "SecT163R1Point.h"
#import "SecT163FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT163R1Curve ()

@property (nonatomic, readwrite, retain) SecT163R1Point *m_infinity;

@end

@implementation SecT163R1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT163R1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:163 withK1:3 withK2:6 withK3:7]) {
        @autoreleasepool {
            SecT163R1Point *tmpPoint = [[SecT163R1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            BigInteger *tmpa = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"07B6882CAAEFA84F9554FF8428BD88E246D2782AE2"]];
            [self setM_a:[self fromBigInteger:tmpa]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"0713612DCDDCB40AAB946BDA29CA91F73AF958AFD9"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"03FFFFFFFFFFFFFFFFFFFF48AAB689C29CA710279B"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpa != nil) [tmpa release]; tmpa = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Two]];
            [self setM_coord:SecT163R1_DEFAULT_COORDS];            
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
    return [[[SecT163R1Curve alloc] init] autorelease];
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
    return 163;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT163FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT163R1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT163R1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return NO;
}

- (int)M {
    return 163;
}

- (BOOL)isTrinomial {
    return NO;
}

- (int)K1 {
    return 3;
}

- (int)K2 {
    return 6;
}

- (int)K3 {
    return 7;
}

@end
