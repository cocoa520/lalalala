//
//  SecT283R1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT283R1Curve.h"
#import "SecT283R1Point.h"
#import "SecT283FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT283R1Curve ()

@property (nonatomic, readwrite, retain) SecT283R1Point *m_infinity;

@end

@implementation SecT283R1Curve
@synthesize m_infinity = _m_infinity;

static int const SecT283R1_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:283 withK1:5 withK2:7 withK3:12]) {
        @autoreleasepool {
            SecT283R1Point *tmpPoint = [[SecT283R1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger One]]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"027B680AC8B8596DA5A4AF8A19A0303FCA97FD7645309FA2A581485AF6263E313B79A2F5"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF90399660FC938A90165B042A7CEFADB307"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Two]];
            [self setM_coord:SecT283R1_DEFAULT_COORDS];
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
    return [[[SecT283R1Curve alloc] init] autorelease];
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
    return 283;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT283FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT283R1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT283R1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (BOOL)isKoblitz {
    return NO;
}

- (int)M {
    return 283;
}

- (BOOL)isTrinomial {
    return NO;
}

- (int)K1 {
    return 5;
}

- (int)K2 {
    return 7;
}

- (int)K3 {
    return 12;
}

@end
