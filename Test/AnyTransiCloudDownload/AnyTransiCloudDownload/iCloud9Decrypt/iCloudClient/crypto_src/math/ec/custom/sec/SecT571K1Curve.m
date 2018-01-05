//
//  SecT571K1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT571K1Curve.h"
#import "SecT571K1Point.h"
#import "WTauNafMultiplier.h"
#import "SecT571FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT571K1Curve ()

@property (nonatomic, readwrite, retain) SecT571K1Point *m_infinity;

@end

@implementation SecT571K1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT571K1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:571 withK1:2 withK2:5 withK3:10]) {
        @autoreleasepool {
            SecT571K1Point *tmpPoint = [[SecT571K1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger Zero]]];
            [self setM_b:[self fromBigInteger:[BigInteger One]]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"020000000000000000000000000000000000000000000000000000000000000000000000131850E1F19A63E4B391A8DB917F4138B630D84BE5D639381E91DEB45CFE778F637C1001"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Four]];
            [self setM_coord:SecT571K1_DEFAULT_COORDS];
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
    return [[[SecT571K1Curve alloc] init] autorelease];
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
    return [[[SecT571K1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT571K1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return YES;
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
