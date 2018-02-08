//
//  SecT239K1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT239K1Curve.h"
#import "SecT239K1Point.h"
#import "SecT239FieldElement.h"
#import "WTauNafMultiplier.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT239K1Curve ()

@property (nonatomic, readwrite, retain) SecT239K1Point *m_infinity;

@end

@implementation SecT239K1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT239K1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:239 withK1:158 withK2:0 withK3:0]) {
        @autoreleasepool {
            SecT239K1Point *tmpPoint = [[SecT239K1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger Zero]]];
            [self setM_b:[self fromBigInteger:[BigInteger One]]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"2000000000000000000000000000005A79FEC67CB6E91F1C1DA800E478A5"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Four]];
            [self setM_coord:SecT239K1_DEFAULT_COORDS];
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
    return [[[SecT239K1Curve alloc] init] autorelease];
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
    return 239;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT239FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT239K1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT239K1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return YES;
}

- (int)M {
    return 239;
}

- (BOOL)isTrinomial {
    return YES;
}

- (int)K1 {
    return 158;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

@end
