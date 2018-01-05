//
//  SecT131R2Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecT131R2Curve.h"
#import "SecT131R2Point.h"
#import "SecT131FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecT131R2Curve ()

@property (nonatomic, readwrite, retain) SecT131R2Point *m_infinity;

@end

@implementation SecT131R2Curve
@synthesize m_infinity = _m_infinity;

static int const SecT131R2_DEFAULT_COORDS = COORD_LAMBDA_PROJECTIVE;

- (id)init {
    if (self = [super initWithM:131 withK1:2 withK2:3 withK3:8]) {
        @autoreleasepool {
            SecT131R2Point *tmpPoint = [[SecT131R2Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            BigInteger *tmpa = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"03E5A88919D7CAFCBF415F07C2176573B2"]];
            [self setM_a:[self fromBigInteger:tmpa]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"04B8266A46C55657AC734CE38F018F2192"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"0400000000000000016954A233049BA98F"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpa != nil) [tmpa release]; tmpa = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Two]];
            [self setM_coord:SecT131R2_DEFAULT_COORDS];
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
    return [[[SecT131R2Curve alloc] init] autorelease];
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

- (int)fieldSize {
    return 131;
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecT131FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecT131R2Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecT131R2Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (BOOL)isKoblitz {
    return NO;
}

- (int)M {
    return 131;
}

- (BOOL)isTrinomial {
    return NO;
}

- (int)K1 {
    return 2;
}

- (int)K2 {
    return 3;
}

- (int)K3 {
    return 8;
}

@end
