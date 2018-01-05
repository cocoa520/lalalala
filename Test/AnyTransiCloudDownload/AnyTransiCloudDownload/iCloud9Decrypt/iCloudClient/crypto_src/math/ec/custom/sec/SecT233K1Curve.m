//
//  SecT233K1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT233K1Curve.h"
#import "SecT233K1Point.h"
#import "SecT233FieldElement.h"
#import "WTauNafMultiplier.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT233K1Curve ()

@property (nonatomic, readwrite, retain) SecT233K1Point *m_infinity;

@end

@implementation SecT233K1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT233K1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:233 withK1:74 withK2:0 withK3:0]) {
        @autoreleasepool {
            SecT233K1Point *tmpPoint = [[SecT233K1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger Zero]]];
            [self setM_b:[self fromBigInteger:[BigInteger One]]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"8000000000000000000000000000069D5BB915BCD46EFB1AD5F173ABDF"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Four]];
            [self setM_coord:SecT233K1_DEFAULT_COORDS];
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
    return [[[SecT233K1Curve alloc] init] autorelease];
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

- (ECMultiplier*)createDefaultMultiplier {
    return [[[WTauNafMultiplier alloc] init] autorelease];
}

- (int)fieldSize {
    return 233;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT233FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT233K1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT233K1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (BOOL)isKoblitz {
    return YES;
}

- (int)M {
    return 233;
}

- (BOOL)isTrinomial {
    return YES;
}

- (int)K1 {
    return 74;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

@end
