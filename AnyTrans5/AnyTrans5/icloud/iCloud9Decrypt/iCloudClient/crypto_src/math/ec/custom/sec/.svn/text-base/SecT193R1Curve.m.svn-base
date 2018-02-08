//
//  SecT193R1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT193R1Curve.h"
#import "SecT193R1Point.h"
#import "SecT193FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT193R1Curve ()

@property (nonatomic, readwrite, retain) SecT193R1Point *m_infinity;

@end

@implementation SecT193R1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT193R1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:193 withK1:15 withK2:0 withK3:0]) {
        @autoreleasepool {
            SecT193R1Point *tmpPoint = [[SecT193R1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            BigInteger *tmpa = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"0017858FEB7A98975169E171F77B4087DE098AC8A911DF7B01"]];
            [self setM_a:[self fromBigInteger:tmpa]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"00FDFB49BFE6C3A89FACADAA7A1E5BBC7CC1C2E5D831478814"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"01000000000000000000000000C7F34A778F443ACC920EBA49"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpa != nil) [tmpa release]; tmpa = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Two]];
            [self setM_coord:SecT193R1_DEFAULT_COORDS];            
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
    return [[[SecT193R1Curve alloc] init] autorelease];
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
    return 193;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT193FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT193R1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT193R1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return NO;
}

- (int)M {
    return 193;
}

- (BOOL)isTrinomial {
    return YES;
}

- (int)K1 {
    return 15;
}

- (int)K2 {
    return 0;
}

- (int)K3 {
    return 0;
}

@end
