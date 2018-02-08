//
//  SecT233R1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT233R1Curve.h"
#import "SecT233R1Point.h"
#import "SecT233FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT233R1Curve ()

@property (nonatomic, readwrite, retain) SecT233R1Point *m_infinity;

@end

@implementation SecT233R1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT233R1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:233 withK1:74 withK2:0 withK3:0]) {
        @autoreleasepool {
            SecT233R1Point *tmpPoint = [[SecT233R1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger One]]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"0066647EDE6C332C7F8C0923BB58213B333B20E9CE4281FE115F7D8F90AD"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"01000000000000000000000000000013E974E72F8A6922031D2603CFE0D7"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Two]];
            [self setM_coord:SecT233R1_DEFAULT_COORDS];            
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
    return [[[SecT233R1Curve alloc] init] autorelease];
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
    return 233;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT233FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT233R1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT233R1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return NO;
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
